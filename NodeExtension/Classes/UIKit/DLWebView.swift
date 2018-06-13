//
//  DLWebView.swift
//  NodeExtension
//
//  Created by Linzh on 9/3/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import WebKit

public protocol DLWebViewDelegate: class {
    func dl_webView(_ webView: DLWebView, didStartLoading url: URL?)
    func dl_webView(_ webView: DLWebView, didFinishLoading url: URL?)
    func dl_webView(_ webView: DLWebView, didFailToLoad url: URL?, error: Error?)
    func dl_webView(_ webView: DLWebView, decidePolicyFor navigationResponse: WKNavigationResponse) -> WKNavigationResponsePolicy
    func dl_webView(_ webView: DLWebView, decidePolicyFor navigationAction: WKNavigationAction) -> WKNavigationActionPolicy
}

public extension DLWebViewDelegate {
    func dl_webView(_ webView: DLWebView, didStartLoading url: URL?) {}
    func dl_webView(_ webView: DLWebView, didFinishLoading url: URL?) {}
    func dl_webView(_ webView: DLWebView, didFailToLoad url: URL?, error: Error?) {}
    func dl_webView(_ webView: DLWebView, decidePolicyFor navigationResponse: WKNavigationResponse) -> WKNavigationResponsePolicy { return .allow }
    func dl_webView(_ webView: DLWebView, decidePolicyFor navigationAction: WKNavigationAction) -> WKNavigationActionPolicy { return .allow }
}

public extension WKWebView {
    
    @available(iOS 11.0, *)
    func dl_getCookies(for domain: String? = nil, completion: @escaping ([String : Any]) -> Void)  {
        var cookieDict = [String : Any]()
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in
            for cookie in cookies {
                if let domain = domain {
                    if cookie.domain.contains(domain) {
                        cookieDict[cookie.name] = cookie.properties
                    }
                } else {
                    cookieDict[cookie.name] = cookie.properties
                }
            }
            completion(cookieDict)
        }
    }
    
    static func dl_getJSCookiesString(cookies: [HTTPCookie]) -> String {
        var result = ""
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        for cookie in cookies {
            result += "document.cookie='\(cookie.name)=\(cookie.value); domain=\(cookie.domain); path=\(cookie.path); "
            if let date = cookie.expiresDate {
                result += "expires=\(dateFormatter.string(from: date)); "
            }
            if (cookie.isSecure) {
                result += "secure; "
            }
            result += "'; "
        }
        return result
    }
    
    /// Removes the all types of website data records from WKWebsiteDataStore.
    public func dl_removeAllWebsiteDataRecords() {
        if #available(iOS 9.0, *) {
            let dataStore = WKWebsiteDataStore.default()
            dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
                dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records, completionHandler: {
                    
                })
            }
        } else {
            let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
            let cookiesFolderPath = libraryPath + "/Cookies"
            try? FileManager.default.removeItem(atPath: cookiesFolderPath)
        }
    }
}

open class DLWebView: WKWebView {
    
    public weak var dl_webViewDelegate: DLWebViewDelegate?
    
    public lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = UIColor(white: 1.0, alpha: 0.0)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        return progressView
    }()
    
    public var isProgressShown: Bool = false {
        didSet {
            if oldValue == isProgressShown {
                return
            }
            
            if isProgressShown {
                self.addSubview(progressView)
                self.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: [], context: &progressContext)
            } else {
                progressView.removeFromSuperview()
                self.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
            }
        }
    }
    
    public var shouldPreviewElementBy3DTouch = false
    
    public var customHTTPHeaderFields: [String : String]?
    
    private var _validSchemes = Set<String>(["http", "https", "tel", "file"])
    
    private var progressContext = 0
    private var pageTitleContext = 0
    fileprivate var _authenticated = false
    fileprivate var _failedRequest: URLRequest?
    private var _sharedCookiesInjection = false
    private var _pageTitleBlock: ((_ title: String?) -> Void)?
    
    public convenience init(sharedCookiesInjection: Bool = false, userScalable: Bool = false) {
        let webViewConfig = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        
        if sharedCookiesInjection, let cookies = HTTPCookieStorage.shared.cookies {
            let script = WKWebView.dl_getJSCookiesString(cookies: cookies)
            let cookieScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            userContentController.addUserScript(cookieScript)
        }
        
        if !userScalable {
            let script = """
                var script = document.createElement('meta');
                script.name = 'viewport';
                script.content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";
                document.getElementsByTagName('head')[0].appendChild(script);
            """
            let scaleScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            userContentController.addUserScript(scaleScript)
        }
        
        webViewConfig.userContentController = userContentController
        self.init(frame: .zero, configuration: webViewConfig)
        
        _sharedCookiesInjection = sharedCookiesInjection
    }
    
    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        
        self.navigationDelegate = self
        self.uiDelegate = self
        self.isMultipleTouchEnabled = true
        self.scrollView.alwaysBounceVertical = true
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } 
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if isProgressShown {
            self.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        }
        
        if _pageTitleBlock != nil {
            self.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if isProgressShown {
            var frame = self.bounds
            frame.size.height = progressView.frame.size.height
            progressView.frame = frame
        }
    }
    
    public func addCustomValidSchemes(_ schemes: [String]) {
        schemes.forEach { (scheme) in
            self._validSchemes.insert(scheme.lowercased())
        }
    }
    
    public func load(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        load(url: url)
    }
    
    public func load(url: URL) {
        self.load(URLRequest(url: url))
    }
    
    @discardableResult
    open override func load(_ request: URLRequest) -> WKNavigation? {
        var mutableRequest = request
        if _sharedCookiesInjection, let cookies = HTTPCookieStorage.shared.cookies {
            if let allHTTPHeaderFields = mutableRequest.allHTTPHeaderFields {
                if allHTTPHeaderFields.index(forKey: "Cookie") == nil {
                    HTTPCookie.requestHeaderFields(with: cookies).forEach { mutableRequest.allHTTPHeaderFields![$0] = $1 }
                }
            } else {
                mutableRequest.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cookies)
            }
        }
        if let httpHeaderFields = customHTTPHeaderFields {
            if mutableRequest.allHTTPHeaderFields != nil {
                httpHeaderFields.forEach { mutableRequest.allHTTPHeaderFields![$0] = $1 }
            } else {
                mutableRequest.allHTTPHeaderFields = httpHeaderFields
            }
        }
        
        return super.load(mutableRequest)
    }
    
    public func loadHTML(filePath: String) {
        let html = try! String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
        self.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }
    
    public func pageTitleDidChange(_ block: ((_ title: String?) -> Void)?) {
        if (_pageTitleBlock == nil && block == nil) || (_pageTitleBlock != nil && block != nil) {
            _pageTitleBlock = block
            return
        }
        
        _pageTitleBlock = block
        if block != nil {
            self.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: [], context: &pageTitleContext)
        } else {
            self.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) && context == &progressContext {
            progressView.alpha = 1.0
            let progress = Float(self.estimatedProgress)
            let animated: Bool = progress > progressView.progress
            progressView.setProgress(progress, animated: animated)
            
            if progress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: { 
                    self.progressView.alpha = 0.0
                }, completion: { (finished: Bool) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        } else if keyPath == #keyPath(WKWebView.title) && context == &pageTitleContext {
            _pageTitleBlock?(self.title)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    fileprivate func externalAppRequiredToOpen(url: URL) -> Bool {
        guard let scheme = url.scheme else {
            return false
        }
        
        return !_validSchemes.contains(scheme)
    }
    
    fileprivate func launchExternalApp(url: URL) {
        let alertController = UIAlertController(title: "Leave current app?", message: "This web page is trying to open an outside app. Are you sure you want to open it?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let openAction = UIAlertAction(title: "Open App", style: .default) { (action) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        alertController.addAction(openAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true)
    }
}

// MARK: - WKNavigationDelegate
extension DLWebView: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        dl_webViewDelegate?.dl_webView(webView as! DLWebView, didStartLoading: webView.url)
        
        let progress = Float(self.estimatedProgress) + 0.1
        if progress >= 1.0 {
            progressView.setProgress(0.95, animated: true)
        } else {
            progressView.setProgress(progress, animated: true)
        }
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        dl_webViewDelegate?.dl_webView(webView as! DLWebView, didFinishLoading: webView.url)
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        dl_webViewDelegate?.dl_webView(webView as! DLWebView, didFailToLoad: webView.url, error: error)
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        dl_webViewDelegate?.dl_webView(webView as! DLWebView, didFailToLoad: webView.url, error: error)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        if !externalAppRequiredToOpen(url: url) {
            if navigationAction.targetFrame == nil {
                load(url: url)
                decisionHandler(.cancel)
                return
            }
        } else if UIApplication.shared.canOpenURL(url) {
            launchExternalApp(url: url)
            decisionHandler(.cancel)
            return
        }
        
//        if let httpHeaderFields = customHTTPHeaderFields {
//            if let allHTTPHeaderFields = navigationAction.request.allHTTPHeaderFields {
//                if httpHeaderFields.contains(where: { (key, value) -> Bool in
//                    return allHTTPHeaderFields[key] != value
//                }) {
//                    decisionHandler(.cancel)
//                    self.load(navigationAction.request)
//                    return
//                }
//            } else {
//                decisionHandler(.cancel)
//                self.load(navigationAction.request)
//                return
//            }
//        }
        
        decisionHandler(dl_webViewDelegate?.dl_webView(webView as! DLWebView, decidePolicyFor: navigationAction) ?? .allow)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(dl_webViewDelegate?.dl_webView(webView as! DLWebView, decidePolicyFor: navigationResponse) ?? .allow)
    }
    
    @available(iOS 9.0, *) // FIXME: WebContent Process Crash
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload() // & webView.titile will be nil when it crash, then reload the webview
    }
}

// MARK: - WKUIDelegate
extension DLWebView: WKUIDelegate {
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let isMainFrame = navigationAction.targetFrame?.isMainFrame, isMainFrame else {
            self.load(navigationAction.request)
            return nil
        }
        
        return nil
    }
    
    @available(iOS 10.0, *)
    public func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return shouldPreviewElementBy3DTouch
    }
}

// FIXME: HTTPS request with self-signed certificate
// MARK: - NSURLConnectionDataDelegate
extension DLWebView: NSURLConnectionDataDelegate {
    
    public func connection(_ connection: NSURLConnection, willSendRequestFor challenge: URLAuthenticationChallenge) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let trust = challenge.protectionSpace.serverTrust {
                let credential = URLCredential(trust: trust)
                challenge.sender?.use(credential, for: challenge)
            }
        }
        challenge.sender?.continueWithoutCredential(for: challenge)
    }
    
    public func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        _authenticated = true
        connection.cancel()
        if let failedRequest = _failedRequest {
            _ = self.load(failedRequest)
        }
    }
}
