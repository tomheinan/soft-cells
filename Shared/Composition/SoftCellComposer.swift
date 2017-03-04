//
//  SoftCellComposer.swift
//  SoftCells
//
//  Created by Tom Heinan on 3/4/17.
//  Copyright © 2017 Tom Heinan. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

class SoftCellComposer {
    
    #if os(OSX)
        static func composition(for image: NSImage) -> SoftCellComposition {
            return _composition(for: image)
        }
        typealias Image = NSImage
    #else
        static func composition(for image: UIImage) -> SoftCellComposition {
            return _composition(for: image)
        }
        typealias Image = UIImage
    #endif
    
    private static func _composition(for image: Image) -> SoftCellComposition {
        return SoftCellComposition()
    }
    
}
