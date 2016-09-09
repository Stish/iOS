//
//  TLPause.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 09.09.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import Foundation
import SpriteKit

class TLPause: SKSpriteNode {
    var snMenuBack: SKSpriteNode!
    var snMenuPause: SKSpriteNode!
    var lbMenuPause: SKLabelNode!
    var snPause: SKShapeNode!
    var lbPause: SKLabelNode!
    var snMenuQuit: SKSpriteNode!
    var lbMenuQuit: SKLabelNode!
    var snMenuOptions: SKSpriteNode!
    var lbMenuOptions: SKLabelNode!
    
    init(size: CGSize) {
        //let txBackground_001 = SKTexture(imageNamed: "Media/reactor_001.png")
        
        super.init(texture: nil,color: UIColor.clearColor(), size: CGSizeMake(size.width, size.height))
        self.anchorPoint = CGPointMake(0.5, 0.5)
        // --- Part 001 ---
        let snBackground_001 = SKSpriteNode(texture: nil,color: UIColor.blackColor(), size: CGSizeMake(size.width, size.height))
        snBackground_001.anchorPoint = CGPointMake(0.5, 0.5)
        snBackground_001.position = CGPoint(x: flScreenWidth / 2, y: flScreenHeight / 2)
        snBackground_001.alpha = 0.8
        snBackground_001.zPosition = 2.1
        addChild(snBackground_001)
        // Menu "Back" Sprite
        let flMenuBackSpriteWidth = (SKTexture(imageNamed: "Media/menu_back.png").size().width) * (self.frame.width/667.0)
        let flMenuBackSpriteHeight = (SKTexture(imageNamed: "Media/menu_back.png").size().height) * (self.frame.height/375.0)
        snMenuBack = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_back.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuBackSpriteWidth, flMenuBackSpriteHeight))
        snMenuBack.anchorPoint = CGPointMake(0.0, 0.5)
        snMenuBack.position = CGPoint(x: 1*(flScreenWidth / 16), y: 10*(flScreenHeight / 12))
        snMenuBack.zPosition = 2.2
        snMenuBack.alpha = 1.0
        snMenuBack.name = "MenuBack"
        self.addChild(snMenuBack)
        // Menu sprite size
        let flMenuSpriteWidth = (SKTexture(imageNamed: "Media/menu_headline.png").size().width) * (self.frame.width/667.0)
        let flMenuSpriteHeight = (SKTexture(imageNamed: "Media/menu_headline.png").size().height) * (self.frame.height/375.0)
        // Menu "About" Sprite
        snMenuPause = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_headline.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuSpriteWidth, flMenuSpriteHeight))
        snMenuPause.anchorPoint = CGPointMake(1.0, 0.5)
        snMenuPause.position = CGPoint(x: 15*(self.frame.width / 16), y: 10*(self.frame.height / 12))
        snMenuPause.zPosition = 2.2
        snMenuPause.alpha = 1.0
        snMenuPause.name = "MenuPause"
        addChild(snMenuPause)
        // Menu "About" Text
        lbMenuPause = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuPause.horizontalAlignmentMode = .Center;
        lbMenuPause.verticalAlignmentMode = .Center
        lbMenuPause.text = " GAME PAUSED"
        lbMenuPause.fontSize = 30 * (self.frame.width/667.0)
        lbMenuPause.position = CGPoint(x: CGRectGetMidX(snMenuPause.frame), y: 10*(self.frame.height / 12))
        lbMenuPause.fontColor = UIColor.whiteColor()
        lbMenuPause.zPosition = 2.2
        lbMenuPause.name = "MenuPause"
        self.addChild(lbMenuPause)
        //snInventory.zPosition = 2.2
        //self.view!.paused = true
        print("Paused!")
        // Pause screen sprite
//        snPause = SKShapeNode(rectOfSize: CGSize(width: self.frame.width, height: self.frame.height))
//        snPause.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
//        snPause.strokeColor = SKColor.blackColor()
//        //snPause.anchor
//        snPause.glowWidth = 0.0
//        snPause.lineWidth = 0.0
//        snPause.fillColor = SKColor.blackColor()
//        snPause.zPosition = 2.1
//        snPause.alpha = 0.8
//        self.addChild(snPause)
        // Pause screen text
//        lbPause = SKLabelNode(fontNamed: fnGameFont?.fontName)
//        lbPause.text = "PAUSED"
//        lbPause.horizontalAlignmentMode = .Center
//        lbPause.verticalAlignmentMode = .Center
//        lbPause.fontSize = 60 * (self.frame.width/667.0)
//        lbPause.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
//        lbPause.fontColor = UIColor.whiteColor()
//        lbPause.zPosition = 2.1
//        lbPause.alpha = 1.0
//        self.addChild(lbPause)
        // Menu "Quit" Sprite
        snMenuQuit = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_bottom.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuSpriteWidth, flMenuSpriteHeight))
        snMenuQuit.anchorPoint = CGPointMake(0.5, 0.5)
        snMenuQuit.position = CGPoint(x: (self.frame.width / 2), y: 3*(self.frame.height / 12))
        snMenuQuit.zPosition = 2.2
        snMenuQuit.alpha = 1.0
        snMenuQuit.name = "MenuQuit"
        addChild(snMenuQuit)
        // Menu "Quit" Text
        lbMenuQuit = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuQuit.horizontalAlignmentMode = .Center;
        lbMenuQuit.verticalAlignmentMode = .Center
        lbMenuQuit.text = "QUIT"
        lbMenuQuit.fontSize = 30 * (self.frame.width/667.0)
        lbMenuQuit.position = CGPoint(x: (self.frame.width / 2), y: 3*(self.frame.height / 12))
        lbMenuQuit.fontColor = UIColor.whiteColor()
        lbMenuQuit.zPosition = 2.2
        lbMenuQuit.name = "MenuQuit"
        self.addChild(lbMenuQuit)
        // Menu "Options" Sprite
        snMenuOptions = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_top.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuSpriteWidth, flMenuSpriteHeight))
        snMenuOptions.anchorPoint = CGPointMake(0.5, 0.5)
        snMenuOptions.position = CGPoint(x: (self.frame.width / 2), y: 5*(self.frame.height / 12))
        snMenuOptions.zPosition = 2.2
        snMenuOptions.alpha = 1.0
        snMenuOptions.name = "MenuOptions"
        addChild(snMenuOptions)
        // Menu "Options" Text
        lbMenuOptions = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuOptions.horizontalAlignmentMode = .Center;
        lbMenuOptions.verticalAlignmentMode = .Center
        lbMenuOptions.text = "OPTIONS"
        lbMenuOptions.fontSize = 30 * (self.frame.width/667.0)
        lbMenuOptions.position = CGPoint(x: (self.frame.width / 2), y: 5*(self.frame.height / 12))
        lbMenuOptions.fontColor = UIColor.whiteColor()
        lbMenuOptions.zPosition = 2.2
        lbMenuOptions.name = "MenuOptions"
        self.addChild(lbMenuOptions)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
