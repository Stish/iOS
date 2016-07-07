//
//  TLGameMenuOptions.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 07.07.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import SpriteKit
import AVFoundation

class TLGameMenuOptions: SKScene, SKPhysicsContactDelegate {
    var lbMenuOptions: SKLabelNode!
    var snMenuOptions: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        self.anchorPoint = CGPointMake(0, 0)
        let txGameMenuBackgrd = SKTexture(imageNamed: "Media/gamemenu_001.png")
        
        let snGameMenuBackgrd = SKSpriteNode(texture: txGameMenuBackgrd, color: UIColor.clearColor(), size: CGSizeMake(self.frame.width, self.frame.height))
        snGameMenuBackgrd.anchorPoint = CGPointMake(0.5, 0.5)
        snGameMenuBackgrd.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        snGameMenuBackgrd.zPosition = 1.0
        snGameMenuBackgrd.alpha = 1.0
        addChild(snGameMenuBackgrd)
        
        // Menu "Options" Sprite
        snMenuOptions = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_middle.png"), color: UIColor.clearColor(), size: SKTexture(imageNamed: "Media/menu_middle.png").size())
        snMenuOptions.anchorPoint = CGPointMake(0.5, 0.5)
        snMenuOptions.position = CGPoint(x: CGRectGetMidX(self.frame), y: 5*(self.frame.height / 6))
        snMenuOptions.zPosition = 1.0
        snMenuOptions.alpha = 1.0
        snMenuOptions.name = "MenuOptions"
        addChild(snMenuOptions)
        // Menu "Options" Text
        lbMenuOptions = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuOptions.horizontalAlignmentMode = .Center;
        lbMenuOptions.verticalAlignmentMode = .Center
        lbMenuOptions.text = "OPTIONS"
        lbMenuOptions.fontSize = 35
        lbMenuOptions.position = CGPoint(x: CGRectGetMidX(snMenuOptions.frame), y: 5*(self.frame.height / 6))
        lbMenuOptions.fontColor = UIColor.whiteColor()
        lbMenuOptions.zPosition = 1.0
        lbMenuOptions.name = "MenuOptions"
        self.addChild(lbMenuOptions)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
}

