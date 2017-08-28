//
//  DLViewNode.swift
//  NodeExtension
//
//  Created by Linzh on 8/28/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

open class DLViewNode: ASDisplayNode {
    
    private var _viewAssociations: [() -> Void]?
    
    public func appendViewAssociation(block: @escaping () -> Void) {
        if self.isNodeLoaded {
            block()
        } else {
            if _viewAssociations == nil {
                _viewAssociations = [() -> Void]()
            }
            _viewAssociations!.append(block)
        }
    }
    
    open override func didLoad() {
        super.didLoad()
        
        viewAssociationWhenNodeLoaded()
    }
    
    private func viewAssociationWhenNodeLoaded() {
        guard var viewAssociations = _viewAssociations else {
            return
        }
        
        for block in viewAssociations {
            block()
        }
        
        viewAssociations.removeAll()
        _viewAssociations = nil
    }
}
