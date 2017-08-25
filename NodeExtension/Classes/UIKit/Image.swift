//
//  Image.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

// MARK: - Image Size
extension UIImage {
    
    /// Make the image circular by 'Precomoposed Alpha Corners'
    ///
    /// - Parameters:
    ///   - size: The size of image
    ///   - width: The with of border
    /// - Returns: An UIImage object
    public func dl_makeCircularImage(size: CGSize, borderWidth width: CGFloat) -> UIImage {
        // make a CGRect with the image's size
        let circleRect = CGRect(origin: .zero, size: size)
        
        // begin the image context since we're not in a drawRect:
        UIGraphicsBeginImageContextWithOptions(circleRect.size, false, 0)
        
        // create a UIBezierPath circle
        let circle = UIBezierPath(roundedRect: circleRect, cornerRadius: circleRect.size.width * 0.5)
        
        // clip to the circle
        circle.addClip()
        
        UIColor.white.set()
        circle.fill()
        
        // draw the image in the circleRect *AFTER* the context is clipped
        self.draw(in: circleRect)
        
        // create a border (for white background pictures)
        if width > 0 {
            circle.lineWidth = width
            UIColor.white.set()
            circle.stroke()
        }
        
        // get an image from the image context
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // end the image context since we're not in a drawRect:
        UIGraphicsEndImageContext()
        
        return roundedImage ?? self
    }
    
    /// Compress the data of image
    ///
    /// - Parameters:
    ///   - maxSize: The maximum size(bytes) of image
    ///   - minRatio: The minimum ratio for image compression. (minRatio >= maxRatio)
    ///   - maxRatio: The maximum ratio for image compression. (maxRatio <= minRatio)
    /// - Returns: The data of image
    public func dl_dataCompression(maxSize: Int, minRatio: CGFloat, maxRatio: CGFloat) -> NSData {
        let r = (minRatio - maxRatio) / 10
        var ratio = minRatio
        var imageData = UIImageJPEGRepresentation(self, 1.0)! as NSData
        
        while imageData.length > maxSize && ratio > maxRatio {
            imageData = UIImageJPEGRepresentation(self, ratio)! as NSData
            ratio -= r
        }
        
        return imageData
    }
}

// MARK: - Image Color
extension UIImage {
    
    public func dl_gradientTintedImage(tintColor: UIColor) -> UIImage {
        return self.dl_tintedImage(tintColor: tintColor, blendMode: .overlay)
    }
    
    public func dl_tintedImage(tintColor: UIColor, blendMode: CGBlendMode = .destinationIn) -> UIImage {
        //Set opaque to false for keepping alpha; Use 0.0 on scale to use the scale factor of the device’s main screen
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        tintColor.setFill()
        let bounds = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        
        // Draw the tinted image in context
        self.draw(in: bounds, blendMode: blendMode, alpha: 1.0)
        if blendMode != .destinationIn {
            self.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
        }
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage ?? self
    }
    
    public func dl_highlightedImage(alpha: CGFloat = 0.7) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        let bounds = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: bounds, blendMode: .normal, alpha: alpha)
        self.draw(in: bounds, blendMode: .colorBurn, alpha: alpha)
        
        let highlightedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return highlightedImage ?? self
    }
}
