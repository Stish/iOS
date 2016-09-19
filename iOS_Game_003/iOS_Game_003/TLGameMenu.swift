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
    var lbMenuAchieve: SKLabelNode!
    var snMenuAchieve: SKSpriteNode!
    var snMenuAbout: SKSpriteNode!
    var iButtonPressed: Int!
    var apClick: AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        iButtonPressed = 0
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
        let flMenuSpriteWidth = (SKTexture(imageNamed: "Media/menu_top.png").size().width) * (self.frame.width/667.0)
        let flMenuSpriteHeight = (SKTexture(imageNamed: "Media/menu_top.png").size().height) * (self.frame.height/375.0)
        // Menu "Play" Sprite
        snMenuPlay = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_top.png"), color: UIColor.clear, size: CGSize(width: flMenuSpriteWidth, height: flMenuSpriteHeight))
        snMenuPlay.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snMenuPlay.position = CGPoint(x: self.frame.midX, y: 10*(self.frame.height / 12))
        snMenuPlay.zPosition = 1.0
        snMenuPlay.alpha = 1.0
        snMenuPlay.name = "MenuPlay"
        addChild(snMenuPlay)
        // Menu "Play" Text
        lbMenuPlay = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuPlay.horizontalAlignmentMode = .center;
        lbMenuPlay.verticalAlignmentMode = .center
        lbMenuPlay.text = "PLAY"
        lbMenuPlay.fontSize = 30 * (self.frame.width/667.0)
        lbMenuPlay.position = CGPoint(x: self.frame.midX, y: 10*(self.frame.height / 12))
        lbMenuPlay.fontColor = UIColor.white
        lbMenuPlay.zPosition = 1.0
        lbMenuPlay.name = "MenuPlay"
        addChild(lbMenuPlay)
        // Menu "Tutorial" Sprite
        snMenuTutorial = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_middle.png"), color: UIColor.clear, size: CGSize(width: flMenuSpriteWidth, height: flMenuSpriteHeight))
        snMenuTutorial.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snMenuTutorial.position = CGPoint(x: self.frame.midX, y: 8*(self.frame.height / 12))
        snMenuTutorial.zPosition = 1.0
        snMenuTutorial.alpha = 1.0
        snMenuTutorial.name = "MenuTutorial"
        addChild(snMenuTutorial)
        // Menu "Tutorial" Text
        lbMenuTutorial = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuTutorial.horizontalAlignmentMode = .center;
        lbMenuTutorial.verticalAlignmentMode = .center
        lbMenuTutorial.text = "TUTORIAL"
        lbMenuTutorial.fontSize = 30 * (self.frame.width/667.0)
        lbMenuTutorial.position = CGPoint(x: self.frame.midX, y: 8*(self.frame.height / 12))
        lbMenuTutorial.fontColor = UIColor.white
        lbMenuTutorial.zPosition = 1.0
        lbMenuTutorial.name = "MenuTutorial"
        self.addChild(lbMenuTutorial)
        // Menu "Achieve" Sprite
        snMenuAchieve = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_middle.png"), color: UIColor.clear, size: CGSize(width: flMenuSpriteWidth, height: flMenuSpriteHeight))
        snMenuAchieve.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snMenuAchieve.position = CGPoint(x: self.frame.midX, y: 6*(self.frame.height / 12))
        snMenuAchieve.zPosition = 1.0
        snMenuAchieve.alpha = 1.0
        snMenuAchieve.name = "MenuAchieve"
        addChild(snMenuAchieve)
        // Menu "Achieve" Text
        lbMenuAchieve = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuAchieve.horizontalAlignmentMode = .center;
        lbMenuAchieve.verticalAlignmentMode = .center
        lbMenuAchieve.text = "ACHIEVEMENT"
        lbMenuAchieve.fontSize = 30 * (self.frame.width/667.0)
        lbMenuAchieve.position = CGPoint(x: self.frame.midX, y: 6*(self.frame.height / 12))
        lbMenuAchieve.fontColor = UIColor.white
        lbMenuAchieve.zPosition = 1.0
        lbMenuAchieve.name = "MenuAchieve"
        self.addChild(lbMenuAchieve)
        // Menu "HighScore" Sprite
        snMenuHighScore = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_middle.png"), color: UIColor.clear, size: CGSize(width: flMenuSpriteWidth, height: flMenuSpriteHeight))
        snMenuHighScore.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snMenuHighScore.position = CGPoint(x: self.frame.midX, y: 4*(self.frame.height / 12))
        snMenuHighScore.zPosition = 1.0
        snMenuHighScore.alpha = 1.0
        snMenuHighScore.name = "MenuHighScore"
        addChild(snMenuHighScore)
        // Menu "Highscore" Text
        lbMenuHighScore = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuHighScore.horizontalAlignmentMode = .center;
        lbMenuHighScore.verticalAlignmentMode = .center
        lbMenuHighScore.text = "HIGHSCORE"
        lbMenuHighScore.fontSize = 30 * (self.frame.width/667.0)
        lbMenuHighScore.position = CGPoint(x: self.frame.midX, y: 4*(self.frame.height / 12))
        lbMenuHighScore.fontColor = UIColor.white
        lbMenuHighScore.zPosition = 1.0
        lbMenuHighScore.name = "MenuHighScore"
        self.addChild(lbMenuHighScore)
        // Menu "Options" Sprite
        snMenuOptions = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_bottom.png"), color: UIColor.clear, size: CGSize(width: flMenuSpriteWidth, height: flMenuSpriteHeight))
        snMenuOptions.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snMenuOptions.position = CGPoint(x: self.frame.midX, y: 2*(self.frame.height / 12))
        snMenuOptions.zPosition = 1.0
        snMenuOptions.alpha = 1.0
        snMenuOptions.name = "MenuOptions"
        addChild(snMenuOptions)
        // Menu "Options" Text
        lbMenuOptions = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuOptions.horizontalAlignmentMode = .center;
        lbMenuOptions.verticalAlignmentMode = .center
        lbMenuOptions.text = "OPTIONS"
        lbMenuOptions.fontSize = 30 * (self.frame.width/667.0)
        lbMenuOptions.position = CGPoint(x: self.frame.midX, y: 2*(self.frame.height / 12))
        lbMenuOptions.fontColor = UIColor.white
        lbMenuOptions.zPosition = 1.0
        lbMenuOptions.name = "MenuOptions"
        self.addChild(lbMenuOptions)
        // Menu "Back" Sprite
        let flMenuAboutSpriteWidth = (SKTexture(imageNamed: "Media/menu_about.png").size().width) * (self.frame.width/667.0)
        let flMenuAboutSpriteHeight = (SKTexture(imageNamed: "Media/menu_about.png").size().height) * (self.frame.height/375.0)
        snMenuAbout = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_about.png"), color: UIColor.clear, size: CGSize(width: flMenuAboutSpriteWidth, height: flMenuAboutSpriteHeight))
        snMenuAbout.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        snMenuAbout.position = CGPoint(x: 1*(self.frame.width / 16), y: 2*(self.frame.height / 12))
        snMenuAbout.zPosition = 1.0
        snMenuAbout.alpha = 1.0
        snMenuAbout.name = "MenuAbout"
        self.addChild(snMenuAbout)
        // Version
        let lbVersion = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lbVersion.text = strVersion
        lbVersion.fontSize = 15 * (self.frame.width/667.0)
        lbVersion.horizontalAlignmentMode = .right;
        lbVersion.position = CGPoint(x: (self.frame.width - 5), y: 5)
        lbVersion.fontColor = UIColor.white
        lbVersion.zPosition = 1.0
        self.addChild(lbVersion)
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
                case "MenuPlay"?:
                    snMenuPlay.texture = SKTexture(imageNamed: "Media/menu_top_pressed.png")
                    lbMenuPlay.fontColor = UIColor.black
                    iButtonPressed = 1
                    fctPlayClickSound()
                case "MenuTutorial"?:
                    snMenuTutorial.texture = SKTexture(imageNamed: "Media/menu_middle_pressed.png")
                    lbMenuTutorial.fontColor = UIColor.black
                    iButtonPressed = 2
                    fctPlayClickSound()
                case "MenuAchieve"?:
                    snMenuAchieve.texture = SKTexture(imageNamed: "Media/menu_middle_pressed.png")
                    lbMenuAchieve.fontColor = UIColor.black
                    iButtonPressed = 3
                    fctPlayClickSound()
                case "MenuHighScore"?:
                    snMenuHighScore.texture = SKTexture(imageNamed: "Media/menu_middle_pressed.png")
                    lbMenuHighScore.fontColor = UIColor.black
                    iButtonPressed = 4
                    fctPlayClickSound()
                case "MenuOptions"?:
                    snMenuOptions.texture = SKTexture(imageNamed: "Media/menu_bottom_pressed.png")
                    lbMenuOptions.fontColor = UIColor.black
                    iButtonPressed = 5
                    fctPlayClickSound()
                case "MenuAbout"?:
                    //snMenuAbout.texture = SKTexture(imageNamed: "Media/menu_bottom_pressed.png")
                    iButtonPressed = 6
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
        snMenuPlay.texture = SKTexture(imageNamed: "Media/menu_top.png")
        snMenuTutorial.texture = SKTexture(imageNamed: "Media/menu_middle.png")
        snMenuAchieve.texture = SKTexture(imageNamed: "Media/menu_middle.png")
        snMenuHighScore.texture = SKTexture(imageNamed: "Media/menu_middle.png")
        snMenuOptions.texture = SKTexture(imageNamed: "Media/menu_bottom.png")
        // Screen elements
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            switch (touchedNode.name) {
            case "MenuPlay"?:
                if iButtonPressed == 1 {
                    let transition = SKTransition.fade(with: .black, duration: 0.4)
                    gzGame = GameScene(size: scene!.size)
                    gzGame.scaleMode = .aspectFill
                    scene?.view?.presentScene(gzGame, transition: transition)
                    self.removeFromParent()
                }
            case "MenuTutorial"?:
                if iButtonPressed == 2 {
                    let transition = SKTransition.fade(with: .black, duration: 0.2)
                    let nextScene = TLGameMenuTutorial(size: scene!.size)
                    nextScene.scaleMode = .aspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
                }
            case "MenuAchieve"?:
                if iButtonPressed == 3 {
                    let transition = SKTransition.fade(with: .black, duration: 0.2)
                    let nextScene = TLGameMenuAchievements(size: scene!.size)
                    nextScene.scaleMode = .aspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
                    self.removeFromParent()
                }
            case "MenuHighScore"?:
                if iButtonPressed == 4 {
                    let transition = SKTransition.fade(with: .black, duration: 0.2)
                    let nextScene = TLGameMenuHighscore(size: scene!.size)
                    nextScene.scaleMode = .aspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
                    self.removeFromParent()
                }
            case "MenuOptions"?:
                if iButtonPressed == 5 {
                    let transition = SKTransition.fade(with: .black, duration: 0.2)
                    let nextScene = TLGameMenuOptions(size: scene!.size)
                    nextScene.scaleMode = .aspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
                    self.removeFromParent()
                }
            case "MenuAbout"?:
                if iButtonPressed == 6 {
                    let transition = SKTransition.fade(with: .black, duration: 0.2)
                    let nextScene = TLGameMenuAbout(size: scene!.size)
                    nextScene.scaleMode = .aspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
                    self.removeFromParent()
                }
            default:
                ()
            }
        }
        
        iButtonPressed = 0
        snMenuPlay.texture = SKTexture(imageNamed: "Media/menu_top.png")
        lbMenuPlay.fontColor = UIColor.white
        snMenuTutorial.texture = SKTexture(imageNamed: "Media/menu_middle.png")
        lbMenuTutorial.fontColor = UIColor.white
        snMenuAchieve.texture = SKTexture(imageNamed: "Media/menu_middle.png")
        lbMenuAchieve.fontColor = UIColor.white
        snMenuHighScore.texture = SKTexture(imageNamed: "Media/menu_middle.png")
        lbMenuHighScore.fontColor = UIColor.white
        snMenuOptions.texture = SKTexture(imageNamed: "Media/menu_bottom.png")
        lbMenuOptions.fontColor = UIColor.white
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
    
}
