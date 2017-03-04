//
//  Circle.swift
//  SoftCells
//
//  Created by Tom Heinan on 3/4/17.
//  Copyright © 2017 Tom Heinan. All rights reserved.
//

import CoreGraphics

struct Circle {
    
    var center: CGPoint
    var radius: CGFloat
    
    var path: CGPath {
        let path = CGMutablePath()
        path.addArc(center: center, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        path.closeSubpath()
        
        return path
    }
    
    init(inBoundingRect rect: CGRect) {
        if rect.maxX < rect.maxY { // portrait
            radius = rect.maxX * 0.5
        } else { // landscape or square
            radius = rect.maxY * 0.5
        }
        
        center = CGPoint(x: rect.midX, y: rect.midY)
    }
    
    func tangentLineAtPoint(_ point: CGPoint) -> Line {
        let radialSlope: CGFloat
        
        if point.x - center.x == 0 {
            radialSlope = CGFloat.greatestFiniteMagnitude
        } else {
            radialSlope = (point.y - center.y) / (point.x - center.x)
        }
        
        let tangentialSlope: CGFloat
        
        if radialSlope == 0 {
            tangentialSlope = CGFloat.greatestFiniteMagnitude
        } else {
            tangentialSlope = -1 / radialSlope
        }
        
        return Line(point: point, slope: tangentialSlope)
    }
    
}
