//
//  SoftCell.swift
//  SoftCells
//
//  Created by Tom Heinan on 3/4/17.
//  Copyright © 2017 Tom Heinan. All rights reserved.
//

import CoreGraphics
import GameplayKit

class SoftCell {
    
    let roundingFactor: CGFloat = 0.4
    
    fileprivate(set) var seed: UInt64
    fileprivate(set) var numVertices: Int
    fileprivate(set) var arcLengths: Array<CGFloat> = Array()
    
    init(seed: UInt64) {
        self.seed = seed
        let randomSource = GKMersenneTwisterRandomSource(seed: self.seed)
        
        // generate a number of vertices between 3 and 5
        
        let vertexSeed = CGFloat(randomSource.nextUniform())
        numVertices = Int(floor((vertexSeed * 3)) + 3)
        
        // generate a pseudorandom arc length in each sector
        
        for index in 0..<numVertices {
            let sectorStart = (CGFloat(index) / CGFloat(numVertices)) * CGFloat(M_PI * 2)
            let sectorEnd = ((CGFloat(index + 1) / CGFloat(numVertices)) * CGFloat(M_PI * 2)) - CGFloat(FLT_EPSILON)
            
            let difference = sectorEnd - sectorStart
            let arcLength = difference * CGFloat(randomSource.nextUniform())
            let arcLengthOffsetBySector = sectorEnd - arcLength
            
            arcLengths.append(arcLengthOffsetBySector)
        }
    }
    
    func verticesOnCircle(_ circle: Circle) -> Array<CGPoint> {
        var vertices: Array<CGPoint> = Array()
        
        for arcLength in arcLengths {
            let x = circle.center.x + circle.radius * cos(arcLength)
            let y = circle.center.y + circle.radius * sin(arcLength)
            
            vertices.append(CGPoint(x: x, y: y))
        }
        
        return vertices
    }
    
    func pathInCircle(_ circle: Circle) -> CGPath {
        let path = CGMutablePath()
        let vertices = verticesOnCircle(circle)
        
        if let firstVertex = vertices.first {
            path.move(to: firstVertex)
        }
        
        for index in 0 ..< vertices.count {
            
            // get references to the three vertices we care about during this iteration
            
            let currentVertex: CGPoint
            let currentArcLength: CGFloat
            
            let nextVertex: CGPoint
            let nextArcLength: CGFloat
            
            currentVertex = vertices[index]
            currentArcLength = arcLengths[index]
            
            if index == vertices.count - 1, let firstVertex = vertices.first, let firstArcLength = arcLengths.first {
                nextVertex = firstVertex
                nextArcLength = firstArcLength
            } else {
                nextVertex = vertices[index + 1]
                nextArcLength = arcLengths[index + 1]
            }
            
            // calculate the tangent lines for the current and subsequent vertices
            
            let currentTangent = circle.tangentLineAtPoint(currentVertex)
            let nextTangent = circle.tangentLineAtPoint(nextVertex)
            
            // generate control points at appropriate distances from the current vertex
            
            let distance: CGFloat
            if nextArcLength - currentArcLength < 0 {
                distance = nextArcLength - currentArcLength + CGFloat(M_PI * 2)
            } else {
                distance = nextArcLength - currentArcLength
            }
            
            let controlPointA: CGPoint
            let controlPointB: CGPoint
            
            if (currentArcLength >= 0 && currentArcLength < CGFloat(M_PI)) {
                controlPointA = currentTangent.pointAtDistance(distance * circle.radius * 0.5 * roundingFactor * -1)
            } else {
                controlPointA = currentTangent.pointAtDistance(distance * circle.radius * 0.5 * roundingFactor)
            }
            
            if nextArcLength >= 0 && nextArcLength < CGFloat(M_PI) {
                controlPointB = nextTangent.pointAtDistance(distance * circle.radius * 0.5 * roundingFactor)
            } else {
                controlPointB = nextTangent.pointAtDistance(distance * circle.radius * 0.5 * roundingFactor * -1)
            }
            
            // add curve to path
            
            path.addCurve(to: nextVertex, control1: controlPointA, control2: controlPointB)
        }
        
        path.closeSubpath()
        
        return path
    }
    
}
