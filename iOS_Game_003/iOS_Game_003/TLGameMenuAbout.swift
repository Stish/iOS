//
//  TLGameMenuAbout.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 07.07.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import SpriteKit
import AVFoundation

class TLGameMenuAbout: SKScene, SKPhysicsContactDelegate {
    var lbMenuAbout: SKLabelNode!
    var snMenuAbout: SKSpriteNode!
    var snMenuBack: SKSpriteNode!
    var iButtonPressed: Int!
    var apClick: AVAudioPlayer!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        self.anchorPoint = CGPointMake(0, 0)
        let txGameMenuBackgrd = SKTexture(imageNamed: "Media/gamemenu_003.png")
        
        let snGameMenuBackgrd = SKSpriteNode(texture: txGameMenuBackgrd, color: UIColor.clearColor(), size: CGSizeMake(self.frame.width, self.frame.height))
        snGameMenuBackgrd.anchorPoint = CGPointMake(0.5, 0.5)
        snGameMenuBackgrd.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        snGameMenuBackgrd.zPosition = 1.0
        snGameMenuBackgrd.alpha = 1.0
        addChild(snGameMenuBackgrd)
        // Menu sprite size
        let flMenuSpriteWidth = (SKTexture(imageNamed: "Media/menu_headline.png").size().width) * (self.frame.width/667.0)
        let flMenuSpriteHeight = (SKTexture(imageNamed: "Media/menu_headline.png").size().height) * (self.frame.height/375.0)
        let flMenuBackSpriteWidth = (SKTexture(imageNamed: "Media/menu_back.png").size().width) * (self.frame.width/667.0)
        let flMenuBackSpriteHeight = (SKTexture(imageNamed: "Media/menu_back.png").size().height) * (self.frame.height/375.0)
        // Menu "Options" Sprite
        snMenuAbout = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_headline.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuSpriteWidth, flMenuSpriteHeight))
        snMenuAbout.anchorPoint = CGPointMake(1.0, 0.5)
        snMenuAbout.position = CGPoint(x: 15*(self.frame.width / 16), y: 5*(self.frame.height / 6))
        snMenuAbout.zPosition = 1.0
        snMenuAbout.alpha = 1.0
        snMenuAbout.name = "MenuAbout"
        addChild(snMenuAbout)
        // Menu "Options" Text
        lbMenuAbout = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuAbout.horizontalAlignmentMode = .Center;
        lbMenuAbout.verticalAlignmentMode = .Center
        lbMenuAbout.text = "ABOUT"
        lbMenuAbout.fontSize = 30 * (self.frame.width/667.0)
        lbMenuAbout.position = CGPoint(x: CGRectGetMidX(snMenuAbout.frame), y: 5*(self.frame.height / 6))
        lbMenuAbout.fontColor = UIColor.whiteColor()
        lbMenuAbout.zPosition = 1.0
        lbMenuAbout.name = "MenuAbout"
        self.addChild(lbMenuAbout)
        // Menu "Back" Sprite
        snMenuBack = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_back.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuBackSpriteWidth, flMenuBackSpriteHeight))
        snMenuBack.anchorPoint = CGPointMake(0.0, 0.5)
        snMenuBack.position = CGPoint(x: 1*(self.frame.width / 16), y: 5*(self.frame.height / 6))
        snMenuBack.zPosition = 1.0
        snMenuBack.alpha = 1.0
        snMenuBack.name = "MenuBack"
        self.addChild(snMenuBack)
        // TL Logo
        let flLogoRatio: CGFloat
        let txLogo = SKTexture(imageNamed: "Media/tinylabs_logo_05.png")
        flLogoRatio = txLogo.size().width / txLogo.size().height
        
        let snlogo = SKSpriteNode(texture: txLogo, color: UIColor.clearColor(), size: CGSizeMake(300 * (self.frame.width/667.0), 300 * (self.frame.height/375.0) / flLogoRatio))
        snlogo.anchorPoint = CGPointMake(0.5, 0.5)
        snlogo.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        snlogo.zPosition = 1.0
        snlogo.alpha = 1.0
        addChild(snlogo)
        // --- Sounds: Click ---
        let path = NSBundle.mainBundle().pathForResource("Media/sounds/click_001", ofType:"wav")
        let fileURL = NSURL(fileURLWithPath: path!)
        do {
            try apClick = AVAudioPlayer(contentsOfURL: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apClick.numberOfLoops = 0
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            switch (touchedNode.name) {
            case "MenuBack"?:
                snMenuBack.texture = SKTexture(imageNamed: "Media/menu_back_pressed.png")
                iButtonPressed = 1
                fctPlayClickSound()
            default:
                ()
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            switch (touchedNode.name) {
            case "MenuBack"?:
                if iButtonPressed == 1 {
                    let transition = SKTransition.fadeWithColor(.blackColor(), duration: 0.2)
                    let nextScene = TLGameMenu(size: scene!.size)
                    nextScene.scaleMode = .AspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
                    self.removeFromParent()
                }
            default:
                ()
            }
        }
        snMenuBack.texture = SKTexture(imageNamed: "Media/menu_back.png")
        iButtonPressed = 0
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    func fctPlayClickSound() {
        apClick.prepareToPlay()
        apClick.play()
    }
}

