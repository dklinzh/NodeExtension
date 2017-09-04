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
    
    private var _urlString: String?

    public init(urlString: String? = nil) {
        _urlString = urlString
        super.init()
        
        self.setViewBlock { () -> UIView in
            let webView = DLWebView()
            return webView
        }
    }
    
    open override func didLoad() {
        super.didLoad()
        
        if let urlString = _urlString {
            self.nodeView.load(urlString: urlString)
        }
    }
}
