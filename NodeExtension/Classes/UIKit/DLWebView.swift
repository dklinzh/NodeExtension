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
}

public extension DLWebViewDelegate {
    func dl_webView(_ webView: DLWebView, didStartLoading url: URL?) {}
    func dl_webView(_ webView: DLWebView, didFinishLoading url: URL?) {}
    func dl_webView(_ webView: DLWebView, didFailToLoad url: URL?, error: Error?) {}
    func dl_webView(_ webView: DLWebView, decidePolicyFor navigationResponse: WKNavigationResponse) -> WKNavigationResponsePolicy { return .allow }
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
}

open class DLWebView: WKWebView {
    
    public weak var dl_webViewDelegate: DLWebViewDelegate?
    
    public lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = UIColor(white: 1.0, alpha: 0.0)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        return progressView
    }()
    
    // FIXME: localization
    public lazy var externalAppPermissionAlertView: UIAlertView = {
       return UIAlertView(title: "Leave this app?", message: "This web page is trying to open an outside app. Are you sure you want to open it?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Open App")
    }()
    
    public var isProgressShown: Bool = false {
        didSet {
            if isProgressShown {
                self.addSubview(progressView)
                self.addObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: estimatedProgress)), options: [], context: &progressContext)
            } else {
                progressView.removeFromSuperview()
                self.removeObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: estimatedProgress)))
            }
        }
    }
    private var progressContext = 0
    fileprivate var _authenticated = false
    fileprivate var _failedRequest: URLRequest?
    private var _sharedCookiesInjection = false
    
    private let validSchemes = Set<String>(["http", "https", "tel", "file"])
    fileprivate var urlToLaunchWithPermission: URL?
    
    public convenience init(sharedCookiesInjection: Bool = false) {
        let webViewConfig = WKWebViewConfiguration()
        if sharedCookiesInjection, let cookies = HTTPCookieStorage.shared.cookies {
            let script = WKWebView.dl_getJSCookiesString(cookies: cookies)
            let cookieScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            
            let userContentController = WKUserContentController()
            userContentController.addUserScript(cookieScript)
            webViewConfig.userContentController = userContentController
        }
        self.init(frame: .zero, configuration: webViewConfig)
        
        _sharedCookiesInjection = sharedCookiesInjection
    }
    
    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        
        self.navigationDelegate = self
        self.uiDelegate = self
        self.isMultipleTouchEnabled = true
        self.scrollView.alwaysBounceVertical = true
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if isProgressShown {
            self.removeObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: estimatedProgress)))
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
    
    public func load(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        load(url: url)
    }
    
    public func load(url: URL) {
        _ = self.load(URLRequest(url: url))
    }
    
    open override func load(_ request: URLRequest) -> WKNavigation? {
        if _sharedCookiesInjection, let cookies = HTTPCookieStorage.shared.cookies {
            var req = URLRequest(url: request.url!)
            req.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cookies)
            return super.load(req)
        }
        
        return super.load(request)
    }
    
    public func loadHTML(filePath: String) {
        let html = try! String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
        self.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == NSStringFromSelector(#selector(getter: estimatedProgress)) && context == &progressContext {
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
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    fileprivate func externalAppRequiredToOpen(url: URL) -> Bool {
        guard let scheme = url.scheme else {
            return false
        }
        
        return !validSchemes.contains(scheme)
    }
    
    fileprivate func launchExternalApp(url: URL) {
        urlToLaunchWithPermission = url
        if !externalAppPermissionAlertView.isVisible {
            externalAppPermissionAlertView.show()
        }
    }
}

// MARK: - WKNavigationDelegate
extension DLWebView: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        dl_webViewDelegate?.dl_webView(webView as! DLWebView, didStartLoading: webView.url)
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
        
        decisionHandler(.allow)
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
        guard let targetFrame = navigationAction.targetFrame else {
            return nil
        }
        
        if !targetFrame.isMainFrame {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

// MARK: - UIAlertViewDelegate
extension DLWebView: UIAlertViewDelegate {
    
    public func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if alertView == externalAppPermissionAlertView {
            if buttonIndex != alertView.cancelButtonIndex {
                UIApplication.shared.openURL(urlToLaunchWithPermission!)
            }
            urlToLaunchWithPermission = nil
        }
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
