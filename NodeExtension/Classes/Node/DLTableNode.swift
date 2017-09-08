//
//  DLTableNode.swift
//  Pods
//
//  Created by Daniel Lin on 08/09/2017.
//
//

import AsyncDisplayKit

open class DLTableNode: ASTableNode {
    
    public typealias TableViewWillRefresh = (_ sender: UIRefreshControl) -> Void

    public var refreshControl: UIRefreshControl?
    private var _shouldEnableRefreshControl = false
    private var _willRefresh: TableViewWillRefresh?
    
    private var _tableHeaderHeight: CGFloat?
    public var tableHeaderHeight: CGFloat = 0 {
        didSet {
            _tableHeaderHeight = tableHeaderHeight
            if _isViewLoaded {
                if tableHeaderHeight > 0 {
                    self.view.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: tableHeaderHeight))
                } else {
                    self.view.tableHeaderView = nil
                }
            }
        }
    }
    
    private var _tableFooterHeight: CGFloat?
    public var tableFooterHeight: CGFloat = 0 {
        didSet {
            _tableFooterHeight = tableFooterHeight
            if _isViewLoaded {
                if tableFooterHeight > 0 {
                    self.view.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: tableFooterHeight))
                } else {
                    self.view.tableFooterView = nil
                }
            }
        }
    }
    
    private var _isViewLoaded = false
    
    public override init(style: UITableViewStyle) {
        super.init(style: style)
        
        self.dataSource = self
        self.delegate = self
    }
    
    open override func didLoad() {
        super.didLoad()
        
        if _shouldEnableRefreshControl {
            initRefreshControl()
        }
    }
    
    open override func layout() {
        super.layout()
        
        if _isViewLoaded {
            _isViewLoaded = true
            
            if let _tableHeaderHeight = _tableHeaderHeight {
                tableHeaderHeight = _tableHeaderHeight
            }
            if let _tableFooterHeight = _tableFooterHeight {
                tableFooterHeight = _tableFooterHeight
            }
        }
    }
    
    public func enableRefreshControl(willRefresh: TableViewWillRefresh? = nil) {
        _willRefresh = willRefresh
        
        if self.isNodeLoaded {
            _shouldEnableRefreshControl = false
            
            initRefreshControl()
        } else {
            _shouldEnableRefreshControl = true
        }
    }
    
    private func initRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        refreshControl.attributedTitle = NSAttributedString.dl_attributedString(string: "Loading...", fontSize: 20, color: .lightGray)
        refreshControl.addTarget(self, action: #selector(tableViewWillRefresh(sender:)), for: .valueChanged)
        self.view.addSubview(refreshControl)
        self.refreshControl = refreshControl
    }
    
    @objc open func tableViewWillRefresh(sender: UIRefreshControl) {
        _willRefresh?(sender)
    }
    
    public func tableViewEndRefreshing() {
        refreshControl?.endRefreshing()
    }
}

// MARK: - ASTableDataSource
extension DLTableNode: ASTableDataSource {
    
}

// MARK: - ASTableDelegate
extension DLTableNode: ASTableDelegate {
    open func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
    }
}
