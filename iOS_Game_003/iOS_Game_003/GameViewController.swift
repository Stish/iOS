//
//  GameViewController.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 15.12.15.
//  Copyright (c) 2015 Alexander Wegner. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var scGame: GameScene!
    var scGameStart: TLGameStart!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // --- configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = true // no multitouch allowed
        skView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        
        // --- create and configure the scene
        scGame = GameScene(size: skView.bounds.size)
        scGame.scaleMode = .aspectFill
        
        scGameStart = TLGameStart(size: skView.bounds.size)
        scGameStart.scaleMode = .aspectFill
        
        
        // --- present the scene
        
        skView.presentScene(scGameStart)
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
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
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
