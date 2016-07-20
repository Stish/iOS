//
//  GameScene.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 15.12.15.
//  Copyright (c) 2015 Alexander Wegner. All rights reserved.
//

import SpriteKit
import AVFoundation

// Debugging
var strVersion = "ver 0.28"
var blGameTest = false
// --- Game positions ---
var flScreenWidth: CGFloat!
var flScreenHeight: CGFloat!
var flShipPosX: CGFloat!
var flShipPosY: CGFloat!
// --- game attributes ---
var strPlayerName = "Player"
var blScoreSwitchChecked = true
var aHighscoresScore = Array<TLHighscoreMember>()
var aHighscoresTime = Array<TLHighscoreMember>()
var aSkHighscoresColumns = 4
var aSkHighscoresRows = 5
var iGameScore = 0
var blGameOver = false
var blBombFired: Bool!
// --- game speed ---
let flmeteoriteSpeedInit = Double(2.5)
let imeteoriteSpawnTimeInit = 15
var flmeteoriteSpeed: Double!
var imeteoriteSpawnTime: Int!
let iSpeedUpateCycleTimeSec = 15
let iLaserShootInterval = 4
// --- game objects ---
let imeteoriteSkinCnt = 6
var flmeteoriteSizeMax = CGFloat(120)
var flmeteoriteSizeMin = CGFloat(50)
var flShipSizeWidth = CGFloat(70)
var flShipSizeHeight = CGFloat(62)
// --- game sounds ---
var blSoundEffectsEnabled = true
var blMusicEnabled = true
var flSoundsVolume = Float(0.5)
var flMusicVolume = Float(0.5)

var myLabel: SKLabelNode!
var lbGameScore: SKLabelNode!
var lbGameOver: SKLabelNode!
var lbGameTime: SKLabelNode!
var lbLifes: SKLabelNode!
var snBackground: TLBackground!
var snShip: TLShip!
var blGameStarted = false
var blLaserFired = false

// --- game fonts ---
//let fnGameFont = UIFont(name: "HomespunTTBRK", size: 10)
//let fnGameFont = UIFont(name: "KarmaticArcade", size: 10)
//let fnGameFont = UIFont(name: "Menlo", size: 10)
//let fnGameFont = UIFont(name: "Masaaki-Regular", size: 10)
let fnGameFont = UIFont(name: "OrigamiMommy", size: 10)
let fnGameTextFont = UIFont(name: "Minecraft", size: 10)

var aExplosion_01 = Array<SKTexture>()

enum enBodyType: UInt32 {
    case ship = 1
    case laser = 2
    case meteorite = 4
    case powerup = 8
    case bomb = 16
    case bombExplosion = 32
}
// Debug
var debug_LaserCnt = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    var apBackgroundMusic: AVAudioPlayer!
    var snInterfaceLeft: SKSpriteNode!
    var snInterfaceRight: SKSpriteNode!
    var selectedNodes = [UITouch:SKSpriteNode]()
    var aSnLaser01 = Array<TLLaser>()
    var aSnPowerUp = Array<TLPowerUp>()
    var aSnmeteorite = Array<TLMeteorite>()
    var iTimeSec: Int!
    var iGameTimeSec: Int!
    var iTime100ms: Int!
    var iTime10ms: Int!
    var iLaserShootingPause: Int!
    var iGameRestartCnt: Int!
    var snShieldBar1: SKSpriteNode!
    var snShieldBar2: SKSpriteNode!
    var snShieldBar3: SKSpriteNode!
    var snShieldBar4: SKSpriteNode!
    var snBomb1: SKSpriteNode!
    var snBomb2: SKSpriteNode!
    var snBomb3: SKSpriteNode!
    var iBombCount: Int!
    var snPowerUpInvFrame: SKSpriteNode!
    var snPowerUpInv: SKSpriteNode!
    var lbPowerUpInv: SKLabelNode!
    var snPause: SKShapeNode!
    var lbPause: SKLabelNode!
    var flTouchMoveDist: CGFloat!
    var snBombFired: TLBomb!

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        // --- collision setup ---
        physicsWorld.contactDelegate = self
        view.showsPhysics = true // #debug
        // --- explosion sprites ---
        //let taExplosion_01 = SKTextureAtlas(named:"explosion.atlas")
        aExplosion_01.removeAll()
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_01_001"))
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_01_002"))
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_01_003"))
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_01_004"))
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_01_005"))
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_01_006"))
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_01_007"))
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_01_008"))
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_01_009"))
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_01_010"))
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_01_011"))
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_01_012"))
        
        // Game settings
        flmeteoriteSizeMax = CGFloat(120) * (self.frame.height/375.0)
        flmeteoriteSizeMin = CGFloat(50) * (self.frame.height/375.0)
        flShipSizeWidth = CGFloat(70) * (self.frame.width/667.0)
        flShipSizeHeight = CGFloat(62) * (self.frame.height/375.0)
        //
        flmeteoriteSpeed = flmeteoriteSpeedInit
        imeteoriteSpawnTime = imeteoriteSpawnTimeInit
        blBombFired = false
        flTouchMoveDist = 1000
        iGameTimeSec = 0
        iTimeSec = 0
        iTime100ms = 0
        iTime10ms = 0
        iLaserShootingPause = 0
        iGameRestartCnt = 0
        iBombCount = 0
        flScreenWidth = view.frame.size.width
        flScreenHeight = view.frame.size.height
        
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        self.anchorPoint = CGPointMake(0, 0)
        
        snBackground = TLBackground(size: CGSizeMake(view.frame.width, view.frame.height))
        self.anchorPoint = CGPointMake(0.0, 0.0)
        //snGameMap.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        snBackground.position = CGPoint(x: 0, y: 0)
        addChild(snBackground)
        
        snShip = TLShip(size: CGSizeMake(flShipSizeWidth, flShipSizeHeight))
        snShip.position = CGPoint(x: 120.0 * (self.frame.width/667.0) , y: (view.frame.height/2) - (50 * (self.frame.height/375.0)))
        flShipPosX = snShip.position.x
        flShipPosY = snShip.position.y
        snShip.iHealth = 500
        addChild(snShip)

        myLabel = SKLabelNode(fontNamed: fnGameFont?.fontName)
        myLabel.text = "TOUCH TO START"
        myLabel.fontSize = 40 * (self.frame.width/667.0)
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - (myLabel.frame.size.height/2))
        myLabel.fontColor = UIColor.whiteColor()
        self.addChild(myLabel)
        
        // --- Interface ---
        // Game score
        lbGameScore = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbGameScore.text = "0"
        lbGameScore.fontSize = 22 * (self.frame.width/667.0)
        lbGameScore.position = CGPoint(x: CGRectGetMidX(self.frame) + (216  * (self.frame.width/667.0)), y: 14 * (self.frame.height/375.0))
        lbGameScore.fontColor = UIColor.orangeColor()
        lbGameScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        lbGameScore.zPosition = 1.0
        self.addChild(lbGameScore)
        // HUD sprites
        let snHud = SKSpriteNode(texture: SKTexture(imageNamed: "Media/hud_003.png"), color: UIColor.clearColor(), size: CGSizeMake(470 * (self.frame.width/667.0), 60 * (self.frame.height/375.0)))
        snHud.anchorPoint = CGPointMake(0.5, 0)
        snHud.position = CGPoint(x: CGRectGetMidX(self.frame), y: 3 * (self.frame.height/375.0))
        snHud.zPosition = 1.0
        snHud.alpha = 0.75
        addChild(snHud)
        // Game time
        lbGameTime = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbGameTime.text = "0"
        lbGameTime.fontSize = 20 * (self.frame.width/667.0)
        lbGameTime.position = CGPoint(x: CGRectGetMidX(self.frame), y: 24 * (self.frame.height/375.0))
        lbGameTime.fontColor = UIColor(red: 102/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        lbGameTime.zPosition = 1.0
        self.addChild(lbGameTime)
        // Shields
        // Menu sprite size
        let flShieldSprite1Width = (SKTexture(imageNamed: "Media/shield_point_001.png").size().width) * (self.frame.width/667.0)
        let flShieldSprite1Height = (SKTexture(imageNamed: "Media/shield_point_001.png").size().height) * (self.frame.height/375.0)
        let flShieldSprite2Width = (SKTexture(imageNamed: "Media/shield_point_002.png").size().width) * (self.frame.width/667.0)
        let flShieldSprite2Height = (SKTexture(imageNamed: "Media/shield_point_002.png").size().height) * (self.frame.height/375.0)
        // Shield bar 1
        snShieldBar1 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/shield_point_001.png"), color: UIColor.clearColor(), size: CGSizeMake(flShieldSprite1Width, flShieldSprite1Height))
        snShieldBar1.anchorPoint = CGPointMake(0.0, 0.5)
        snShieldBar1.position = CGPoint(x: CGRectGetMidX(self.frame) - (225 * (self.frame.width/667.0)), y: 23 * (self.frame.height/375.0))
        snShieldBar1.zPosition = 1.0
        snShieldBar1.alpha = 1.0
        self.addChild(snShieldBar1)
        // Shield bar 2
        snShieldBar2 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/shield_point_002.png"), color: UIColor.clearColor(), size: CGSizeMake(flShieldSprite2Width, flShieldSprite2Height))
        snShieldBar2.anchorPoint = CGPointMake(0.0, 0.5)
        snShieldBar2.position = CGPoint(x: CGRectGetMidX(self.frame) - (180 * (self.frame.width/667.0)), y: 23 * (self.frame.height/375.0))
        snShieldBar2.zPosition = 1.0
        snShieldBar2.alpha = 1.0
        self.addChild(snShieldBar2)
        // Shield bar 3
        snShieldBar3 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/shield_point_002.png"), color: UIColor.clearColor(), size: CGSizeMake(flShieldSprite2Width, flShieldSprite2Height))
        snShieldBar3.anchorPoint = CGPointMake(0.0, 0.5)
        snShieldBar3.position = CGPoint(x: CGRectGetMidX(self.frame) - (136 * (self.frame.width/667.0)), y: 23 * (self.frame.height/375.0))
        snShieldBar3.zPosition = 1.0
        snShieldBar3.alpha = 1.0
        self.addChild(snShieldBar3)
        // Shield bar 4
        snShieldBar4 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/shield_point_002.png"), color: UIColor.clearColor(), size: CGSizeMake(flShieldSprite2Width, flShieldSprite2Height))
        snShieldBar4.anchorPoint = CGPointMake(0.0, 0.5)
        snShieldBar4.position = CGPoint(x: CGRectGetMidX(self.frame) - (92 * (self.frame.width/667.0)), y: 23 * (self.frame.height/375.0))
        snShieldBar4.zPosition = 1.0
        snShieldBar4.alpha = 1.0
        self.addChild(snShieldBar4)
        fctUpdateShields()
        // Bombs
        let flBombWidth = (SKTexture(imageNamed: "Media/pu_bomb_001_empty.png").size().width) * (self.frame.width/667.0)
        let flBombHeight = (SKTexture(imageNamed: "Media/pu_bomb_001_empty.png").size().height) * (self.frame.height/375.0)
        // Bomb 1
        snBomb1 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/pu_bomb_001_empty.png"), color: UIColor.clearColor(), size: CGSizeMake(flBombWidth, flBombHeight))
        snBomb1.anchorPoint = CGPointMake(0.5, 0.5)
        snBomb1.position = CGPoint(x: CGRectGetMidX(self.frame) - (180 * (self.frame.width/667.0)), y: 60 * (self.frame.height/375.0))
        snBomb1.zPosition = 1.0
        snBomb1.alpha = 1.0
        self.addChild(snBomb1)
        // Bomb 2
        snBomb2 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/pu_bomb_001_empty.png"), color: UIColor.clearColor(), size: CGSizeMake(flBombWidth, flBombHeight))
        snBomb2.anchorPoint = CGPointMake(0.5, 0.5)
        snBomb2.position = CGPoint(x: CGRectGetMidX(self.frame) - (145 * (self.frame.width/667.0)), y: 60 * (self.frame.height/375.0))
        snBomb2.zPosition = 1.0
        snBomb2.alpha = 1.0
        self.addChild(snBomb2)
        // Bomb 3
        snBomb3 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/pu_bomb_001_empty.png"), color: UIColor.clearColor(), size: CGSizeMake(flBombWidth, flBombHeight))
        snBomb3.anchorPoint = CGPointMake(0.5, 0.5)
        snBomb3.position = CGPoint(x: CGRectGetMidX(self.frame) - (110 * (self.frame.width/667.0)), y: 60 * (self.frame.height/375.0))
        snBomb3.zPosition = 1.0
        snBomb3.alpha = 1.0
        self.addChild(snBomb3)
        // "Power up to inventory" frame sprite
        let flOptCheckboxWidth = (SKTexture(imageNamed: "Media/checkbox_checked.png").size().width) * (self.frame.width/667.0)
        let flOptCheckboxHeight = (SKTexture(imageNamed: "Media/checkbox_checked.png").size().height) * (self.frame.height/375.0)
        snPowerUpInvFrame = SKSpriteNode(texture: SKTexture(imageNamed: "Media/checkbox_unchecked.png"), color: UIColor.clearColor(), size: CGSizeMake(flOptCheckboxWidth, flOptCheckboxHeight))
        snPowerUpInvFrame.anchorPoint = CGPointMake(0.5, 0.5)
        snPowerUpInvFrame.position = CGPoint(x: self.frame.width - (flOptCheckboxWidth/2) - (5 * (self.frame.width/667.0)), y: self.frame.height - (flOptCheckboxHeight/2) - (5 * (self.frame.height/375.0)))
        snPowerUpInvFrame.zPosition = 1.0
        snPowerUpInvFrame.alpha = 0.0
        self.addChild(snPowerUpInvFrame)
        // "Power up to inventory" item sprite
        let flPowerUpWidth = (SKTexture(imageNamed: "Media/pu_bomb_001.png").size().width) * (self.frame.width/667.0)
        let flPowerUpHeight = (SKTexture(imageNamed: "Media/pu_bomb_001.png").size().height) * (self.frame.height/375.0)
        snPowerUpInv = SKSpriteNode(texture: SKTexture(imageNamed: "Media/pu_bomb_001.png"), color: UIColor.clearColor(), size: CGSizeMake(flPowerUpWidth, flPowerUpHeight))
        snPowerUpInv.anchorPoint = CGPointMake(0.5, 0.5)
        snPowerUpInv.position = snPowerUpInvFrame.position
        snPowerUpInv.zPosition = 1.0
        snPowerUpInv.alpha = 0.0
        self.addChild(snPowerUpInv)
        // "Power up to inventory" text
        lbPowerUpInv = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lbPowerUpInv.text = "Bombs +1"
        lbPowerUpInv.horizontalAlignmentMode = .Right
        lbPowerUpInv.verticalAlignmentMode = .Center
        lbPowerUpInv.fontSize = 20 * (self.frame.width/667.0)
        lbPowerUpInv.position = snPowerUpInvFrame.position
        lbPowerUpInv.position.x = lbPowerUpInv.position.x - (flOptCheckboxWidth/2) - (5 * (self.frame.width/667.0))
        lbPowerUpInv.fontColor = UIColor.whiteColor()
        lbPowerUpInv.zPosition = 1.0
        lbPowerUpInv.alpha = 0.0
        self.addChild(lbPowerUpInv)
        // Pause screen sprite
        snPause = SKShapeNode(rectOfSize: CGSize(width: self.frame.width, height: self.frame.height))
        snPause.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        snPause.strokeColor = SKColor.blackColor()
        snPause.glowWidth = 0.0
        snPause.lineWidth = 0.0
        snPause.fillColor = SKColor.blackColor()
        snPause.zPosition = -0.1
        snPause.alpha = 0.75
        self.addChild(snPause)
        // Pause screen text
        lbPause = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbPause.text = "PAUSED"
        lbPause.horizontalAlignmentMode = .Center
        lbPause.verticalAlignmentMode = .Center
        lbPause.fontSize = 40 * (self.frame.width/667.0)
        lbPause.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        lbPause.fontColor = UIColor.whiteColor()
        lbPause.zPosition = -0.1
        lbPause.alpha = 1.0
        self.addChild(lbPause)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "applicationWillResignActive:",
            name: UIApplicationWillResignActiveNotification,
            object: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if self.speed > 0.0 {
            if (blGameStarted == false) && (blGameOver == false) {
                self.fctPlayBackgroundMusic()
                myLabel.hidden = true
                blGameStarted = true
                blGameOver = false
                snBackground.fctMoveLeft()
            } else if blGameOver == false {
                for touch:AnyObject in touches {
                    if touch.locationInView(view).x <= (200.0 * (self.frame.height/375.0)) {
                        let deltaY = (view!.frame.height - touch.locationInView(view).y) - snShip.position.y
                        snShip.fctMoveShipByY(deltaY)
                        //print("left")
                    } else {
                        if blLaserFired == false {
                            blLaserFired = true
                            iLaserShootingPause = 0
                            snShip.fctPlayShootingSound()
                            //print("right")
                            self.fctShootLaser01()
                            //print("Lasers: " + String(aSnLaser01.count)) // #debug
                            flTouchMoveDist = touch.locationInView(view).x
                        }
                    }
                }
            }
            if (blGameOver == true) && (iGameRestartCnt >= 7) {
                snShip.removeFromParent()
                //fctNewGame()
                let transition = SKTransition.fadeWithColor(.blackColor(), duration: 0.3)
                
                let nextScene = TLGameMenu(size: self.scene!.size)
                nextScene.scaleMode = .AspectFill
                
                self.scene?.view?.presentScene(nextScene, transition: transition)
                //fctNewGame()
                //self.delete(self)
                fctNewGame()
            }
        } else {
            self.speed = 1.0
            snPause.zPosition = -0.1
            lbPause.zPosition = -0.1
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (blGameOver == false) && (blGameStarted == true) {
            for touch in touches {
                if touch.locationInView(view).x <= (200.0 * (self.frame.height/375.0)) {
                    let deltaY = (view!.frame.height - touch.locationInView(view).y) - snShip.position.y
                    if (deltaY >= (3 * (self.frame.height/375.0)) && deltaY <= (50 * (self.frame.height/375.0))) {
                        snShip.fctStartFlyAnimationLeft()
                        snShip.position.y = snShip.position.y + deltaY
                    } else if (deltaY <= (-3 * (self.frame.height/375.0)) && deltaY >= (-50 * (self.frame.height/375.0))) {
                        snShip.fctStartFlyAnimationRight()
                        snShip.position.y = snShip.position.y + deltaY
                    } else if (deltaY < (3 * (self.frame.height/375.0)) && deltaY > (-3 * (self.frame.height/375.0))) {
                        //snShip.fctStartFlyAnimationFront()
                    }
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (blGameOver == false)  && (blGameStarted == true) {
            snShip.fctStartFlyAnimationFront()
        }
        if (blGameOver == false)  && (blGameStarted == true) {
            for touch in touches {
                if touch.locationInView(view).x >= (200.0 * (self.frame.height/375.0)) {
                    if touch.locationInView(view).x - flTouchMoveDist >= 100 {
                        // Finger moved detected
                        if (blBombFired == false) && (iBombCount > 0) {
                            iBombCount = iBombCount - 1
                            fctUpdateBombs()
                            snShip.fctPlayBombShootingSound()
                            fctShootBomb()
                        }
                    }
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if self.speed > 0.0 {
            /* Called before each frame is rendered */
            flShipPosX = snShip.position.x
            flShipPosY = snShip.position.y
            // --- every 10ms ---
            if iTime10ms != Int(currentTime * 10) {
                iTime10ms = Int(currentTime * 10)
                if blLaserFired == true {
                    //print(iLaserShootingPause) // #debug
                    iLaserShootingPause = iLaserShootingPause + 1
                    if iLaserShootingPause >= iLaserShootInterval {
                        iLaserShootingPause = 0
                        blLaserFired = false
                    }
                }
            }
            // --- every 100ms ---
            if iTime100ms != Int(currentTime * 10) {
                iTime100ms = Int(currentTime * 10)
                if blGameOver == true {
                    iGameRestartCnt = iGameRestartCnt + 1
                }
                if (iTime100ms % imeteoriteSpawnTime == 0) && (blGameOver == false) && (blGameStarted == true) {
                    let flMetSize = CGFloat(arc4random_uniform(UInt32(flmeteoriteSizeMax - flmeteoriteSizeMin)) + 1 + UInt32(flmeteoriteSizeMin))
                    let flRotSpeed = CGFloat(arc4random_uniform(5) + 1 + 5)
                    var iRotDirec = Int(arc4random_uniform(2))
                    if iRotDirec == 0 {
                        iRotDirec = -1
                    }
                    if aSnmeteorite.count == 0
                    {
                        aSnmeteorite.append(TLMeteorite(size: CGSizeMake(flMetSize, flMetSize), rotSpeed: flRotSpeed, rotDirec: iRotDirec))
                        aSnmeteorite[0].blActive = false
                    }
                    allElements: for i in 0 ..< aSnmeteorite.count {
                        if aSnmeteorite[i].blActive == false {
                            aSnmeteorite[i] = TLMeteorite(size: CGSizeMake(flMetSize, flMetSize), rotSpeed: flRotSpeed, rotDirec: iRotDirec)
                            aSnmeteorite[i].blActive = true
                            addChild(aSnmeteorite[i])
                            aSnmeteorite[i].fctMoveLeft()
                            break allElements
                        }
                        if i == (aSnmeteorite.count - 1) {
                            aSnmeteorite.append(TLMeteorite(size: CGSizeMake(flMetSize, flMetSize), rotSpeed: flRotSpeed, rotDirec: iRotDirec))
                            aSnmeteorite[i+1].blActive = true
                            addChild(aSnmeteorite[i+1])
                            aSnmeteorite[i+1].fctMoveLeft()
                            break allElements
                        }
                    }
                }
                // --- every 1s
                if (iTime100ms % 10 == 0) && (blGameOver == false) && (blGameStarted == true) {
                    iGameTimeSec = iGameTimeSec + 1
                    lbGameTime.text = String(iGameTimeSec)
                    if iGameTimeSec % iSpeedUpateCycleTimeSec == 0 {
                        if flmeteoriteSpeed > 0.1 {
                            flmeteoriteSpeed = flmeteoriteSpeed - 0.1
                        }
                        if imeteoriteSpawnTime > 1 {
                            imeteoriteSpawnTime = imeteoriteSpawnTime - 1
                        }
                    }
                }
            }
        }
    }
    
    func fctPlayBackgroundMusic() {
        if blMusicEnabled == true {
            let path = NSBundle.mainBundle().pathForResource("Media/sounds/music_001", ofType:"mp3")
            let fileURL = NSURL(fileURLWithPath: path!)
            do {
                try apBackgroundMusic = AVAudioPlayer(contentsOfURL: fileURL, fileTypeHint: nil)
            } catch {
                print("Could not create audio player: \(error)")
                return
            }
            apBackgroundMusic.numberOfLoops = -1
            apBackgroundMusic.volume = flMusicVolume
            apBackgroundMusic.prepareToPlay()
            apBackgroundMusic.play()
        }
    }
    
    func fctShootLaser01() {
        //snLaser.removeAllActions()
        if aSnLaser01.count == 0
        {
            aSnLaser01.append(TLLaser(size: CGSizeMake(60 * (self.frame.width/667.0), 5 * (self.frame.height/375.0))))
            aSnLaser01[0].blActive = false
        }
        allElements: for i in 0 ..< aSnLaser01.count {
            if aSnLaser01[i].blActive == false {
                aSnLaser01[i] = TLLaser(size: CGSizeMake(60 * (self.frame.width/667.0), 5 * (self.frame.height/375.0)))
                aSnLaser01[i].blActive = true
                addChild(aSnLaser01[i])
                aSnLaser01[i].fctMoveRight()
                break allElements
            }
            if i == (aSnLaser01.count - 1) {
                aSnLaser01.append(TLLaser(size: CGSizeMake(60 * (self.frame.width/667.0), 5 * (self.frame.height/375.0))))
                aSnLaser01[i+1].blActive = true
                addChild(aSnLaser01[i+1])
                aSnLaser01[i+1].fctMoveRight()
                break allElements
            }
        }
        debug_LaserCnt = aSnLaser01.count
        //print(debug_LaserCnt) // #debug
    }
    
    func fctShootBomb() {
        blBombFired = true
        snBombFired = TLBomb(size: CGSizeMake(25 * (self.frame.width/667.0), 25 * (self.frame.height/375.0)))
        self.addChild(snBombFired)
        print("Bomb fired") // #debug
        snBombFired.fctMoveRight()
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if blGameOver == false {
            switch(contactMask) {
            // Laser hits meteorite
            case enBodyType.laser.rawValue | enBodyType.meteorite.rawValue:
                let secondNode = contact.bodyB.node
                let firstNode = contact.bodyA.node
                for i in 0 ..< aSnmeteorite.count {
                    if (secondNode == aSnmeteorite[i] || firstNode == aSnmeteorite[i]) && (aSnmeteorite[i].blDestroyed == false) {
                        aSnmeteorite[i].iHealth -= 100
                        if aSnmeteorite[i].iHealth <= 0 {
                            if aSnmeteorite[i].iPowerUp > 0 {
                                if aSnPowerUp.count == 0 {
                                    aSnPowerUp.append(TLPowerUp(size: CGSizeMake(25 * (self.frame.width/667.0), 25 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp))
                                    aSnPowerUp[0].blActive = false
                                }
                                allElements: for j in 0 ..< aSnPowerUp.count {
                                    if aSnPowerUp[j].blActive == false {
                                        aSnPowerUp[j] = TLPowerUp(size: CGSizeMake(25 * (self.frame.width/667.0), 25 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp)
                                        aSnPowerUp[j].blActive = true
                                        addChild(aSnPowerUp[j])
                                        aSnPowerUp[j].fctMoveLeft()
                                        break allElements
                                    }
                                    if j == (aSnPowerUp.count - 1) {
                                        aSnPowerUp.append(TLPowerUp(size: CGSizeMake(25 * (self.frame.width/667.0), 25 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp))
                                        aSnPowerUp[j+1].blActive = true
                                        addChild(aSnPowerUp[j+1])
                                        aSnPowerUp[j+1].fctMoveLeft()
                                        break allElements
                                    }
                                }
                            }
                            aSnmeteorite[i].fctExplode()
                        } else {
                            // ToDo
                            aSnmeteorite[i].fctHit()
                        }
                    }
                }
                for i in 0 ..< aSnLaser01.count {
                    if (secondNode == aSnLaser01[i] || firstNode == aSnLaser01[i]) && (aSnLaser01[i].blDestroyed == false)  {
                        aSnLaser01[i].physicsBody?.categoryBitMask = 0
                        aSnLaser01[i].physicsBody?.contactTestBitMask = 0
                        aSnLaser01[i].fctExplode()
                    }
                }
            // Ship hits meteorite
            case (enBodyType.ship.rawValue | enBodyType.meteorite.rawValue):
                if blGameTest == false {
                    let secondNode = contact.bodyB.node
                    let firstNode = contact.bodyA.node
                    for i in 0 ..< aSnmeteorite.count {
                        if secondNode == aSnmeteorite[i] || firstNode == aSnmeteorite[i] {
                            if aSnmeteorite[i].blDestroyed == false {
                                if snShip.iHealth > 100 {
                                    fctFadeInOutSKSpriteNode(snShip.snShipShield, time: 0.5, alpha: 0.75, pause: 0.1)
                                }
                                snShip.iHealth = snShip.iHealth - aSnmeteorite[i].iHealth
                                aSnmeteorite[i].iHealth = 0
                                aSnmeteorite[i].physicsBody?.categoryBitMask = 0
                                aSnmeteorite[i].physicsBody?.contactTestBitMask = 0
                                fctUpdateShields()
                                if aSnmeteorite[i].iPowerUp == 1 {
                                    if iBombCount < 3 {
                                        self.iBombCount = iBombCount + 1
                                        fctUpdateBombs()
                                        lbPowerUpInv.text = "Bombs +1"
                                    } else {
                                        lbPowerUpInv.text = "Bomb inventory full"
                                    }
                                    snPowerUpInv.texture = SKTexture(imageNamed: "Media/pu_bomb_001.png")
                                    fctFadeInOutSKSpriteNode(snPowerUpInvFrame, time: 1, alpha: 0.75, pause: 2)
                                    fctFadeInOutSKSpriteNode(snPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                    fctFadeInOutSKLabelNode(lbPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                }
                                if aSnmeteorite[i].iPowerUp == 2 {
                                    if snShip.iHealth < 500 {
                                        snShip.iHealth = snShip.iHealth + 100
                                        fctUpdateShields()
                                        lbPowerUpInv.text = "Shields +25%"
                                    } else {
                                        lbPowerUpInv.text = "Shields at 100%"
                                    }
                                    snPowerUpInv.texture = SKTexture(imageNamed: "Media/pu_shield_001.png")
                                    fctFadeInOutSKSpriteNode(snPowerUpInvFrame, time: 1, alpha: 0.75, pause: 2)
                                    fctFadeInOutSKSpriteNode(snPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                    fctFadeInOutSKLabelNode(lbPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                }
                                aSnmeteorite[i].fctExplode()
                            }
                        }
                    }
                    //print("ship health: " + String(snShip.iHealth)) // #debug
                    //snShip.removeFromParent()
                    if snShip.iHealth <= 0 {
                        self.fctGameOver()
                        snShip.physicsBody?.categoryBitMask = 0
                        snShip.fctExplode()
                        blGameOver = true
                        iGameRestartCnt = 0
                    }
                }
            // Ship hits powerup
            case (enBodyType.ship.rawValue | enBodyType.powerup.rawValue):
                let secondNode = contact.bodyB.node
                let firstNode = contact.bodyA.node
                for i in 0 ..< aSnPowerUp.count {
                    if secondNode == aSnPowerUp[i] || firstNode == aSnPowerUp[i] {
                        if aSnPowerUp[i].blDestroyed == false {
                            aSnPowerUp[i].physicsBody?.categoryBitMask = 0
                            aSnPowerUp[i].physicsBody?.contactTestBitMask = 0
                            if aSnPowerUp[i].iPowerUp == 1 {
                                if iBombCount < 3 {
                                    self.iBombCount = iBombCount + 1
                                    fctUpdateBombs()
                                    lbPowerUpInv.text = "Bombs +1"
                                } else {
                                    lbPowerUpInv.text = "Bomb inventory full"
                                }
                                snPowerUpInv.texture = SKTexture(imageNamed: "Media/pu_bomb_001.png")
                                fctFadeInOutSKSpriteNode(snPowerUpInvFrame, time: 1, alpha: 0.75, pause: 2)
                                fctFadeInOutSKSpriteNode(snPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                fctFadeInOutSKLabelNode(lbPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                            }
                            if aSnPowerUp[i].iPowerUp == 2 {
                                if snShip.iHealth < 500 {
                                    snShip.iHealth = snShip.iHealth + 100
                                    fctUpdateShields()
                                    lbPowerUpInv.text = "Shields +25%"
                                } else {
                                    lbPowerUpInv.text = "Shields at 100%"
                                }
                                snPowerUpInv.texture = SKTexture(imageNamed: "Media/pu_shield_001.png")
                                fctFadeInOutSKSpriteNode(snPowerUpInvFrame, time: 1, alpha: 0.75, pause: 2)
                                fctFadeInOutSKSpriteNode(snPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                fctFadeInOutSKLabelNode(lbPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                            }
                            aSnPowerUp[i].fctExplode()
                        }
                    }
                }
            // meteorite hits meteorite
            case (enBodyType.meteorite.rawValue):
                let secondNode = contact.bodyB.node
                let firstNode = contact.bodyA.node
                for i in 0 ..< aSnmeteorite.count {
                    if (secondNode == aSnmeteorite[i] || firstNode == aSnmeteorite[i]) && (aSnmeteorite[i].blDestroyed == false) {
                        aSnmeteorite[i].physicsBody?.categoryBitMask = 0
                        aSnmeteorite[i].physicsBody?.contactTestBitMask = 0
                        aSnmeteorite[i].fctExplode()
                    }
                }
            // Bomb hits meteorite
            case enBodyType.bomb.rawValue | enBodyType.meteorite.rawValue:
                let secondNode = contact.bodyB.node
                let firstNode = contact.bodyA.node
                for i in 0 ..< aSnmeteorite.count {
                    if (secondNode == aSnmeteorite[i] || firstNode == aSnmeteorite[i]) && (aSnmeteorite[i].blDestroyed == false) {
                        aSnmeteorite[i].iHealth = 0
                        if aSnmeteorite[i].iHealth <= 0 {
                            if aSnmeteorite[i].iPowerUp > 0 {
                                if aSnPowerUp.count == 0 {
                                    aSnPowerUp.append(TLPowerUp(size: CGSizeMake(25 * (self.frame.width/667.0), 25 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp))
                                    aSnPowerUp[0].blActive = false
                                }
                                allElements: for j in 0 ..< aSnPowerUp.count {
                                    if aSnPowerUp[j].blActive == false {
                                        aSnPowerUp[j] = TLPowerUp(size: CGSizeMake(25 * (self.frame.width/667.0), 25 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp)
                                        aSnPowerUp[j].blActive = true
                                        addChild(aSnPowerUp[j])
                                        aSnPowerUp[j].fctMoveLeft()
                                        break allElements
                                    }
                                    if j == (aSnPowerUp.count - 1) {
                                        aSnPowerUp.append(TLPowerUp(size: CGSizeMake(25 * (self.frame.width/667.0), 25 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp))
                                        aSnPowerUp[j+1].blActive = true
                                        addChild(aSnPowerUp[j+1])
                                        aSnPowerUp[j+1].fctMoveLeft()
                                        break allElements
                                    }
                                }
                            }
                            aSnmeteorite[i].fctExplode()
                            snBombFired.fctExplode()
                            snBombFired.blExploded = true
                        } else {
                            // ToDo
                            aSnmeteorite[i].fctHit()
                        }
                    }
                }
            // Bomb explosion hits meteorite
            case enBodyType.bombExplosion.rawValue | enBodyType.meteorite.rawValue:
                if snBombFired.blExploded == true {
                    let secondNode = contact.bodyB.node
                    let firstNode = contact.bodyA.node
                    for i in 0 ..< aSnmeteorite.count {
                        if (secondNode == aSnmeteorite[i] || firstNode == aSnmeteorite[i]) && (aSnmeteorite[i].blDestroyed == false){
                            aSnmeteorite[i].iHealth = 0
                            if aSnmeteorite[i].iHealth <= 0 {
                                if aSnmeteorite[i].iPowerUp > 0 {
                                    if aSnPowerUp.count == 0 {
                                        aSnPowerUp.append(TLPowerUp(size: CGSizeMake(25 * (self.frame.width/667.0), 25 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp))
                                        aSnPowerUp[0].blActive = false
                                    }
                                    allElements: for j in 0 ..< aSnPowerUp.count {
                                        if aSnPowerUp[j].blActive == false {
                                            aSnPowerUp[j] = TLPowerUp(size: CGSizeMake(25 * (self.frame.width/667.0), 25 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp)
                                            aSnPowerUp[j].blActive = true
                                            addChild(aSnPowerUp[j])
                                            aSnPowerUp[j].fctMoveLeft()
                                            break allElements
                                        }
                                        if j == (aSnPowerUp.count - 1) {
                                            aSnPowerUp.append(TLPowerUp(size: CGSizeMake(25 * (self.frame.width/667.0), 25 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp))
                                            aSnPowerUp[j+1].blActive = true
                                            addChild(aSnPowerUp[j+1])
                                            aSnPowerUp[j+1].fctMoveLeft()
                                            break allElements
                                        }
                                    }
                                }
                                aSnmeteorite[i].fctExplode()
                                snBombFired.fctExplode()
                                snBombFired.blExploded = true
                            } else {
                                // ToDo
                                aSnmeteorite[i].fctHit()
                            }
                        }
                    }
                }
            // Bomb explosion hits ship
            case enBodyType.bombExplosion.rawValue | enBodyType.ship.rawValue:
                if snBombFired.blExploded == true {
                    let secondNode = contact.bodyB.node
                    let firstNode = contact.bodyA.node
                    if (secondNode == snShip || firstNode == snShip){
                        if snShip.iHealth > 100 {
                            fctFadeInOutSKSpriteNode(snShip.snShipShield, time: 0.5, alpha: 0.75, pause: 0.1)
                        }
                        snShip.iHealth = snShip.iHealth - 100
                        if snShip.iHealth <= 0 {
                            self.fctGameOver()
                            snShip.physicsBody?.categoryBitMask = 0
                            snShip.fctExplode()
                            blGameOver = true
                            iGameRestartCnt = 0
                        }
                    }
                }
            default:
                ()
            }
        }
    }
    
//    func didEndContact(contact: SKPhysicsContact) {
//        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
//        if blGameOver == false {
//            switch(contactMask) {
//                // Laser hits meteorite
//            // Bomb explosion hits meteorite
//            case enBodyType.bombExplosion.rawValue | enBodyType.meteorite.rawValue:
//                let secondNode = contact.bodyB.node
//                let firstNode = contact.bodyA.node
//                for i in 0 ..< aSnmeteorite.count {
//                    if (secondNode == aSnmeteorite[i] || firstNode == aSnmeteorite[i]) && (aSnmeteorite[i].blDestroyed == false) && (snBombFired.blExploded == false){
//                        aSnmeteorite[i].blInBombRadius = false
//                    }
//                }
//            default:
//                ()
//            }
//        }
//    }
    
    func fctGameOver() {
        iGameRestartCnt = 0
        lbGameOver = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbGameOver.text = "GAME OVER"
        lbGameOver.fontSize = 70 * (self.frame.width/667.0)
        lbGameOver.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - (lbGameOver.frame.size.height/2))
        lbGameOver.fontColor = UIColor.whiteColor()
        self.addChild(lbGameOver)
        
        for i in 0 ..< aSnmeteorite.count {
            aSnmeteorite[i].physicsBody?.categoryBitMask = 0
            aSnmeteorite[i].blActive = false
            aSnmeteorite[i].removeFromParent()
        }
        aSnmeteorite.removeAll()
        for i in 0 ..< aSnLaser01.count {
            aSnLaser01[i].physicsBody?.categoryBitMask = 0
            aSnLaser01[i].blActive = false
            aSnLaser01[i].removeFromParent()
        }
        aSnLaser01.removeAll()
        for i in 0 ..< aSnPowerUp.count {
            aSnPowerUp[i].physicsBody?.categoryBitMask = 0
            aSnPowerUp[i].blActive = false
            aSnPowerUp[i].removeFromParent()
        }
        aSnPowerUp.removeAll()
    }
    
    func fctNewGame() {
        blBombFired = false
        flTouchMoveDist = 1000
        flmeteoriteSpeed = flmeteoriteSpeedInit
        imeteoriteSpawnTime = imeteoriteSpawnTimeInit
        iGameTimeSec = 0
        lbGameTime.text = "0s"
        blGameOver = false
        lbGameOver.removeFromParent()
        snBackground.removeAllActions()
        snBackground.fctResetPos()
        //sleep(2)
        //myLabel.hidden = false
        blGameStarted = false
        iGameScore = 0
        lbGameScore.text = "0"
        snShip.iHealth = 500
        iBombCount = 0
        fctUpdateShields()
    }
    
    func fctUpdateShields() {
        if snShip.iHealth > 100 {
            snShieldBar1.alpha = 1.0
        } else {
            snShieldBar1.alpha = 0.0
        }
        if snShip.iHealth > 200 {
            snShieldBar2.alpha = 1.0
        } else {
            snShieldBar2.alpha = 0.0
        }
        if snShip.iHealth > 300 {
            snShieldBar3.alpha = 1.0
        } else {
            snShieldBar3.alpha = 0.0
        }
        if snShip.iHealth > 400 {
            snShieldBar4.alpha = 1.0
        } else {
            snShieldBar4.alpha = 0.0
        }
    }
    
    func fctUpdateBombs() {
        if iBombCount > 0 {
            snBomb1.texture = SKTexture(imageNamed: "Media/pu_bomb_001.png")
        } else {
            snBomb1.texture = SKTexture(imageNamed: "Media/pu_bomb_001_empty.png")
        }
        if iBombCount > 1 {
            snBomb2.texture = SKTexture(imageNamed: "Media/pu_bomb_001.png")
        } else {
            snBomb2.texture = SKTexture(imageNamed: "Media/pu_bomb_001_empty.png")
        }
        if iBombCount > 2 {
            snBomb3.texture = SKTexture(imageNamed: "Media/pu_bomb_001.png")
        } else {
            snBomb3.texture = SKTexture(imageNamed: "Media/pu_bomb_001_empty.png")
        }
    }
    
    func applicationWillResignActive(notification: NSNotification) {
        //print("I'm out of focus!")
        snPause.zPosition = 1.1
        lbPause.zPosition = 1.1
        self.speed = 0.0
        //self.view!.paused = true
        print("Paused!")
        
    }
    
    deinit {
        
        // code here...
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func fctFadeInOutSKSpriteNode (node: SKSpriteNode, time: NSTimeInterval, alpha: CGFloat, pause: NSTimeInterval) {
        node.alpha = 0.0
        let deltaAlpha = alpha/5
        let deltaTime = time/10
        node.removeAllActions()
        node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
            node.alpha = node.alpha + deltaAlpha
            node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                node.alpha = node.alpha + deltaAlpha
                node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                    node.alpha = node.alpha + deltaAlpha
                    node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                        node.alpha = node.alpha + deltaAlpha
                        node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                            node.alpha = node.alpha + deltaAlpha
                            node.runAction(SKAction.rotateToAngle(0, duration: pause), completion: {() in
                                // Pause
                                node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                    // Fade out
                                    node.alpha = node.alpha - deltaAlpha
                                    node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                        node.alpha = node.alpha - deltaAlpha
                                        node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                            node.alpha = node.alpha - deltaAlpha
                                            node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                                node.alpha = node.alpha - deltaAlpha
                                                node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                                    node.alpha = node.alpha - deltaAlpha
                                                    node.removeAllActions()
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        })
    }
    
    func fctFadeInOutSKLabelNode (node: SKLabelNode, time: NSTimeInterval, alpha: CGFloat, pause: NSTimeInterval) {
        node.alpha = 0.0
        let deltaAlpha = alpha/5
        let deltaTime = time/10
        node.removeAllActions()
        node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
            node.alpha = node.alpha + deltaAlpha
            node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                node.alpha = node.alpha + deltaAlpha
                node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                    node.alpha = node.alpha + deltaAlpha
                    node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                        node.alpha = node.alpha + deltaAlpha
                        node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                            node.alpha = node.alpha + deltaAlpha
                            node.runAction(SKAction.rotateToAngle(0, duration: pause), completion: {() in
                                // Pause
                                node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                    // Fade out
                                    node.alpha = node.alpha - deltaAlpha
                                    node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                        node.alpha = node.alpha - deltaAlpha
                                        node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                            node.alpha = node.alpha - deltaAlpha
                                            node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                                node.alpha = node.alpha - deltaAlpha
                                                node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                                    node.alpha = node.alpha - deltaAlpha
                                                    node.removeAllActions()
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        })
    }

}
