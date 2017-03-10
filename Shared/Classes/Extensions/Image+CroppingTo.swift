//
//  Image+CroppedTo.swift
//  SoftCells
//
//  Created by Tom Heinan on 3/6/17.
//  Copyright © 2017 Tom Heinan. All rights reserved.
//

import CoreGraphics
#if os(OSX)
    import AppKit
    typealias Image = NSImage
#else
    import UIKit
    typealias Image = UIImage
#endif

extension Image {
    
    func cropping(to rect: CGRect) -> Image? {
        #if os(OSX)
            let ump = UnsafeMutablePointer<NSRect>.allocate(capacity: 1)
            guard let cgImage = cgImage(forProposedRect: ump, context: NSGraphicsContext.current(), hints: nil) else { return nil }
            let screenScale = 1.0
        #else
            guard let cgImage = cgImage else { return nil }
            let screenScale = UIScreen.main.scale
        #endif
        
        let initialCropFrame = rect.offsetBy(dx: -rect.origin.x, dy: -rect.origin.y)
        let cropSize = initialCropFrame
        let imageSize = size
        let scaleFactor = CGFloat.minimum(imageSize.width / cropSize.width, imageSize.height / cropSize.height)
        
        // scale the crop frame
        
        let scaleTransform = CGAffineTransform(scaleX: scaleFactor * CGFloat(pow(screenScale, 2)), y: scaleFactor * CGFloat(pow(screenScale, 2)))
        let scaledCropFrame = initialCropFrame.applying(scaleTransform)
        
        // center the crop frame
        
        let finalCropFrame: CGRect
        if scaledCropFrame.size.width < size.width {
            finalCropFrame = CGRect(x: (size.width / 2) - (scaledCropFrame.size.width / 2), y: 0, width: scaledCropFrame.size.width, height: scaledCropFrame.size.height)
        } else {
            finalCropFrame = CGRect(x: 0, y:  (size.height / 2) - (scaledCropFrame.size.height / 2), width: scaledCropFrame.size.width, height: scaledCropFrame.size.height)
        }
        
        guard let croppedImage = cgImage.cropping(to: finalCropFrame) else { return self }
        
        #if os(OSX)
            return Image(cgImage: croppedImage, size: scaledCropFrame.size)
        #else
            return Image(cgImage: croppedImage)
        #endif
    }
    
}
