//
//  GameViewController.swift
//  iOS_Game_004
//
//  Created by Alexander Wegner on 26.04.17.
//  Copyright © 2017 Alexander Wegner. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scGame: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // --- configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = true // no multitouch allowed
        skView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        
        // --- create and configure the scene
        scGame = GameScene(size: skView.bounds.size)
        scGame.scaleMode = .aspectFill
        
        skView.presentScene(scGame)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
