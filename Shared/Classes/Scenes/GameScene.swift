//
//  GameScene.swift
//  SoftCells
//
//  Created by Tom Heinan on 3/4/17.
//  Copyright © 2017 Tom Heinan. All rights reserved.
//

import SpriteKit

#if os(OSX)
typealias Color = NSColor
#else
typealias Color = UIColor
#endif

class GameScene: SKScene {
    
    fileprivate var softCellNode: SKShapeNode?
    fileprivate let debugMode = true
    
    func setUpScene() {
        guard let view = view else { return }
        
        backgroundColor = Color.white
        
        #if os(OSX)
            guard let image = NSImage(named: "Optimus") else { return }
        #else
            guard let image = UIImage(named: "Optimus") else { return }
        #endif
        
        let center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        
        // composition frame
        
        if debugMode {
            let frameCircle = Circle(inBoundingRect: view.bounds)
            let frameNode = SKShapeNode(path: frameCircle.path)
            frameNode.position = center
            frameNode.strokeColor = Color(white: 0.9, alpha: 1.0)
            frameNode.lineWidth = 4
            addChild(frameNode)
        }
        
        let composition = SoftCellComposer.composition(for: image, in: view.bounds)
        composition.forEach { (element) in
            softCellNode = SKShapeNode.init(path: element.cell.pathInCircle(element.boundingCircle))
            softCellNode?.position = element.skPosition
            softCellNode?.fillColor = element.color
            softCellNode?.lineWidth = 0
            
            if let image = element.image {
                let texture = SKTexture(image: image)
                softCellNode?.fillTexture = texture
            }
            
            addChild(softCellNode!)
            
            if debugMode {
                let boundingNode = SKShapeNode(path: element.boundingCircle.path)
                boundingNode.position = element.skPosition
                boundingNode.strokeColor = Color(white: 0.9, alpha: 1.0)
                boundingNode.lineWidth = 4
                addChild(boundingNode)
            }
        }
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

#if os(iOS) || os(tvOS)
// touch-based event handling
extension GameScene {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            print("soft cell: \(self.softCellNode)")
            //self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
    
}
#endif

#if os(OSX)
// mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        
    }
    
    override func mouseDragged(with event: NSEvent) {
        
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }

}
#endif

