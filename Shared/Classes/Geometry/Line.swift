//
//  Line.swift
//  SoftCells
//
//  Created by Tom Heinan on 3/4/17.
//  Copyright © 2017 Tom Heinan. All rights reserved.
//

import CoreGraphics

struct Line {
    
    var point: CGPoint
    var slope: CGFloat
    
    func pointAtDistance(_ distance: CGFloat) -> CGPoint {
        let slopeMagnitude = pow(1 + pow(slope, 2), 0.5)
        let normalizedDirectionVector = CGPoint(x: 1.0 / slopeMagnitude, y: slope / slopeMagnitude)
        
        let product = CGPoint(x: normalizedDirectionVector.x * distance, y: normalizedDirectionVector.y * distance)
        let sum = CGPoint(x: point.x + product.x, y: point.y + product.y)
        
        return sum
    }
    
}
