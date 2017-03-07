//
//  SoftCellComposition.swift
//  SoftCells
//
//  Created by Tom Heinan on 3/4/17.
//  Copyright © 2017 Tom Heinan. All rights reserved.
//

import CoreGraphics

struct SoftCellSceneElement: Hashable {
    
    var cell: SoftCell
    var boundingCircle: Circle
    var skPosition: CGPoint
    
    var hashValue: Int {
        return "\(cell)\(boundingCircle)\(skPosition)".hashValue
    }
    
    static func ==(lhs: SoftCellSceneElement, rhs: SoftCellSceneElement) -> Bool {
        return lhs.cell == rhs.cell && lhs.boundingCircle == rhs.boundingCircle && lhs.skPosition == rhs.skPosition
    }
}
