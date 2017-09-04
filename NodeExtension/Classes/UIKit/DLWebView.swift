//
//  DLWebView.swift
//  NodeExtension
//
//  Created by Linzh on 9/3/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import WebKit

open class DLWebView: WKWebView {
    
    public lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = UIColor(white: 1.0, alpha: 0.0)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        return progressView
    }()
    
    public var isProgressShown = false
    public var didFinishLoading = false
    
    fileprivate var _authenticated = false
    
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
        
        self.load(URLRequest(url: url))
    }
}

// MARK: - WKNavigationDelegate
extension DLWebView: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        didFinishLoading = false
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        didFinishLoading = true
    }
}

// MARK: - WKUIDelegate
extension DLWebView: WKUIDelegate {
    
}

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
        
    }
}
