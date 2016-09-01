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
    var lbTextA: SKLabelNode!
    var lbTextGame: SKLabelNode!
    var lbTextBy: SKLabelNode!
    var snMenuAbout: SKSpriteNode!
    var snMenuBack: SKSpriteNode!
    var snAboutTwitter: SKSpriteNode!
    var snAboutWww: SKSpriteNode!
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
        let flAboutTwitterWidth = (SKTexture(imageNamed: "Media/about_icon_twitter.png").size().width) * (self.frame.width/667.0) / 2.5
        let flAboutTwitterHeight = (SKTexture(imageNamed: "Media/about_icon_twitter.png").size().height) * (self.frame.height/375.0) / 2.5
        let flAboutWwwWidth = (SKTexture(imageNamed: "Media/about_icon_www.png").size().width) * (self.frame.width/667.0) / 2.5
        let flAboutWwwHeight = (SKTexture(imageNamed: "Media/about_icon_www.png").size().height) * (self.frame.height/375.0) / 2.5
        // Menu "About" Sprite
        snMenuAbout = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_headline.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuSpriteWidth, flMenuSpriteHeight))
        snMenuAbout.anchorPoint = CGPointMake(1.0, 0.5)
        snMenuAbout.position = CGPoint(x: 15*(self.frame.width / 16), y: 10*(self.frame.height / 12))
        snMenuAbout.zPosition = 1.0
        snMenuAbout.alpha = 1.0
        snMenuAbout.name = "MenuAbout"
        addChild(snMenuAbout)
        // Menu "About" Text
        lbMenuAbout = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuAbout.horizontalAlignmentMode = .Center;
        lbMenuAbout.verticalAlignmentMode = .Center
        lbMenuAbout.text = "ABOUT"
        lbMenuAbout.fontSize = 30 * (self.frame.width/667.0)
        lbMenuAbout.position = CGPoint(x: CGRectGetMidX(snMenuAbout.frame), y: 10*(self.frame.height / 12))
        lbMenuAbout.fontColor = UIColor.whiteColor()
        lbMenuAbout.zPosition = 1.0
        lbMenuAbout.name = "MenuAbout"
        self.addChild(lbMenuAbout)
        // Menu "Back" Sprite
        snMenuBack = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_back.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuBackSpriteWidth, flMenuBackSpriteHeight))
        snMenuBack.anchorPoint = CGPointMake(0.0, 0.5)
        snMenuBack.position = CGPoint(x: 1*(self.frame.width / 16), y: 10*(self.frame.height / 12))
        snMenuBack.zPosition = 1.0
        snMenuBack.alpha = 1.0
        snMenuBack.name = "MenuBack"
        self.addChild(snMenuBack)
        // --- Text ---
        // "A" Text
        lbTextA = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbTextA.horizontalAlignmentMode = .Left
        lbTextA.verticalAlignmentMode = .Center
        lbTextA.text = "A"
        lbTextA.fontSize = 35 * (self.frame.width/667.0)
        lbTextA.position = CGPoint(x: 1*(self.frame.width / 16), y: 6*(self.frame.height / 12))
        lbTextA.fontColor = UIColor.whiteColor()
        lbTextA.zPosition = 1.0
        self.addChild(lbTextA)
        // "Game" Text
        lbTextGame = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbTextGame.horizontalAlignmentMode = .Right
        lbTextGame.verticalAlignmentMode = .Center
        lbTextGame.text = "GAME"
        lbTextGame.fontSize = 35 * (self.frame.width/667.0)
        lbTextGame.position = CGPoint(x: 15*(self.frame.width / 16), y: 6*(self.frame.height / 12))
        lbTextGame.fontColor = UIColor.whiteColor()
        lbTextGame.zPosition = 1.0
        self.addChild(lbTextGame)
        // TL Logo
        let flLogoRatio: CGFloat
        let txLogo = SKTexture(imageNamed: "Media/tinylabs_logo_05.png")
        flLogoRatio = txLogo.size().width / txLogo.size().height
        
        let snlogo = SKSpriteNode(texture: txLogo, color: UIColor.clearColor(), size: CGSizeMake(350 * (self.frame.width/667.0), 350 * (self.frame.height/375.0) / flLogoRatio))
        snlogo.anchorPoint = CGPointMake(0.5, 0.5)
        snlogo.position = CGPoint(x: 7*(self.frame.width / 16), y: 6*(self.frame.height / 12))
        snlogo.zPosition = 1.0
        snlogo.alpha = 1.0
        addChild(snlogo)
        // "by Alex" Text
        lbTextBy = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lbTextBy.horizontalAlignmentMode = .Left
        lbTextBy.verticalAlignmentMode = .Center
        lbTextBy.text = "Code & design:  Alex"
        lbTextBy.fontSize = 28 * (self.frame.width/667.0)
        lbTextBy.position = CGPoint(x: 2*(self.frame.width / 20), y: 3*(self.frame.height / 12))
        lbTextBy.fontColor = UIColor.whiteColor()
        lbTextBy.zPosition = 1.0
        self.addChild(lbTextBy)
        // About "Twitter" Sprite
        snAboutTwitter = SKSpriteNode(texture: SKTexture(imageNamed: "Media/about_icon_twitter.png"), color: UIColor.clearColor(), size: CGSizeMake(flAboutTwitterWidth, flAboutTwitterHeight))
        snAboutTwitter.anchorPoint = CGPointMake(0.5, 0.5)
        snAboutTwitter.position = CGPoint(x: 14*(self.frame.width / 20), y: 3*(self.frame.height / 12))
        snAboutTwitter.zPosition = 1.0
        snAboutTwitter.alpha = 1.0
        snAboutTwitter.name = "AboutTwitter"
        self.addChild(snAboutTwitter)
        // About "WWW" Sprite
        snAboutWww = SKSpriteNode(texture: SKTexture(imageNamed: "Media/about_icon_www.png"), color: UIColor.clearColor(), size: CGSizeMake(flAboutWwwWidth, flAboutWwwHeight))
        snAboutWww.anchorPoint = CGPointMake(1.0, 0.5)
        snAboutWww.position = CGPoint(x: 16*(self.frame.width / 20), y: 3*(self.frame.height / 12))
        snAboutWww.zPosition = 1.0
        snAboutWww.alpha = 1.0
        snAboutWww.name = "AboutWww"
        self.addChild(snAboutWww)
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
            case "AboutTwitter"?:
                iButtonPressed = 2
                fctPlayClickSound()
            case "AboutWww"?:
                iButtonPressed = 3
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
            case "AboutTwitter"?:
                if iButtonPressed == 2 {
                    fctOpenTwitter("pixelgeb")
                }
            case "AboutWww"?:
                if iButtonPressed == 3 {
                    fctOpenWebsite("www.tiny-labs.com")
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
        if GameData.blSoundEffectsEnabled == true {
            apClick.volume = GameData.flSoundsVolume
            apClick.prepareToPlay()
            apClick.play()
        }
    }
    
    func fctOpenTwitter(name: String) {
        let appURL = NSURL(string: "twitter://user?screen_name=\(name)")!
        let webURL = NSURL(string: "https://twitter.com/\(name)")!
        let application = UIApplication.sharedApplication()
        
        if application.canOpenURL(appURL) {
            application.openURL(appURL)
        } else {
            application.openURL(webURL)
        }
    }
    
    func fctOpenWebsite(url: String) {
        let webURL = NSURL(string: "http://\(url)")!
        let application = UIApplication.sharedApplication()
        
        if application.canOpenURL(webURL) {
            application.openURL(webURL)
        }
    }
}

