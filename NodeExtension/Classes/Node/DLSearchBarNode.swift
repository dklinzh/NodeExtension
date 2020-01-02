//
//  DLSearchBarNode.swift
//  NodeExtension
//
//  Created by Daniel Lin on 2018/12/4.
//

import AsyncDisplayKit
import UIKit

open class DLSearchBarNode: DLViewNode<UISearchBar>, UISearchResultsUpdating, UISearchBarDelegate {
    public typealias UpdateSearchResultsBlock = (_ searchController: UISearchController) -> Void

    public typealias SearchButtonClickedBlock = (_ searchBar: UISearchBar) -> Void

    public let searchResultsController: UIViewController?

    public lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultsController)
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = true
        } else {
            searchController.dimsBackgroundDuringPresentation = true
        }
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self

        let searchBar = searchController.searchBar
        appearanceSetup(searchBar: searchBar)
        return searchController
    }()

    open func appearanceSetup(searchBar: UISearchBar) {
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .white
        searchBar.isTranslucent = false
        searchBar.delegate = self
    }

    private var _updateSearchResultsBlock: UpdateSearchResultsBlock?
    private var _searchButtonClickedBlock: SearchButtonClickedBlock?

    public init(searchResultsController: UIViewController? = nil) {
        self.searchResultsController = searchResultsController
        super.init()

        setViewBlock { [unowned self] () -> UIView in
            if searchResultsController == nil {
                let searchBar = UISearchBar()
                self.appearanceSetup(searchBar: searchBar)
                return searchBar
            } else {
                return self.searchController.searchBar
            }
        }

        style.minHeight = ASDimensionMake(44.0)
    }

    public func setUpdateSearchResultsBlock(_ block: @escaping UpdateSearchResultsBlock) {
        _updateSearchResultsBlock = block
    }

    public func setSearchButtonClickedBlock(_ block: @escaping SearchButtonClickedBlock) {
        _searchButtonClickedBlock = block
    }

    // MARK: - UISearchResultsUpdating

    open func updateSearchResults(for searchController: UISearchController) {
        _updateSearchResultsBlock?(searchController)
    }

    // MARK: - UISearchBarDelegate

    open func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        _searchButtonClickedBlock?(searchBar)
    }
}
