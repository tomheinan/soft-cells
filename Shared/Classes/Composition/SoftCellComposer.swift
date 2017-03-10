//
//  SoftCellComposer.swift
//  SoftCells
//
//  Created by Tom Heinan on 3/4/17.
//  Copyright © 2017 Tom Heinan. All rights reserved.
//

import CoreGraphics
import GameplayKit
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
    #else
        static func composition(for image: UIImage, in rect: CGRect) -> Set<SoftCellSceneElement> {
            return _composition(for: image, in: rect)
        }
    #endif
    
    private static func _composition(for image: Image, in rect: CGRect) -> Set<SoftCellSceneElement> {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        // here's where we generate the seed for the whole composition
        
        #if os(OSX)
            let imageData = NSData(data: image.tiffRepresentation!)
            let screenScale = 1.0
        #else
            let imageData = NSData(data: UIImagePNGRepresentation(image)!)
            let screenScale = UIScreen.main.scale
        #endif
        
        let seed = UInt64(imageData.length)
        var set = Set<SoftCellSceneElement>()
        
        // large cell in the middle
        
        let imageCellBoundingRect = rect.insetBy(dx: rect.width * 0.33, dy: rect.height * 0.33)
        let imageCellBoundingCircle = Circle(inBoundingRect: imageCellBoundingRect)
        let imageCell = SoftCell(seed: seed)
        let textureBoundingRect = imageCell.pathInCircle(imageCellBoundingCircle).boundingBox
        let imageCellImage = image.cropping(to: textureBoundingRect)
        let imageCellSceneElement = SoftCellSceneElement(cell: imageCell, boundingCircle: imageCellBoundingCircle, skPosition: center, image: imageCellImage, color: Color.white)
        set.insert(imageCellSceneElement)
        
        // generate some number of 'satellite' cells
        
        let outerRect = rect.insetBy(dx: -100, dy: -100)
        let outerCircle = Circle(inBoundingRect: outerRect)
        let outerCell = SoftCell(seed: seed - 1)
        let randomSource = GKMersenneTwisterRandomSource(seed: seed - 1)
        
        for num in 0..<outerCell.numVertices {
            let satelliteCell = SoftCell(seed: seed + UInt64(num))
            let satelliteBoundingCircle = Circle(center: CGPoint.zero, radius: CGFloat(200.0 / screenScale))
            let initialPosition = outerCell.verticesOnCircle(outerCircle)[num]
            let translatedPosition = CGPoint(x: initialPosition.x + center.x, y: initialPosition.y + center.y)
            
            // generate some nice pastel colour
            let hue = CGFloat(randomSource.nextUniform())
            let color = Color(hue: hue, saturation: 0.8, brightness: 1.0, alpha: 1.0)
            
            let satelliteCellSceneElement = SoftCellSceneElement(cell: satelliteCell, boundingCircle: satelliteBoundingCircle, skPosition: translatedPosition, image: nil, color: color)
            set.insert(satelliteCellSceneElement)
        }
        
        return set
    }
    
}
