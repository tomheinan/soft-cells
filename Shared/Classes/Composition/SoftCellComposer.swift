//
//  SoftCellComposer.swift
//  SoftCells
//
//  Created by Tom Heinan on 3/4/17.
//  Copyright © 2017 Tom Heinan. All rights reserved.
//

import CoreGraphics
#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

class SoftCellComposer {
    
    #if os(OSX)
        static func composition(for image: NSImage, in rect: CGRect) -> Set<SoftCellSceneElement> {
            return _composition(for: image, in: rect)
        }
        typealias Image = NSImage
    #else
        static func composition(for image: UIImage, in rect: CGRect) -> Set<SoftCellSceneElement> {
            return _composition(for: image, in: rect)
        }
        typealias Image = UIImage
    #endif
    
    private static func _composition(for image: Image, in rect: CGRect) -> Set<SoftCellSceneElement> {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let imageBoundingRect = rect.insetBy(dx: 300, dy:300)
        let imageBoundingCircle = Circle(inBoundingRect: imageBoundingRect)
        let imageCell = SoftCell(seed: 1)
        
        
        
        let composition = SoftCellSceneElement(cell: imageCell, boundingCircle: imageBoundingCircle, skPosition: CGPoint(x: imageBoundingCircle.center.x, y: rect.size.height - imageBoundingCircle.center.y))
        
        return Set([composition])
    }
    
}
