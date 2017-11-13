//
//  DLFlowLayoutCollectionNode.swift
//  NodeExtension
//
//  Created by Daniel Lin on 08/09/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

open class DLFlowLayoutCollectionNode: ASCollectionNode {
    
    @objc
    public var numberOfColumns = 2

    @objc
    public init(collectionViewFlowLayout: UICollectionViewFlowLayout) {
        super.init(collectionViewLayout: collectionViewFlowLayout)
        
        self.dataSource = self
        self.delegate = self
        self.backgroundColor = .clear
    }
}

// MARK: - ASCollectionDataSource
@objc
extension DLFlowLayoutCollectionNode: ASCollectionDataSource {
    
}

// MARK: - ASCollectionDelegateFlowLayout
@objc
extension DLFlowLayoutCollectionNode: ASCollectionDelegateFlowLayout {
    
    public func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let flowLayout = collectionNode.collectionViewLayout as! UICollectionViewFlowLayout
        let columns = CGFloat(numberOfColumns)
        if flowLayout.scrollDirection == .vertical {
            let spacing = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * (columns - 1)
            let width = ((collectionNode.view.bounds.size.width - spacing) / columns).rounded(.down)
            
            return ASSizeRangeMake(CGSize(width: width, height: 0), CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        } else {
            let spacing = flowLayout.sectionInset.top + flowLayout.sectionInset.bottom + flowLayout.minimumInteritemSpacing * (columns - 1)
            let height = ((collectionNode.view.bounds.size.height - spacing) / columns).rounded(.down)
            
            return ASSizeRangeMake(CGSize(width: 0, height: height), CGSize(width: CGFloat.greatestFiniteMagnitude, height: height))
        }
    }
}
