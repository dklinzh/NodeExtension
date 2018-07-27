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
    
    public var tableSectionColor = UIColor.clear
    
    private var _tableHeaderHeight: CGFloat?
    public var tableHeaderHeight: CGFloat = 0 {
        didSet {
            _tableHeaderHeight = tableHeaderHeight
            if self.isNodeLoaded {
                if tableHeaderHeight > 0 {
                    let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: tableHeaderHeight))
                    view.backgroundColor = tableSectionColor
                    self.view.tableHeaderView = view
                } else {
                    self.view.tableHeaderView = UIView()
                }
            }
        }
    }
    
    private var _tableFooterHeight: CGFloat = 0
    public var tableFooterHeight: CGFloat = 0 {
        didSet {
            _tableFooterHeight = tableFooterHeight
            if self.isNodeLoaded {
                if tableFooterHeight > 0 {
                    let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: tableFooterHeight))
                    view.backgroundColor = tableSectionColor
                    self.view.tableFooterView = view
                } else {
                    self.view.tableFooterView = UIView()
                }
            }
        }
    }
    
    public var cellHighlightColor: UIColor?
    public var cellUnhighlightColor: UIColor?
    
    public override init(style: UITableViewStyle) {
        super.init(style: style)
        
        self.backgroundColor = .clear

        self.delegate = self
    }
    
    open override func didLoad() {
        super.didLoad()
        
        if let _tableHeaderHeight = _tableHeaderHeight {
            tableHeaderHeight = _tableHeaderHeight
        }
        tableFooterHeight = _tableFooterHeight
        
        if _shouldEnableRefreshControl {
            initRefreshControl()
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

// MARK: - ASTableDelegate
extension DLTableNode: ASTableDelegate {

    open func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
    }
    
    open func tableNode(_ tableNode: ASTableNode, didHighlightRowAt indexPath: IndexPath) {
        if let cellHighlightColor = cellHighlightColor,
            let cell = tableNode.nodeForRow(at: indexPath) {
            cell.backgroundColor = cellHighlightColor
        }
    }
    
    open func tableNode(_ tableNode: ASTableNode, didUnhighlightRowAt indexPath: IndexPath) {
        if let cellUnhighlightColor = cellUnhighlightColor,
            let cell = tableNode.nodeForRow(at: indexPath) {
            cell.backgroundColor = cellUnhighlightColor
        }
    }
}

// MARK: - UITableViewDelegate
extension DLTableNode {

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = tableSectionColor
        return view
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = tableSectionColor
        return view
    }
}
