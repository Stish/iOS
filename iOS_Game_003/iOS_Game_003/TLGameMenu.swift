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
    var lbMenuPlay: SKLabelNode!
    var snMenuPlay: SKSpriteNode!
    var lbMenuTutorial: SKLabelNode!
    var snMenuTutorial: SKSpriteNode!
    var lbMenuOptions: SKLabelNode!
    var snMenuOptions: SKSpriteNode!
    var lbMenuHighScore: SKLabelNode!
    var snMenuHighScore: SKSpriteNode!
    var lbMenuAbout: SKLabelNode!
    var snMenuAbout: SKSpriteNode!
    var iButtonPressed: Int!
    var apClick: AVAudioPlayer!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        iButtonPressed = 0
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
        let flMenuSpriteWidth = (SKTexture(imageNamed: "Media/menu_top.png").size().width) * (self.frame.width/667.0)
        let flMenuSpriteHeight = (SKTexture(imageNamed: "Media/menu_top.png").size().height) * (self.frame.height/375.0)
        // Menu "Play" Sprite
        snMenuPlay = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_top.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuSpriteWidth, flMenuSpriteHeight))
        snMenuPlay.anchorPoint = CGPointMake(0.5, 0.5)
        snMenuPlay.position = CGPoint(x: CGRectGetMidX(self.frame), y: 10*(self.frame.height / 12))
        snMenuPlay.zPosition = 1.0
        snMenuPlay.alpha = 1.0
        snMenuPlay.name = "MenuPlay"
        addChild(snMenuPlay)
        // Menu "Play" Text
        lbMenuPlay = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuPlay.horizontalAlignmentMode = .Center;
        lbMenuPlay.verticalAlignmentMode = .Center
        lbMenuPlay.text = "PLAY"
        lbMenuPlay.fontSize = 30 * (self.frame.width/667.0)
        lbMenuPlay.position = CGPoint(x: CGRectGetMidX(self.frame), y: 10*(self.frame.height / 12))
        lbMenuPlay.fontColor = UIColor.whiteColor()
        lbMenuPlay.zPosition = 1.0
        lbMenuPlay.name = "MenuPlay"
        addChild(lbMenuPlay)
        // Menu "Tutorial" Sprite
        snMenuTutorial = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_middle.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuSpriteWidth, flMenuSpriteHeight))
        snMenuTutorial.anchorPoint = CGPointMake(0.5, 0.5)
        snMenuTutorial.position = CGPoint(x: CGRectGetMidX(self.frame), y: 8*(self.frame.height / 12))
        snMenuTutorial.zPosition = 1.0
        snMenuTutorial.alpha = 1.0
        snMenuTutorial.name = "MenuTutorial"
        addChild(snMenuTutorial)
        // Menu "Tutorial" Text
        lbMenuTutorial = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuTutorial.horizontalAlignmentMode = .Center;
        lbMenuTutorial.verticalAlignmentMode = .Center
        lbMenuTutorial.text = "TUTORIAL"
        lbMenuTutorial.fontSize = 30 * (self.frame.width/667.0)
        lbMenuTutorial.position = CGPoint(x: CGRectGetMidX(self.frame), y: 8*(self.frame.height / 12))
        lbMenuTutorial.fontColor = UIColor.whiteColor()
        lbMenuTutorial.zPosition = 1.0
        lbMenuTutorial.name = "MenuTutorial"
        self.addChild(lbMenuTutorial)
        // Menu "Options" Sprite
        snMenuOptions = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_middle.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuSpriteWidth, flMenuSpriteHeight))
        snMenuOptions.anchorPoint = CGPointMake(0.5, 0.5)
        snMenuOptions.position = CGPoint(x: CGRectGetMidX(self.frame), y: 6*(self.frame.height / 12))
        snMenuOptions.zPosition = 1.0
        snMenuOptions.alpha = 1.0
        snMenuOptions.name = "MenuOptions"
        addChild(snMenuOptions)
        // Menu "Options" Text
        lbMenuOptions = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuOptions.horizontalAlignmentMode = .Center;
        lbMenuOptions.verticalAlignmentMode = .Center
        lbMenuOptions.text = "OPTIONS"
        lbMenuOptions.fontSize = 30 * (self.frame.width/667.0)
        lbMenuOptions.position = CGPoint(x: CGRectGetMidX(self.frame), y: 6*(self.frame.height / 12))
        lbMenuOptions.fontColor = UIColor.whiteColor()
        lbMenuOptions.zPosition = 1.0
        lbMenuOptions.name = "MenuOptions"
        self.addChild(lbMenuOptions)
        // Menu "HighScore" Sprite
        snMenuHighScore = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_middle.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuSpriteWidth, flMenuSpriteHeight))
        snMenuHighScore.anchorPoint = CGPointMake(0.5, 0.5)
        snMenuHighScore.position = CGPoint(x: CGRectGetMidX(self.frame), y: 4*(self.frame.height / 12))
        snMenuHighScore.zPosition = 1.0
        snMenuHighScore.alpha = 1.0
        snMenuHighScore.name = "MenuHighScore"
        addChild(snMenuHighScore)
        // Menu "Highscore" Text
        lbMenuHighScore = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuHighScore.horizontalAlignmentMode = .Center;
        lbMenuHighScore.verticalAlignmentMode = .Center
        lbMenuHighScore.text = "HIGHSCORE"
        lbMenuHighScore.fontSize = 30 * (self.frame.width/667.0)
        lbMenuHighScore.position = CGPoint(x: CGRectGetMidX(self.frame), y: 4*(self.frame.height / 12))
        lbMenuHighScore.fontColor = UIColor.whiteColor()
        lbMenuHighScore.zPosition = 1.0
        lbMenuHighScore.name = "MenuHighScore"
        self.addChild(lbMenuHighScore)
        // Menu "About" Sprite
        snMenuAbout = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_bottom.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuSpriteWidth, flMenuSpriteHeight))
        snMenuAbout.anchorPoint = CGPointMake(0.5, 0.5)
        snMenuAbout.position = CGPoint(x: CGRectGetMidX(self.frame), y: 2*(self.frame.height / 12))
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
        lbMenuAbout.position = CGPoint(x: CGRectGetMidX(self.frame), y: 2*(self.frame.height / 12))
        lbMenuAbout.fontColor = UIColor.whiteColor()
        lbMenuAbout.zPosition = 1.0
        lbMenuAbout.name = "MenuAbout"
        self.addChild(lbMenuAbout)
        // Version
        let lbVersion = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lbVersion.text = strVersion
        lbVersion.fontSize = 15 * (self.frame.width/667.0)
        lbVersion.horizontalAlignmentMode = .Right;
        lbVersion.position = CGPoint(x: (self.frame.width - 5), y: 5)
        lbVersion.fontColor = UIColor.whiteColor()
        lbVersion.zPosition = 1.0
        self.addChild(lbVersion)
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
                case "MenuPlay"?:
                    snMenuPlay.texture = SKTexture(imageNamed: "Media/menu_top_pressed.png")
                    lbMenuPlay.fontColor = UIColor.blackColor()
                    iButtonPressed = 1
                    fctPlayClickSound()
                case "MenuTutorial"?:
                    snMenuTutorial.texture = SKTexture(imageNamed: "Media/menu_middle_pressed.png")
                    lbMenuTutorial.fontColor = UIColor.blackColor()
                    iButtonPressed = 2
                    fctPlayClickSound()
                case "MenuOptions"?:
                    snMenuOptions.texture = SKTexture(imageNamed: "Media/menu_middle_pressed.png")
                    lbMenuOptions.fontColor = UIColor.blackColor()
                    iButtonPressed = 3
                    fctPlayClickSound()
                case "MenuHighScore"?:
                    snMenuHighScore.texture = SKTexture(imageNamed: "Media/menu_middle_pressed.png")
                    lbMenuHighScore.fontColor = UIColor.blackColor()
                    iButtonPressed = 4
                    fctPlayClickSound()
                case "MenuAbout"?:
                    snMenuAbout.texture = SKTexture(imageNamed: "Media/menu_bottom_pressed.png")
                    lbMenuAbout.fontColor = UIColor.blackColor()
                    iButtonPressed = 5
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
        // Reset pressed sprites
        snMenuPlay.texture = SKTexture(imageNamed: "Media/menu_top.png")
        snMenuTutorial.texture = SKTexture(imageNamed: "Media/menu_middle.png")
        snMenuOptions.texture = SKTexture(imageNamed: "Media/menu_middle.png")
        snMenuHighScore.texture = SKTexture(imageNamed: "Media/menu_middle.png")
        snMenuAbout.texture = SKTexture(imageNamed: "Media/menu_bottom.png")
        // Screen elements
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            switch (touchedNode.name) {
            case "MenuPlay"?:
                if iButtonPressed == 1 {
                    let transition = SKTransition.fadeWithColor(.blackColor(), duration: 0.4)
                    gzGame = GameScene(size: scene!.size)
                    gzGame.scaleMode = .AspectFill
                    scene?.view?.presentScene(gzGame, transition: transition)
                    self.removeFromParent()
                }
            case "MenuTutorial"?:
                if iButtonPressed == 2 {
                    let transition = SKTransition.fadeWithColor(.blackColor(), duration: 0.2)
                    let nextScene = TLGameMenuTutorial(size: scene!.size)
                    nextScene.scaleMode = .AspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
                }
            case "MenuOptions"?:
                if iButtonPressed == 3 {
                    let transition = SKTransition.fadeWithColor(.blackColor(), duration: 0.2)
                    let nextScene = TLGameMenuOptions(size: scene!.size)
                    nextScene.scaleMode = .AspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
                    self.removeFromParent()
                }
            case "MenuHighScore"?:
                if iButtonPressed == 4 {
                    let transition = SKTransition.fadeWithColor(.blackColor(), duration: 0.2)
                    let nextScene = TLGameMenuHighscore(size: scene!.size)
                    nextScene.scaleMode = .AspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
                    self.removeFromParent()
                }
            case "MenuAbout"?:
                if iButtonPressed == 5 {
                    let transition = SKTransition.fadeWithColor(.blackColor(), duration: 0.2)
                    let nextScene = TLGameMenuAbout(size: scene!.size)
                    nextScene.scaleMode = .AspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
                    self.removeFromParent()
                }
            default:
                ()
            }
        }
        
        iButtonPressed = 0
        snMenuPlay.texture = SKTexture(imageNamed: "Media/menu_top.png")
        lbMenuPlay.fontColor = UIColor.whiteColor()
        snMenuTutorial.texture = SKTexture(imageNamed: "Media/menu_middle.png")
        lbMenuTutorial.fontColor = UIColor.whiteColor()
        snMenuOptions.texture = SKTexture(imageNamed: "Media/menu_middle.png")
        lbMenuOptions.fontColor = UIColor.whiteColor()
        snMenuHighScore.texture = SKTexture(imageNamed: "Media/menu_middle.png")
        lbMenuHighScore.fontColor = UIColor.whiteColor()
        snMenuAbout.texture = SKTexture(imageNamed: "Media/menu_bottom.png")
        lbMenuAbout.fontColor = UIColor.whiteColor()
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
    
}
