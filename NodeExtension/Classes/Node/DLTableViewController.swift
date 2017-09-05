//
//  DLTableViewController.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit
@available(*, deprecated, message: "Use DLNodeViewController instead.")
open class DLTableViewController: ASViewController<ASTableNode> {
    
    public var refreshControl: UIRefreshControl?
    public var hidesBarsOnSwipe = false
    public var hidesBackTitle = false
    
    private var _tableHeaderHeight: CGFloat?
    public var tableHeaderHeight: CGFloat = 0 {
        didSet {
            _tableHeaderHeight = tableHeaderHeight
            if self.node.isNodeLoaded {
                if tableHeaderHeight > 0 {
                    self.node.view.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: DLFrameSize.screenWidth, height: tableHeaderHeight))
                } else {
                    self.node.view.tableHeaderView = nil
                }
            }
        }
    }
    
    private var _tableFooterHeight: CGFloat?
    public var tableFooterHeight: CGFloat = 0 {
        didSet {
            _tableFooterHeight = tableFooterHeight
            if self.node.isNodeLoaded {
                if tableFooterHeight > 0 {
                    self.node.view.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: DLFrameSize.screenWidth, height: tableFooterHeight))
                } else {
                    self.node.view.tableFooterView = nil
                }
            }
        }
    }
    
    convenience public init() {
        self.init(style: .plain)
    }
    
    public init(style: UITableViewStyle = .plain) {
        super.init(node: ASTableNode(style: style))
        
        self.node.dataSource = self
        self.node.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // FIXME: https://github.com/TextureGroup/Texture/issues/471
        //        self.edgesForExtendedLayout = []
        
        if hidesBackTitle {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        if let _tableHeaderHeight = _tableHeaderHeight {
            tableHeaderHeight = _tableHeaderHeight
        }
        if let _tableFooterHeight = _tableFooterHeight {
            tableFooterHeight = _tableFooterHeight
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if hidesBarsOnSwipe {
            self.navigationController?.hidesBarsOnSwipe = true
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if hidesBarsOnSwipe {
            self.navigationController?.hidesBarsOnSwipe = false
        }
    }
    
    public func enableRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        refreshControl.attributedTitle = NSAttributedString.dl_attributedString(string: "Loading...", fontSize: 20, color: .lightGray)
        refreshControl.addTarget(self, action: #selector(tableViewWillRefresh(sender:)), for: .valueChanged)
        self.node.view.addSubview(refreshControl)
        self.refreshControl = refreshControl
    }
    
    @objc open func tableViewWillRefresh(sender: UIRefreshControl) {
        
    }
    
    public func tableViewEndRefreshing() {
        refreshControl?.endRefreshing()
    }
}

// MARK: - ASTableDataSource
extension DLTableViewController: ASTableDataSource {
    
}

// MARK: - ASTableDelegate
extension DLTableViewController: ASTableDelegate {
    open func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
    }
}
