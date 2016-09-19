//
//  TLGameMenuTutorial.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 07.07.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import SpriteKit
import AVFoundation

class TLGameMenuTutorial: SKScene, SKPhysicsContactDelegate {
    var lbMenuTutorial: SKLabelNode!
    var snMenuTutorial: SKSpriteNode!
    var snHUD: SKSpriteNode!
    var lbGameScoreTut: SKLabelNode!
    var lbGameTimeTut: SKLabelNode!
    var snMenuBack: SKSpriteNode!
    var snFingerMove: SKShapeNode!
    var snFingerShoot: SKShapeNode!
    var iButtonPressed: Int!
    var apClick: AVAudioPlayer!
    var iTime100ms: Int!
    var iTime100msCount: Int!
    var lbTutorialTextline1: SKLabelNode!
    var lbTutorialTextline2: SKLabelNode!
    var lbTutorialTextline3: SKLabelNode!
    var snTutTime: SKShapeNode!
    var snTutScore: SKShapeNode!
    var snTutShields: SKShapeNode!
    var snBomb1: SKSpriteNode!
    var snBomb2: SKSpriteNode!
    var snBomb3: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        physicsWorld.contactDelegate = self
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
        // Menu "Tutorial" Sprite
        snMenuTutorial = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_headline.png"), color: UIColor.clear, size: CGSize(width: flMenuSpriteWidth, height: flMenuSpriteHeight))
        snMenuTutorial.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        snMenuTutorial.position = CGPoint(x: 15*(self.frame.width / 16), y: 10*(self.frame.height / 12))
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
        lbMenuTutorial.position = CGPoint(x: snMenuTutorial.frame.midX, y: 10*(self.frame.height / 12))
        lbMenuTutorial.fontColor = UIColor.white
        lbMenuTutorial.zPosition = 1.0
        lbMenuTutorial.name = "MenuTutorial"
        self.addChild(lbMenuTutorial)
        // Menu "Back" Sprite
        snMenuBack = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_back.png"), color: UIColor.clear, size: CGSize(width: flMenuBackSpriteWidth, height: flMenuBackSpriteHeight))
        snMenuBack.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        snMenuBack.position = CGPoint(x: 1*(self.frame.width / 16), y: 10*(self.frame.height / 12))
        snMenuBack.zPosition = 1.0
        snMenuBack.alpha = 1.0
        snMenuBack.name = "MenuBack"
        self.addChild(snMenuBack)
        // --- Game objects ---
        // Ship sprite
        snShip = TLShip(size: CGSize(width: flShipSizeWidth, height: flShipSizeHeight))
        snShip.position = CGPoint(x: 120.0 * (self.frame.width/667.0) , y: (view.frame.height/2) - (50 * (self.frame.height/375.0)))
        snShip.zPosition = 1.1
        self.addChild(snShip)
        // Tutorial text line 1
        lbTutorialTextline1 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lbTutorialTextline1.horizontalAlignmentMode = .left;
        lbTutorialTextline1.verticalAlignmentMode = .center
        lbTutorialTextline1.text = ""
        lbTutorialTextline1.fontSize = 20 * (self.frame.width/667.0)
        lbTutorialTextline1.position = CGPoint(x: snShip.position.x + (70 * (self.frame.width/667.0)), y: snShip.position.y + 24)
        lbTutorialTextline1.fontColor = UIColor.white
        lbTutorialTextline1.zPosition = 1.0
        lbTutorialTextline1.name = "TutorialTextline1"
        self.addChild(lbTutorialTextline1)
        // Tutorial text line 2
        lbTutorialTextline2 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lbTutorialTextline2.horizontalAlignmentMode = .left;
        lbTutorialTextline2.verticalAlignmentMode = .center
        lbTutorialTextline2.text = "This is your ship."
        lbTutorialTextline2.fontSize = 20 * (self.frame.width/667.0)
        lbTutorialTextline2.position = CGPoint(x: snShip.position.x + (70 * (self.frame.width/667.0)), y: snShip.position.y)
        lbTutorialTextline2.fontColor = UIColor.white
        lbTutorialTextline2.zPosition = 1.0
        lbTutorialTextline2.name = "TutorialTextline2"
        self.addChild(lbTutorialTextline2)
        // Tutorial text line 3
        lbTutorialTextline3 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lbTutorialTextline3.horizontalAlignmentMode = .left;
        lbTutorialTextline3.verticalAlignmentMode = .center
        lbTutorialTextline3.text = ""
        lbTutorialTextline3.fontSize = 20 * (self.frame.width/667.0)
        lbTutorialTextline3.position = CGPoint(x: snShip.position.x + (70 * (self.frame.width/667.0)), y: snShip.position.y - 24)
        lbTutorialTextline3.fontColor = UIColor.white
        lbTutorialTextline3.zPosition = 1.0
        lbTutorialTextline3.name = "TutorialTextline3"
        self.addChild(lbTutorialTextline3)
        iTime100ms = 0
        iTime100msCount = 0
        // Bombs
        let flBombWidth = (SKTexture(imageNamed: "Media/pu_bomb_001_empty.png").size().width) * (self.frame.width/667.0)
        let flBombHeight = (SKTexture(imageNamed: "Media/pu_bomb_001_empty.png").size().height) * (self.frame.height/375.0)
        // Bomb 1
        snBomb1 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/pu_bomb_001.png"), color: UIColor.clear, size: CGSize(width: flBombWidth, height: flBombHeight))
        snBomb1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snBomb1.position = CGPoint(x: self.frame.midX - (180 * (self.frame.width/667.0)), y: 60 * (self.frame.height/375.0))
        snBomb1.zPosition = 1.0
        snBomb1.alpha = 0.0
        self.addChild(snBomb1)
        // Bomb 2
        snBomb2 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/pu_bomb_001.png"), color: UIColor.clear, size: CGSize(width: flBombWidth, height: flBombHeight))
        snBomb2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snBomb2.position = CGPoint(x: self.frame.midX - (145 * (self.frame.width/667.0)), y: 60 * (self.frame.height/375.0))
        snBomb2.zPosition = 1.0
        snBomb2.alpha = 0.0
        self.addChild(snBomb2)
        // Bomb 3
        snBomb3 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/pu_bomb_001_empty.png"), color: UIColor.clear, size: CGSize(width: flBombWidth, height: flBombHeight))
        snBomb3.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snBomb3.position = CGPoint(x: self.frame.midX - (110 * (self.frame.width/667.0)), y: 60 * (self.frame.height/375.0))
        snBomb3.zPosition = 1.0
        snBomb3.alpha = 0.0
        self.addChild(snBomb3)
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
            default:
                ()
            }
        }
        snMenuBack.texture = SKTexture(imageNamed: "Media/menu_back.png")
        iButtonPressed = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        if iTime100ms != Int(currentTime * 10) {
            iTime100ms = Int(currentTime * 10)
            iTime100msCount = iTime100msCount + 1
            if (iTime100msCount == 30) {
                lbTutorialTextline1.text = "You can fly up and down"
                lbTutorialTextline2.text = "using your finger."
                snFingerMove = SKShapeNode(circleOfRadius: 25  * (self.frame.width/667.0))
                snFingerMove.position = CGPoint(x: 55  * (self.frame.width/667.0), y: snShip.position.y)
                snFingerMove.strokeColor = SKColor.white
                snFingerMove.glowWidth = 4.0
                snFingerMove.fillColor = SKColor.white
                snFingerMove.zPosition = 1.1
                snFingerMove.alpha = 0.2
                self.addChild(snFingerMove)
            }
            if (iTime100msCount == 31) {
                snFingerMove.alpha = 0.4
            }
            if (iTime100msCount == 32) {
                snFingerMove.alpha = 0.6
            }
            if (iTime100msCount == 33) {
                snFingerMove.alpha = 0.8
            }
            if (iTime100msCount == 34) {
                snFingerMove.alpha = 1.0
            }
            if (iTime100msCount == 35) {
                let actMoveUp = SKAction.move(by: CGVector(dx: 0, dy: 100 * (self.frame.width/667.0)), duration: 1)
                let actMoveDown = SKAction.move(by: CGVector(dx: 0, dy: -200 * (self.frame.width/667.0)), duration: 2)
                let seqMove = SKAction.sequence([actMoveUp, actMoveDown, actMoveUp])
                
                snFingerMove.run(seqMove)
                //snShip.runAction(seqMove)
                lbTutorialTextline1.run(seqMove)
                lbTutorialTextline2.run(seqMove)
                snShip.fctStartFlyAnimationLeft()
                snShip.run(actMoveUp, completion: {() in
                    snShip.fctStartFlyAnimationRight()
                    snShip.run(actMoveDown, completion: {() in
                        snShip.fctStartFlyAnimationLeft()
                        snShip.run(actMoveUp, completion: {() in
                            snShip.fctStartFlyAnimationFront()
                        })
                    })
                })
            }
            if (iTime100msCount == 80) {
                snFingerMove.removeFromParent()
                lbTutorialTextline1.text = "You can shoot your weapon"
                lbTutorialTextline2.text = "with touching on the right"
                lbTutorialTextline3.text = "screen side."
                snFingerShoot = SKShapeNode(circleOfRadius: 25  * (self.frame.width/667.0))
                snFingerShoot.position = CGPoint(x: self.frame.width - (55  * (self.frame.width/667.0)), y: snShip.position.y + (50  * (self.frame.width/667.0)))
                snFingerShoot.strokeColor = SKColor.white
                snFingerShoot.glowWidth = 4.0
                snFingerShoot.fillColor = SKColor.white
                snFingerShoot.zPosition = 1.1
                snFingerShoot.alpha = 0.2
                self.addChild(snFingerShoot)
            }
            if (iTime100msCount == 81) {
                snFingerShoot.alpha = 0.4
            }
            if (iTime100msCount == 82) {
                snFingerShoot.alpha = 0.6
            }
            if (iTime100msCount == 83) {
                snFingerShoot.alpha = 0.8
            }
            if (iTime100msCount == 84) {
                snFingerShoot.alpha = 1.0
            }
            if (iTime100msCount == 85) {
                //print("right")
                flShipPosX = snShip.position.x
                flShipPosY = snShip.position.y
                let snLaser = TLLaser(size: CGSize(width: 60 * (self.frame.width/667.0), height: 5 * (self.frame.height/375.0)))
                snLaser.zPosition = 1.1
                self.addChild(snLaser)
                snLaser.fctMoveRight()
                snLaser.fctPlayShootingSound()
            }
            if (iTime100msCount == 90) {
                snFingerShoot.removeFromParent()
            }
            if (iTime100msCount == 120) {
                snFingerShoot.removeFromParent()
                // --- Interface ---
                lbGameScoreTut = SKLabelNode(fontNamed: fnGameFont?.fontName)
                lbGameScoreTut.text = "2200"
                lbGameScoreTut.fontSize = 22 * (self.frame.width/667.0)
                lbGameScoreTut.position = CGPoint(x: self.frame.midX + (216  * (self.frame.width/667.0)), y: 14 * (self.frame.height/375.0))
                lbGameScoreTut.fontColor = UIColor.orange
                lbGameScoreTut.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
                lbGameScoreTut.zPosition = 1.2
                self.addChild(lbGameScoreTut)
                
                snHUD = SKSpriteNode(texture: SKTexture(imageNamed: "Media/hud_002.png"), color: UIColor.clear, size: CGSize(width: 470 * (self.frame.width/667.0), height: 60 * (self.frame.height/375.0)))
                snHUD.anchorPoint = CGPoint(x: 0.5, y: 0)
                snHUD.position = CGPoint(x: self.frame.midX, y: 3 * (self.frame.height/375.0))
                snHUD.zPosition = 1.0
                snHUD.alpha = 0.1
                addChild(snHUD)
                snBomb1.alpha = 0.1
                snBomb2.alpha = 0.1
                snBomb3.alpha = 0.1
                
                lbGameTimeTut = SKLabelNode(fontNamed: fnGameFont?.fontName)
                lbGameTimeTut.text = "12"
                lbGameTimeTut.fontSize = 20 * (self.frame.width/667.0)
                lbGameTimeTut.position = CGPoint(x: self.frame.midX, y: 24 * (self.frame.height/375.0))
                lbGameTimeTut.fontColor = UIColor(red: 102/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
                lbGameTimeTut.zPosition = 1.2
                self.addChild(lbGameTimeTut)
                lbTutorialTextline1.text = "This is your HUD."
                lbTutorialTextline2.text = "It holds important"
                lbTutorialTextline3.text = "game information:"
            }
            if (iTime100msCount == 121) {
                snHUD.alpha = 0.2
                snBomb1.alpha = 0.2
                snBomb2.alpha = 0.2
                snBomb3.alpha = 0.2
            }
            if (iTime100msCount == 122) {
                snHUD.alpha = 0.3
                snBomb1.alpha = 0.3
                snBomb2.alpha = 0.3
                snBomb3.alpha = 0.3
            }
            if (iTime100msCount == 123) {
                snHUD.alpha = 0.4
                snBomb1.alpha = 0.4
                snBomb2.alpha = 0.4
                snBomb3.alpha = 0.4
            }
            if (iTime100msCount == 124) {
                snHUD.alpha = 0.5
                snBomb1.alpha = 0.5
                snBomb2.alpha = 0.5
                snBomb3.alpha = 0.5
            }
            if (iTime100msCount == 125) {
                snHUD.alpha = 0.6
                snBomb1.alpha = 0.6
                snBomb2.alpha = 0.6
                snBomb3.alpha = 0.6
            }
            if (iTime100msCount == 126) {
                snHUD.alpha = 0.75
                snBomb1.alpha = 0.75
                snBomb2.alpha = 0.75
                snBomb3.alpha = 0.75
            }
            if (iTime100msCount == 150) {
                lbTutorialTextline1.text = "The power of your shields."
                lbTutorialTextline1.fontColor = UIColor.lightGray
                lbTutorialTextline2.text = ""
                lbTutorialTextline3.text = ""
                snTutShields = SKShapeNode(rectOf: CGSize(width: 200 * (self.frame.width/667.0), height: 40 * (self.frame.width/667.0)))
                snTutShields.position = CGPoint(x: self.frame.midX - (140 * (self.frame.width/667.0)), y: 27 * (self.frame.height/375.0))
                snTutShields.strokeColor = SKColor.lightGray
                snTutShields.glowWidth = 0.5
                snTutShields.lineWidth = 5.0
                snTutShields.fillColor = SKColor.clear
                snTutShields.zPosition = 1.1
                snTutShields.alpha = 0.2
                self.addChild(snTutShields)
            }
            if (iTime100msCount == 151) {
                snTutShields.alpha = 0.4
            }
            if (iTime100msCount == 152) {
                snTutShields.alpha = 0.6
            }
            if (iTime100msCount == 153) {
                snTutShields.alpha = 0.8
            }
            if (iTime100msCount == 154) {
                snTutShields.alpha = 1.0
            }
            if (iTime100msCount == 170) {
                lbTutorialTextline2.text = "The game time in seconds."
                lbTutorialTextline2.fontColor = UIColor(red: 102/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
                snTutTime = SKShapeNode(rectOf: CGSize(width: 55 * (self.frame.width/667.0), height: 55 * (self.frame.width/667.0)))
                snTutTime.position = CGPoint(x: self.frame.midX, y: 35 * (self.frame.height/375.0))
                snTutTime.strokeColor = UIColor(red: 102/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
                snTutTime.glowWidth = 0.5
                snTutTime.lineWidth = 5.0
                snTutTime.fillColor = SKColor.clear
                snTutTime.zPosition = 1.1
                snTutTime.alpha = 0.2
                self.addChild(snTutTime)
            }
            if (iTime100msCount == 171) {
                snTutTime.alpha = 0.4
            }
            if (iTime100msCount == 172) {
                snTutTime.alpha = 0.6
            }
            if (iTime100msCount == 173) {
                snTutTime.alpha = 0.8
            }
            if (iTime100msCount == 174) {
                snTutTime.alpha = 1.0
            }
            if (iTime100msCount == 190) {
                lbTutorialTextline3.text = "Your current game score."
                lbTutorialTextline3.fontColor = UIColor.orange
                snTutScore = SKShapeNode(rectOf: CGSize(width: 200 * (self.frame.width/667.0), height: 40 * (self.frame.width/667.0)))
                snTutScore.position = CGPoint(x: self.frame.midX + (140 * (self.frame.width/667.0)), y: 27 * (self.frame.height/375.0))
                snTutScore.strokeColor = SKColor.orange
                snTutScore.glowWidth = 0.5
                snTutScore.lineWidth = 5.0
                snTutScore.fillColor = SKColor.clear
                snTutScore.zPosition = 1.1
                snTutScore.alpha = 0.2
                self.addChild(snTutScore)
            }
            if (iTime100msCount == 191) {
                snTutScore.alpha = 0.4
            }
            if (iTime100msCount == 192) {
                snTutScore.alpha = 0.6
            }
            if (iTime100msCount == 193) {
                snTutScore.alpha = 0.8
            }
            if (iTime100msCount == 194) {
                snTutScore.alpha = 1.0
            }
            if (iTime100msCount == 220) {
                snTutScore.removeFromParent()
                snTutTime.removeFromParent()
                snTutShields.removeFromParent()
                snHUD.removeFromParent()
                snBomb1.removeFromParent()
                snBomb2.removeFromParent()
                snBomb3.removeFromParent()
                lbGameTimeTut.removeFromParent()
                lbGameScoreTut.removeFromParent()
                lbTutorialTextline1.fontColor = UIColor.white
                lbTutorialTextline2.fontColor = UIColor.white
                lbTutorialTextline3.fontColor = UIColor.white
                lbTutorialTextline1.text = "Avoid or shoot the"
                lbTutorialTextline2.text = "obstacles in your way."
                lbTutorialTextline3.text = "Have fun :-)"
            }
            if (iTime100msCount == 260) {
                lbTutorialTextline1.text = ""
                lbTutorialTextline2.text = ""
                lbTutorialTextline3.text = ""
            }
            if (iTime100msCount == 280) {
                iTime100msCount = 0
                lbTutorialTextline1.text = "This is your ship."
            }
        }
    }
    
    func fctPlayClickSound() {
        if GameData.blSoundEffectsEnabled == true {
            apClick.volume = GameData.flSoundsVolume
            apClick.prepareToPlay()
            apClick.play()
        }
    }
}

