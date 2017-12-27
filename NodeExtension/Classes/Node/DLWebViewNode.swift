//
//  DLWebViewNode.swift
//  NodeExtension
//
//  Created by Daniel Lin on 01/09/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit
import WebKit

open class DLWebViewNode: DLViewNode<DLWebView> {
    
    public var isLoading: Bool {
        return self.nodeView.isLoading
    }
    
    public var isProgressShown: Bool {
        get {
            return self.nodeView.isProgressShown
        }
        set {
            self.appendViewAssociation { (view: DLWebView) in
                view.isProgressShown = newValue
            }
        }
    }
    
    public var progressTintColor: UIColor {
        get {
            return self.nodeView.progressView.tintColor
        }
        set {
            self.appendViewAssociation { (view: DLWebView) in
                view.progressView.tintColor = newValue
            }
        }
    }
    
    public init(sharedCookiesInjection: Bool = false) {
        super.init()
        
        self.setViewBlock { () -> UIView in
            let webView = DLWebView(sharedCookiesInjection: sharedCookiesInjection)
            return webView
        }
    }
    
    public override init() {
        super.init()
        
        self.setViewBlock { () -> UIView in
            let webView = DLWebView()
            return webView
        }
    }
    
    public func load(urlString: String) {
        self.appendViewAssociation { (view: DLWebView) in
            view.load(urlString: urlString)
        }
    }
    
    public func loadHTML(filePath: String) {
        self.appendViewAssociation { (view: DLWebView) in
            view.loadHTML(filePath: filePath)
        }
    }
    
    public func load(url: URL) {
        self.appendViewAssociation { (view: DLWebView) in
            view.load(url: url)
        }
    }

}
