//
//  Font.swift
//  NodeExtension
//
//  Created by Daniel Lin on 05/09/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

extension UIFont {
    
    public func dl_heightOfLine(lineNumber: UInt = 1) -> CGFloat {
        return ceil(self.lineHeight) * CGFloat(lineNumber)
    }
}

extension UILabel {
    
    public func dl_size() -> CGSize {
        return self.textRect(forBounds: UIScreen.main.bounds, limitedToNumberOfLines: 1).size
    }
    
    public func dl_maxSize(_ size: CGSize) -> CGSize {
        let number = self.numberOfLines
        return self.textRect(forBounds: CGRect(x: 0, y: 0, width: size.width, height: size.height), limitedToNumberOfLines: number).size
    }
}

extension String {
    
    public func dl_size(font: UIFont) -> CGSize {
        let label = UILabel()
        label.text = self
        label.font = font
        return label.dl_size()
    }
    
    public func dl_maxSize(_ size: CGSize, font: UIFont, numberOfLines: Int = 1) -> CGSize {
        let label = UILabel()
        label.text = self
        label.font = font
        label.numberOfLines = numberOfLines
        return label.dl_maxSize(size)
    }
}

extension NSAttributedString {
    
    public func dl_size() -> CGSize {
        let label = UILabel()
        label.attributedText = self
        return label.dl_size()
    }
    
    public func dl_maxSize(_ size: CGSize, numberOfLines: Int = 1) -> CGSize {
        let label = UILabel()
        label.attributedText = self
        label.numberOfLines = numberOfLines
        return label.dl_maxSize(size)
    }
}
