//
//  String.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

/// Get localized string for the specified key from a custom table
///
/// - Parameters:
///   - key: The specified key
///   - tableName: The custom table
/// - Returns: Localized string from the specified strings table
public func DLLocalizedString(_ key: String, tableName: String? = "Localizable") -> String {
    return NSLocalizedString(key, tableName: tableName, comment: "")
}

extension NSAttributedString {
    
    /// Create a NSAttributedString with some attributes
    ///
    /// - Parameters:
    ///   - string: The string for the new attributed string
    ///   - size: The font size of attributed string
    ///   - color: The color of attributed string
    /// - Returns: A NSAttributedString instance
    public static func dl_attributedString(string: String, fontSize size: CGFloat, color: UIColor = .black) -> NSAttributedString {
        return NSAttributedString.dl_attributedString(string: string, fontSize: size, color: color, firstWordColor: nil)
    }
    
    /// Create a NSAttributedString with some attributes
    ///
    /// - Parameters:
    ///   - string: The string for the new attributed string
    ///   - size: The font size of attributed string
    ///   - color: The color of attributed string
    ///   - firstWordColor: The color of frist word
    /// - Returns: A NSAttributedString instance
    public static func dl_attributedString(string: String, fontSize size: CGFloat, color: UIColor = .black, firstWordColor: UIColor? = nil) -> NSAttributedString {
        let attributes = [NSAttributedStringKey.foregroundColor: color,
                          NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)]
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        
        if let firstWordColor = firstWordColor {
            let nsString = string as NSString
            let firstSpaceRange = nsString.rangeOfCharacter(from: NSCharacterSet.whitespaces)
            let firstWordRange  = NSMakeRange(0, firstSpaceRange.location)
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: firstWordColor, range: firstWordRange)
        }
        
        return attributedString
    }
    
    /// Add attributs of font size and text color to the NSAttributedString
    ///
    /// - Parameters:
    ///   - range: The range of characters to which the specified attributes apply
    ///   - font: The font of text
    ///   - color: The text color
    /// - Returns: A NSAttributedString instance
    public func dl_stringAddAttribute(range: NSRange, font: UIFont, color: UIColor) -> NSAttributedString {
        guard range.location != NSNotFound else {
            return self
        }
        
        let attributedString = self.mutableCopy() as! NSMutableAttributedString
        let attributes = [NSAttributedStringKey.foregroundColor: color,
                          NSAttributedStringKey.font: font]
        attributedString.addAttributes(attributes, range: range)
        return attributedString
    }
    
}
