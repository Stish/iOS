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
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        physicsWorld.contactDelegate = self
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
        // Menu "Tutorial" Sprite
        snMenuTutorial = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_headline.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuSpriteWidth, flMenuSpriteHeight))
        snMenuTutorial.anchorPoint = CGPointMake(1.0, 0.5)
        snMenuTutorial.position = CGPoint(x: 15*(self.frame.width / 16), y: 10*(self.frame.height / 12))
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
        lbMenuTutorial.position = CGPoint(x: CGRectGetMidX(snMenuTutorial.frame), y: 10*(self.frame.height / 12))
        lbMenuTutorial.fontColor = UIColor.whiteColor()
        lbMenuTutorial.zPosition = 1.0
        lbMenuTutorial.name = "MenuTutorial"
        self.addChild(lbMenuTutorial)
        // Menu "Back" Sprite
        snMenuBack = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_back.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuBackSpriteWidth, flMenuBackSpriteHeight))
        snMenuBack.anchorPoint = CGPointMake(0.0, 0.5)
        snMenuBack.position = CGPoint(x: 1*(self.frame.width / 16), y: 10*(self.frame.height / 12))
        snMenuBack.zPosition = 1.0
        snMenuBack.alpha = 1.0
        snMenuBack.name = "MenuBack"
        self.addChild(snMenuBack)
        // --- Game objects ---
        // Ship sprite
        snShip = TLShip(size: CGSizeMake(flShipSizeWidth, flShipSizeHeight))
        snShip.position = CGPoint(x: 120.0 * (self.frame.width/667.0) , y: (view.frame.height/2) - (50 * (self.frame.height/375.0)))
        snShip.zPosition = 1.1
        self.addChild(snShip)
        // Tutorial text line 1
        lbTutorialTextline1 = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbTutorialTextline1.horizontalAlignmentMode = .Left;
        lbTutorialTextline1.verticalAlignmentMode = .Center
        lbTutorialTextline1.text = ""
        lbTutorialTextline1.fontSize = 20 * (self.frame.width/667.0)
        lbTutorialTextline1.position = CGPoint(x: snShip.position.x + (70 * (self.frame.width/667.0)), y: snShip.position.y + 24)
        lbTutorialTextline1.fontColor = UIColor.whiteColor()
        lbTutorialTextline1.zPosition = 1.0
        lbTutorialTextline1.name = "TutorialTextline1"
        self.addChild(lbTutorialTextline1)
        // Tutorial text line 2
        lbTutorialTextline2 = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbTutorialTextline2.horizontalAlignmentMode = .Left;
        lbTutorialTextline2.verticalAlignmentMode = .Center
        lbTutorialTextline2.text = "This is your ship."
        lbTutorialTextline2.fontSize = 20 * (self.frame.width/667.0)
        lbTutorialTextline2.position = CGPoint(x: snShip.position.x + (70 * (self.frame.width/667.0)), y: snShip.position.y)
        lbTutorialTextline2.fontColor = UIColor.whiteColor()
        lbTutorialTextline2.zPosition = 1.0
        lbTutorialTextline2.name = "TutorialTextline2"
        self.addChild(lbTutorialTextline2)
        // Tutorial text line 3
        lbTutorialTextline3 = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbTutorialTextline3.horizontalAlignmentMode = .Left;
        lbTutorialTextline3.verticalAlignmentMode = .Center
        lbTutorialTextline3.text = ""
        lbTutorialTextline3.fontSize = 20 * (self.frame.width/667.0)
        lbTutorialTextline3.position = CGPoint(x: snShip.position.x + (70 * (self.frame.width/667.0)), y: snShip.position.y - 24)
        lbTutorialTextline3.fontColor = UIColor.whiteColor()
        lbTutorialTextline3.zPosition = 1.0
        lbTutorialTextline3.name = "TutorialTextline3"
        self.addChild(lbTutorialTextline3)
        iTime100ms = 0
        iTime100msCount = 0
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
        if iTime100ms != Int(currentTime * 10) {
            iTime100ms = Int(currentTime * 10)
            iTime100msCount = iTime100msCount + 1
            if (iTime100msCount == 30) {
                lbTutorialTextline1.text = "You can fly up and down"
                lbTutorialTextline2.text = "using your finger."
                snFingerMove = SKShapeNode(circleOfRadius: 25  * (self.frame.width/667.0))
                snFingerMove.position = CGPointMake(55  * (self.frame.width/667.0), snShip.position.y)
                snFingerMove.strokeColor = SKColor.whiteColor()
                snFingerMove.glowWidth = 4.0
                snFingerMove.fillColor = SKColor.whiteColor()
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
                let actMoveUp = SKAction.moveBy(CGVectorMake(0, 100 * (self.frame.width/667.0)), duration: 1)
                let actMoveDown = SKAction.moveBy(CGVectorMake(0, -200 * (self.frame.width/667.0)), duration: 2)
                let seqMove = SKAction.sequence([actMoveUp, actMoveDown, actMoveUp])
                
                snFingerMove.runAction(seqMove)
                //snShip.runAction(seqMove)
                lbTutorialTextline1.runAction(seqMove)
                lbTutorialTextline2.runAction(seqMove)
                snShip.fctStartFlyAnimationLeft()
                snShip.runAction(actMoveUp, completion: {() in
                    snShip.fctStartFlyAnimationRight()
                    snShip.runAction(actMoveDown, completion: {() in
                        snShip.fctStartFlyAnimationLeft()
                        snShip.runAction(actMoveUp, completion: {() in
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
                snFingerShoot.position = CGPointMake(self.frame.width - (55  * (self.frame.width/667.0)), snShip.position.y + (50  * (self.frame.width/667.0)))
                snFingerShoot.strokeColor = SKColor.whiteColor()
                snFingerShoot.glowWidth = 4.0
                snFingerShoot.fillColor = SKColor.whiteColor()
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
                snShip.fctPlayShootingSound()
                //print("right")
                flShipPosX = snShip.position.x
                flShipPosY = snShip.position.y
                let snLaser = TLLaser(size: CGSizeMake(60 * (self.frame.width/667.0), 5 * (self.frame.height/375.0)))
                snLaser.zPosition = 1.1
                self.addChild(snLaser)
                snLaser.fctMoveRight()
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
                lbGameScoreTut.position = CGPoint(x: CGRectGetMidX(self.frame) + (216  * (self.frame.width/667.0)), y: 14 * (self.frame.height/375.0))
                lbGameScoreTut.fontColor = UIColor.orangeColor()
                lbGameScoreTut.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
                lbGameScoreTut.zPosition = 1.2
                self.addChild(lbGameScoreTut)
                
                snHUD = SKSpriteNode(texture: SKTexture(imageNamed: "Media/hud_002.png"), color: UIColor.clearColor(), size: CGSizeMake(470 * (self.frame.width/667.0), 60 * (self.frame.height/375.0)))
                snHUD.anchorPoint = CGPointMake(0.5, 0)
                snHUD.position = CGPoint(x: CGRectGetMidX(self.frame), y: 3 * (self.frame.height/375.0))
                snHUD.zPosition = 1.0
                snHUD.alpha = 0.1
                addChild(snHUD)
                
                lbGameTimeTut = SKLabelNode(fontNamed: fnGameFont?.fontName)
                lbGameTimeTut.text = "12"
                lbGameTimeTut.fontSize = 20 * (self.frame.width/667.0)
                lbGameTimeTut.position = CGPoint(x: CGRectGetMidX(self.frame), y: 24 * (self.frame.height/375.0))
                lbGameTimeTut.fontColor = UIColor(red: 102/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
                lbGameTimeTut.zPosition = 1.2
                self.addChild(lbGameTimeTut)
                lbTutorialTextline1.text = "This is your HUD."
                lbTutorialTextline2.text = "It holds important"
                lbTutorialTextline3.text = "game information:"
            }
            if (iTime100msCount == 121) {
                snHUD.alpha = 0.2
            }
            if (iTime100msCount == 122) {
                snHUD.alpha = 0.3
            }
            if (iTime100msCount == 123) {
                snHUD.alpha = 0.4
            }
            if (iTime100msCount == 124) {
                snHUD.alpha = 0.5
            }
            if (iTime100msCount == 125) {
                snHUD.alpha = 0.6
            }
            if (iTime100msCount == 126) {
                snHUD.alpha = 0.75
            }
            if (iTime100msCount == 150) {
                lbTutorialTextline1.text = "The power of your shields."
                lbTutorialTextline1.fontColor = UIColor.lightGrayColor()
                lbTutorialTextline2.text = ""
                lbTutorialTextline3.text = ""
                snTutShields = SKShapeNode(rectOfSize: CGSize(width: 200 * (self.frame.width/667.0), height: 40 * (self.frame.width/667.0)))
                snTutShields.position = CGPoint(x: CGRectGetMidX(self.frame) - (140 * (self.frame.width/667.0)), y: 27 * (self.frame.height/375.0))
                snTutShields.strokeColor = SKColor.lightGrayColor()
                snTutShields.glowWidth = 0.5
                snTutShields.lineWidth = 5.0
                snTutShields.fillColor = SKColor.clearColor()
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
                snTutTime = SKShapeNode(rectOfSize: CGSize(width: 55 * (self.frame.width/667.0), height: 55 * (self.frame.width/667.0)))
                snTutTime.position = CGPoint(x: CGRectGetMidX(self.frame), y: 35 * (self.frame.height/375.0))
                snTutTime.strokeColor = UIColor(red: 102/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
                snTutTime.glowWidth = 0.5
                snTutTime.lineWidth = 5.0
                snTutTime.fillColor = SKColor.clearColor()
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
                lbTutorialTextline3.fontColor = UIColor.orangeColor()
                snTutScore = SKShapeNode(rectOfSize: CGSize(width: 200 * (self.frame.width/667.0), height: 40 * (self.frame.width/667.0)))
                snTutScore.position = CGPoint(x: CGRectGetMidX(self.frame) + (140 * (self.frame.width/667.0)), y: 27 * (self.frame.height/375.0))
                snTutScore.strokeColor = SKColor.orangeColor()
                snTutScore.glowWidth = 0.5
                snTutScore.lineWidth = 5.0
                snTutScore.fillColor = SKColor.clearColor()
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
                lbGameTimeTut.removeFromParent()
                lbGameScoreTut.removeFromParent()
                lbTutorialTextline1.fontColor = UIColor.whiteColor()
                lbTutorialTextline2.fontColor = UIColor.whiteColor()
                lbTutorialTextline3.fontColor = UIColor.whiteColor()
                lbTutorialTextline1.text = "Avoid or shoot the"
                lbTutorialTextline2.text = "obstacles in your way."
                lbTutorialTextline3.text = "Have fun :)"
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
        if blSoundEffectsEnabled == true {
            apClick.volume = flSoundsVolume
            apClick.prepareToPlay()
            apClick.play()
        }
    }
}

