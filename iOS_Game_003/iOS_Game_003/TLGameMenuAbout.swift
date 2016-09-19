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
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        self.anchorPoint = CGPoint(x: 0, y: 0)
        let txGameMenuBackgrd = SKTexture(imageNamed: "Media/gamemenu_003.png")
        
        let snGameMenuBackgrd = SKSpriteNode(texture: txGameMenuBackgrd, color: UIColor.clear, size: CGSize(width: self.frame.width, height: self.frame.height))
        snGameMenuBackgrd.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snGameMenuBackgrd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
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
        snMenuAbout = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_headline.png"), color: UIColor.clear, size: CGSize(width: flMenuSpriteWidth, height: flMenuSpriteHeight))
        snMenuAbout.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        snMenuAbout.position = CGPoint(x: 15*(self.frame.width / 16), y: 10*(self.frame.height / 12))
        snMenuAbout.zPosition = 1.0
        snMenuAbout.alpha = 1.0
        snMenuAbout.name = "MenuAbout"
        addChild(snMenuAbout)
        // Menu "About" Text
        lbMenuAbout = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuAbout.horizontalAlignmentMode = .center;
        lbMenuAbout.verticalAlignmentMode = .center
        lbMenuAbout.text = "ABOUT"
        lbMenuAbout.fontSize = 30 * (self.frame.width/667.0)
        lbMenuAbout.position = CGPoint(x: snMenuAbout.frame.midX, y: 10*(self.frame.height / 12))
        lbMenuAbout.fontColor = UIColor.white
        lbMenuAbout.zPosition = 1.0
        lbMenuAbout.name = "MenuAbout"
        self.addChild(lbMenuAbout)
        // Menu "Back" Sprite
        snMenuBack = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_back.png"), color: UIColor.clear, size: CGSize(width: flMenuBackSpriteWidth, height: flMenuBackSpriteHeight))
        snMenuBack.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        snMenuBack.position = CGPoint(x: 1*(self.frame.width / 16), y: 10*(self.frame.height / 12))
        snMenuBack.zPosition = 1.0
        snMenuBack.alpha = 1.0
        snMenuBack.name = "MenuBack"
        self.addChild(snMenuBack)
        // --- Text ---
        // "A" Text
        lbTextA = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbTextA.horizontalAlignmentMode = .left
        lbTextA.verticalAlignmentMode = .center
        lbTextA.text = "A"
        lbTextA.fontSize = 35 * (self.frame.width/667.0)
        lbTextA.position = CGPoint(x: 1*(self.frame.width / 16), y: 6*(self.frame.height / 12))
        lbTextA.fontColor = UIColor.white
        lbTextA.zPosition = 1.0
        self.addChild(lbTextA)
        // "Game" Text
        lbTextGame = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbTextGame.horizontalAlignmentMode = .right
        lbTextGame.verticalAlignmentMode = .center
        lbTextGame.text = "GAME"
        lbTextGame.fontSize = 35 * (self.frame.width/667.0)
        lbTextGame.position = CGPoint(x: 15*(self.frame.width / 16), y: 6*(self.frame.height / 12))
        lbTextGame.fontColor = UIColor.white
        lbTextGame.zPosition = 1.0
        self.addChild(lbTextGame)
        // TL Logo
        let flLogoRatio: CGFloat
        let txLogo = SKTexture(imageNamed: "Media/tinylabs_logo_05.png")
        flLogoRatio = txLogo.size().width / txLogo.size().height
        
        let snlogo = SKSpriteNode(texture: txLogo, color: UIColor.clear, size: CGSize(width: 350 * (self.frame.width/667.0), height: 350 * (self.frame.height/375.0) / flLogoRatio))
        snlogo.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snlogo.position = CGPoint(x: 7*(self.frame.width / 16), y: 6*(self.frame.height / 12))
        snlogo.zPosition = 1.0
        snlogo.alpha = 1.0
        addChild(snlogo)
        // "by Alex" Text
        lbTextBy = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lbTextBy.horizontalAlignmentMode = .left
        lbTextBy.verticalAlignmentMode = .center
        lbTextBy.text = "Code & design:  Alex"
        lbTextBy.fontSize = 28 * (self.frame.width/667.0)
        lbTextBy.position = CGPoint(x: 2*(self.frame.width / 20), y: 3*(self.frame.height / 12))
        lbTextBy.fontColor = UIColor.white
        lbTextBy.zPosition = 1.0
        self.addChild(lbTextBy)
        // About "Twitter" Sprite
        snAboutTwitter = SKSpriteNode(texture: SKTexture(imageNamed: "Media/about_icon_twitter.png"), color: UIColor.clear, size: CGSize(width: flAboutTwitterWidth, height: flAboutTwitterHeight))
        snAboutTwitter.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snAboutTwitter.position = CGPoint(x: 14*(self.frame.width / 20), y: 3*(self.frame.height / 12))
        snAboutTwitter.zPosition = 1.0
        snAboutTwitter.alpha = 1.0
        snAboutTwitter.name = "AboutTwitter"
        self.addChild(snAboutTwitter)
        // About "WWW" Sprite
        snAboutWww = SKSpriteNode(texture: SKTexture(imageNamed: "Media/about_icon_www.png"), color: UIColor.clear, size: CGSize(width: flAboutWwwWidth, height: flAboutWwwHeight))
        snAboutWww.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        snAboutWww.position = CGPoint(x: 16*(self.frame.width / 20), y: 3*(self.frame.height / 12))
        snAboutWww.zPosition = 1.0
        snAboutWww.alpha = 1.0
        snAboutWww.name = "AboutWww"
        self.addChild(snAboutWww)
        // --- Sounds: Click ---
        let path = Bundle.main.path(forResource: "Media/sounds/click_001", ofType:"wav")
        let fileURL = URL(fileURLWithPath: path!)
        do {
            try apClick = AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apClick.numberOfLoops = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // Reset pressed sprites
        snMenuBack.texture = SKTexture(imageNamed: "Media/menu_back.png")
        // Screen elements
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            switch (touchedNode.name) {
            case "MenuBack"?:
                if iButtonPressed == 1 {
                    let transition = SKTransition.fade(with: UIColor.black, duration: 0.2)
                    let nextScene = TLGameMenu(size: scene!.size)
                    nextScene.scaleMode = .aspectFill
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
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    func fctPlayClickSound() {
        if GameData.blSoundEffectsEnabled == true {
            apClick.volume = GameData.flSoundsVolume
            apClick.prepareToPlay()
            apClick.play()
        }
    }
    
    func fctOpenTwitter(_ name: String) {
        let appURL = URL(string: "twitter://user?screen_name=\(name)")!
        let webURL = URL(string: "https://twitter.com/\(name)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.openURL(appURL)
        } else {
            application.openURL(webURL)
        }
    }
    
    func fctOpenWebsite(_ url: String) {
        let webURL = URL(string: "http://\(url)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(webURL) {
            application.openURL(webURL)
        }
    }
}

