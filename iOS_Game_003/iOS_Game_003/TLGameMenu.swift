//
//  TLGameMenu.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 06.07.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import SpriteKit
import AVFoundation

class TLGameMenu: SKScene, SKPhysicsContactDelegate {
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        // --- collision setup ---
        physicsWorld.contactDelegate = self
        view.showsPhysics = false // #debug
        
        
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        self.anchorPoint = CGPointMake(0, 0)
        
        let txGameMenuBackgrd = SKTexture(imageNamed: "Media/gamemenu_001.png")
        
        let snGameMenuBackgrd = SKSpriteNode(texture: txGameMenuBackgrd, color: UIColor.clearColor(), size: CGSizeMake(self.frame.width, self.frame.height))
        snGameMenuBackgrd.anchorPoint = CGPointMake(0.5, 0.5)
        snGameMenuBackgrd.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        snGameMenuBackgrd.zPosition = 1.0
        snGameMenuBackgrd.alpha = 1.0
        addChild(snGameMenuBackgrd)
        // Menu "Play"
        let lbMenuPlay = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuPlay.horizontalAlignmentMode = .Center;
        lbMenuPlay.verticalAlignmentMode = .Center
        lbMenuPlay.text = "Play"
        lbMenuPlay.fontSize = 50
        lbMenuPlay.position = CGPoint(x: CGRectGetMidX(self.frame), y: 4*(self.frame.height / 5))
        lbMenuPlay.fontColor = UIColor.whiteColor()
        lbMenuPlay.zPosition = 1.0
        lbMenuPlay.name = "MenuPlay"
        self.addChild(lbMenuPlay)
        // Menu "Tutorial"
        let lbMenuTutorial = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuTutorial.horizontalAlignmentMode = .Center;
        lbMenuTutorial.verticalAlignmentMode = .Center
        lbMenuTutorial.text = "Tutorial"
        lbMenuTutorial.fontSize = 50
        lbMenuTutorial.position = CGPoint(x: CGRectGetMidX(self.frame), y: 3*(self.frame.height / 5))
        lbMenuTutorial.fontColor = UIColor.whiteColor()
        lbMenuTutorial.zPosition = 1.0
        self.addChild(lbMenuTutorial)
        // Menu "Highscore"
        let lbMenuHighScore = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuHighScore.horizontalAlignmentMode = .Center;
        lbMenuHighScore.verticalAlignmentMode = .Center
        lbMenuHighScore.text = "Highscore"
        lbMenuHighScore.fontSize = 50
        lbMenuHighScore.position = CGPoint(x: CGRectGetMidX(self.frame), y: 2*(self.frame.height / 5))
        lbMenuHighScore.fontColor = UIColor.whiteColor()
        lbMenuHighScore.zPosition = 1.0
        self.addChild(lbMenuHighScore)
        // Menu "About"
        let lbMenuAbout = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuAbout.horizontalAlignmentMode = .Center;
        lbMenuAbout.verticalAlignmentMode = .Center
        lbMenuAbout.text = "About"
        lbMenuAbout.fontSize = 50
        lbMenuAbout.position = CGPoint(x: CGRectGetMidX(self.frame), y: 1*(self.frame.height / 5))
        lbMenuAbout.fontColor = UIColor.whiteColor()
        lbMenuAbout.zPosition = 1.0
        self.addChild(lbMenuAbout)
        // Version
        let lbVersion = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbVersion.text = "ver 0.18"
        lbVersion.fontSize = 20
        lbVersion.position = CGPoint(x: (self.frame.width - 50), y: 5)
        lbVersion.fontColor = UIColor.whiteColor()
        lbVersion.zPosition = 1.0
        self.addChild(lbVersion)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)

            switch (touchedNode.name) {
            case "MenuPlay"?:
                let transition = SKTransition.fadeWithColor(.blackColor(), duration: 0.4)
                let nextScene = GameScene(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                scene?.view?.presentScene(nextScene, transition: transition)
                self.removeFromParent()
            default:
                return
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
}
