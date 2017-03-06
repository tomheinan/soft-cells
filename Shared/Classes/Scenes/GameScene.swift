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
    
    func setUpScene() {
        
        backgroundColor = Color.blue
        
        let circle = Circle(inBoundingRect: frame)
        let softCell = SoftCell(seed: 1234)
        softCellNode = SKShapeNode.init(path: softCell.pathInCircle(circle))
        softCellNode?.fillColor = Color.white
        addChild(softCellNode!)
        
        let frameNode = SKShapeNode(path: circle.path)
        frameNode.strokeColor = Color.white
        frameNode.lineWidth = 4
        addChild(frameNode)
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

