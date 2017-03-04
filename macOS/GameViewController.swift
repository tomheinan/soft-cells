//
//  GameViewController.swift
//  macOS
//
//  Created by Tom Heinan on 3/4/17.
//  Copyright © 2017 Tom Heinan. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {
    
    fileprivate(set) var scene: SKScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = GameScene(size: view.bounds.size)
        
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        if let mainWindow = NSApplication.shared().windows.first {
            mainWindow.delegate = self
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        if let mainWindow = NSApplication.shared().windows.first {
            mainWindow.delegate = nil
        }
    }

}

extension GameViewController: NSWindowDelegate {
    
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        scene?.size = frameSize
        return frameSize
    }
    
}

