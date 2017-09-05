//
//  DLViewNode.swift
//  NodeExtension
//
//  Created by Linzh on 8/28/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

open class DLViewNode<ViewType: UIView>: ASDisplayNode {
    
    private var _viewAssociations: [(ViewType) -> Void]?
    
    public var nodeView: ViewType {
        return self.view as! ViewType
    }
    
    public func appendViewAssociation(block: @escaping (ViewType) -> Void) {
        if self.isNodeLoaded {
            block(nodeView)
        } else {
            if _viewAssociations == nil {
                _viewAssociations = [(ViewType) -> Void]()
            }
            _viewAssociations!.append(block)
        }
    }
    
    open override func didLoad() {
        super.didLoad()
        
        viewAssociationWhenNodeLoaded()
    }
    
    private func viewAssociationWhenNodeLoaded() {
        guard let viewAssociations = _viewAssociations else {
            return
        }
        
        for block in viewAssociations {
            block(nodeView)
        }

        _viewAssociations = nil
    }

}
