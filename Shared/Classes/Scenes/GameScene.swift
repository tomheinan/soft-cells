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
    
    let debugMode = false
    let compositionName = "composition"
    
    var index: Int = 0 {
        didSet {
            if index >= imageNames.count {
                index = 0
            }
        }
    }
    
    fileprivate let imageNames = [
        "Tom", "Optimus", "AirportDog", "MST3K"
    ]
    
    func setUpScene() {
        guard let view = view else { return }
        
        backgroundColor = Color.white
        
        // composition frame
        
        if debugMode {
            let frameCircle = Circle(inBoundingRect: view.bounds)
            let frameNode = SKShapeNode(path: frameCircle.path)
            frameNode.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
            frameNode.strokeColor = Color(white: 0.9, alpha: 1.0)
            frameNode.lineWidth = 4
            addChild(frameNode)
        }
        
        let firstImageName = imageNames[index]
        let firstImage = loadImage(named: firstImageName)
        displayComposition(for: firstImage)
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

extension GameScene {
    
    func loadImage(named string: String) -> Image {
        #if os(OSX)
            return NSImage(named: string)!
        #else
            return UIImage(named: string)!
        #endif
    }
    
    func displayComposition(for image: Image) {
        guard let view = view else { return }
        
        let center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        
        // composition frame
        
        if debugMode {
            let frameCircle = Circle(inBoundingRect: view.bounds)
            let frameNode = SKShapeNode(path: frameCircle.path)
            frameNode.name = compositionName
            frameNode.position = center
            frameNode.strokeColor = Color(white: 0.9, alpha: 1.0)
            frameNode.lineWidth = 4
            addChild(frameNode)
        }
        
        let composition = SoftCellComposer.composition(for: image, in: view.bounds)
        composition.forEach { (element) in
            let softCellNode = SKShapeNode.init(path: element.cell.pathInCircle(element.boundingCircle))
            softCellNode.name = compositionName
            softCellNode.position = element.skPosition
            softCellNode.fillColor = element.color
            softCellNode.lineWidth = 0
            
            if let image = element.image {
                let texture = SKTexture(image: image)
                softCellNode.fillTexture = texture
            }
            
            addChild(softCellNode)
            
            if debugMode {
                let boundingNode = SKShapeNode(path: element.boundingCircle.path)
                boundingNode.name = compositionName
                boundingNode.position = element.skPosition
                boundingNode.strokeColor = Color(white: 0.9, alpha: 1.0)
                boundingNode.lineWidth = 4
                addChild(boundingNode)
            }
        }
    }
    
    func loadNextComposition() {
        enumerateChildNodes(withName: compositionName, using: { (node, stop) in
            node.removeFromParent()
        })
        
        index += 1
        let image = loadImage(named: imageNames[index])
        displayComposition(for: image)
    }
    
}

#if os(iOS) || os(tvOS)
// touch-based event handling
extension GameScene {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            loadNextComposition()
        }
    }
    
}
#endif

#if os(OSX)
// mouse-based event handling
extension GameScene {
    
    override func mouseUp(with event: NSEvent) {
        loadNextComposition()
    }

}
#endif

