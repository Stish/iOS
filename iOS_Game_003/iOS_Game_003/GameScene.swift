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
var strVersion = "ver 0.22"
var blGameTest = false
// --- Game positions ---
var flScreenWidth: CGFloat!
var flScreenHeight: CGFloat!
var flShipPosX: CGFloat!
var flShipPosY: CGFloat!
// --- game attributes ---
var iGameScore = 0
var blGameOver = false
// --- game speed ---
let flMeteroiteSpeedInit = Double(2.5)
let iMeteroiteSpawnTimeInit = 15
var flMeteroiteSpeed: Double!
var iMeteroiteSpawnTime: Int!
let iSpeedUpateCycleTimeSec = 15
let iLaserShootInterval = 4
// --- game objects ---
let iMeteroiteSkinCnt = 6
var flMeteroiteSizeMax = CGFloat(120)
var flMeteroiteSizeMin = CGFloat(50)
var flShipSizeWidth = CGFloat(70)
var flShipSizeHeight = CGFloat(62)
// --- game sounds ---
var blSoundEffectsEnabled = true
var blMusicEnabled = true
var flSoundsVolume = Float(0.0)
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

var aExplosion_01 = Array<SKTexture>()

enum enBodyType: UInt32 {
    case ship = 1
    case laser = 2
    case meteroite = 4
}
// Debug
var debug_LaserCnt = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    var apBackgroundMusic: AVAudioPlayer!
    var snInterfaceLeft: SKSpriteNode!
    var snInterfaceRight: SKSpriteNode!
    var selectedNodes = [UITouch:SKSpriteNode]()
    var aSnLaser01 = Array<TLLaser>()
    var aSnMeteroite = Array<TLMeteroite>()
    var iTimeSec: Int!
    var iGameTimeSec: Int!
    var iTime100ms: Int!
    var iTime10ms: Int!
    var iLaserShootingPause: Int!
    var iGameRestartCnt: Int!
////////
    var defaults = NSUserDefaults()
    var highscore = NSUserDefaults().integerForKey("highscore")
    
    //if(Score>highscore)
    //{
    //    defaults.setInteger(Score, forKey: "highscore")
    //}
    var highscoreshow = NSUserDefaults().integerForKey("highscore")
/////////
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
        
//        for family: String in UIFont.familyNames()
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNamesForFamilyName(family)
//            {
//                print("== \(names)")
//            }
//        }
        // Game settings
        flMeteroiteSizeMax = CGFloat(120) * (self.frame.height/375.0)
        flMeteroiteSizeMin = CGFloat(50) * (self.frame.height/375.0)
        flShipSizeWidth = CGFloat(70) * (self.frame.width/667.0)
        flShipSizeHeight = CGFloat(62) * (self.frame.height/375.0)
        //
        flMeteroiteSpeed = flMeteroiteSpeedInit
        iMeteroiteSpawnTime = iMeteroiteSpawnTimeInit
        
        iGameTimeSec = 0
        iTimeSec = 0
        iTime100ms = 0
        iTime10ms = 0
        iLaserShootingPause = 0
        iGameRestartCnt = 0
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
        //snShip.position = CGPoint(x: 120*(flScreenWidth/667.0), y: (view.frame.height/2) - 50*(flScreenHeight/375.0))
        snShip.position = CGPoint(x: 120.0 * (self.frame.width/667.0) , y: (view.frame.height/2) - (50 * (self.frame.height/375.0)))
        flShipPosX = snShip.position.x
        flShipPosY = snShip.position.y
        addChild(snShip)
        
        //myLabel = SKLabelNode(fontNamed:"KarmaticArcade")
        myLabel = SKLabelNode(fontNamed: fnGameFont?.fontName)
        myLabel.text = "TOUCH TO START"
        myLabel.fontSize = 40 * (self.frame.width/667.0)
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - (myLabel.frame.size.height/2))
        myLabel.fontColor = UIColor.whiteColor()
        self.addChild(myLabel)
        
        // --- Interface ---
        //lbGameScore = SKLabelNode(fontNamed:"Menlo")
        lbGameScore = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbGameScore.text = "0"
        lbGameScore.fontSize = 22 * (self.frame.width/667.0)
        lbGameScore.position = CGPoint(x: CGRectGetMidX(self.frame) + (216  * (self.frame.width/667.0)), y: 14 * (self.frame.height/375.0))
        lbGameScore.fontColor = UIColor.orangeColor()
        lbGameScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        lbGameScore.zPosition = 1.0
        self.addChild(lbGameScore)
        
        let snHud = SKSpriteNode(texture: SKTexture(imageNamed: "Media/hud_002.png"), color: UIColor.clearColor(), size: CGSizeMake(470 * (self.frame.width/667.0), 60 * (self.frame.height/375.0)))
        snHud.anchorPoint = CGPointMake(0.5, 0)
        snHud.position = CGPoint(x: CGRectGetMidX(self.frame), y: 3 * (self.frame.height/375.0))
        snHud.zPosition = 1.0
        snHud.alpha = 0.75
        addChild(snHud)
        
        lbGameTime = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbGameTime.text = "0"
        lbGameTime.fontSize = 20 * (self.frame.width/667.0)
        lbGameTime.position = CGPoint(x: CGRectGetMidX(self.frame), y: 24 * (self.frame.height/375.0))
        lbGameTime.fontColor = UIColor(red: 102/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        lbGameTime.zPosition = 1.0
        self.addChild(lbGameTime)

        print("hhScore reported: \(highscoreshow)")
        print("flScreenWidth: " + String(flScreenWidth))
        print("flScreenHeight: " + String(flScreenHeight))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
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
                        print("Lasers: " + String(aSnLaser01.count))
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
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        flShipPosX = snShip.position.x
        flShipPosY = snShip.position.y
        // --- every 10ms ---
        if iTime10ms != Int(currentTime * 10) {
            iTime10ms = Int(currentTime * 10)
            if blLaserFired == true {
                print(iLaserShootingPause)
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
            if (iTime100ms % iMeteroiteSpawnTime == 0) && (blGameOver == false) && (blGameStarted == true) {
                //print(iTimeSec) // #debug
                // flMeteroiteSizeMax
                let flMetSize = CGFloat(arc4random_uniform(UInt32(flMeteroiteSizeMax - flMeteroiteSizeMin)) + 1 + UInt32(flMeteroiteSizeMin))
                let flRotSpeed = CGFloat(arc4random_uniform(5) + 1 + 5)
                var iRotDirec = Int(arc4random_uniform(2))
                if iRotDirec == 0 {
                    iRotDirec = -1
                }
                print(flMetSize) // #debug
                print(flRotSpeed) // #debug
                print(iRotDirec) // #debug
                if aSnMeteroite.count == 0
                {
                    aSnMeteroite.append(TLMeteroite(size: CGSizeMake(flMetSize, flMetSize), rotSpeed: flRotSpeed, rotDirec: iRotDirec))
                    aSnMeteroite[0].blActive = false
                }
                allElements: for i in 0 ..< aSnMeteroite.count {
                    if aSnMeteroite[i].blActive == false {
                        aSnMeteroite[i] = TLMeteroite(size: CGSizeMake(flMetSize, flMetSize), rotSpeed: flRotSpeed, rotDirec: iRotDirec)
                        aSnMeteroite[i].blActive = true
                        addChild(aSnMeteroite[i])
                        aSnMeteroite[i].fctMoveLeft()
                        break allElements
                    }
                    if i == (aSnMeteroite.count - 1) {
                        aSnMeteroite.append(TLMeteroite(size: CGSizeMake(flMetSize, flMetSize), rotSpeed: flRotSpeed, rotDirec: iRotDirec))
                        aSnMeteroite[i+1].blActive = true
                        addChild(aSnMeteroite[i+1])
                        aSnMeteroite[i+1].fctMoveLeft()
                        break allElements
                    }
                }
                print("Mets: " + String(aSnMeteroite.count)) // #debug
                //print(iTime100ms) // #debug
            }
            // --- every 1s
            if (iTime100ms % 10 == 0) && (blGameOver == false) && (blGameStarted == true) {
                iGameTimeSec = iGameTimeSec + 1
                lbGameTime.text = String(iGameTimeSec)
                if iGameTimeSec % iSpeedUpateCycleTimeSec == 0 {
                    if flMeteroiteSpeed > 0.1 {
                        flMeteroiteSpeed = flMeteroiteSpeed - 0.1
                    }
                    if iMeteroiteSpawnTime > 1 {
                        iMeteroiteSpawnTime = iMeteroiteSpawnTime - 1
                    }
                }
                //print("GameScene")
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
        print(debug_LaserCnt)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if blGameOver == false {
            switch(contactMask) {
            case enBodyType.laser.rawValue | enBodyType.meteroite.rawValue:
                let secondNode = contact.bodyB.node
                let firstNode = contact.bodyA.node
                for i in 0 ..< aSnMeteroite.count {
                    if (secondNode == aSnMeteroite[i] || firstNode == aSnMeteroite[i]) && (aSnMeteroite[i].blDestroyed == false) {
                        aSnMeteroite[i].iHealth -= 100
                        if aSnMeteroite[i].iHealth <= 0 {
                            aSnMeteroite[i].physicsBody?.categoryBitMask = 0
                            aSnMeteroite[i].physicsBody?.contactTestBitMask = 0
                            aSnMeteroite[i].fctExplode()
                        } else {
                            // ToDo
                            aSnMeteroite[i].fctHit()
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
            case (enBodyType.ship.rawValue | enBodyType.meteroite.rawValue):
                if blGameTest == false {
                    blGameOver = true
                    iGameRestartCnt = 0
                    let secondNode = contact.bodyB.node
                    let firstNode = contact.bodyA.node
                    for i in 0 ..< aSnMeteroite.count {
                        if secondNode == aSnMeteroite[i] || firstNode == aSnMeteroite[i] {
                            aSnMeteroite[i].physicsBody?.categoryBitMask = 0
                            aSnMeteroite[i].physicsBody?.contactTestBitMask = 0
                            aSnMeteroite[i].fctExplode()
                        }
                    }
                    //snShip.removeFromParent()
                    self.fctGameOver()
                    snShip.physicsBody?.categoryBitMask = 0
                    snShip.fctExplode()
                }
            case (enBodyType.meteroite.rawValue):
                let secondNode = contact.bodyB.node
                let firstNode = contact.bodyA.node
                for i in 0 ..< aSnMeteroite.count {
                    if (secondNode == aSnMeteroite[i] || firstNode == aSnMeteroite[i]) && (aSnMeteroite[i].blDestroyed == false) {
                        aSnMeteroite[i].physicsBody?.categoryBitMask = 0
                        aSnMeteroite[i].physicsBody?.contactTestBitMask = 0
                        aSnMeteroite[i].fctExplode()
                    }
                }
            default:
                ()
            }
        }
    }
    
    func fctGameOver() {
        // highscore
        if (iGameScore > highscore)
        {
            defaults.setInteger(iGameScore, forKey: "highscore")
        }
        
        iGameRestartCnt = 0
        lbGameOver = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbGameOver.text = "GAME OVER"
        lbGameOver.fontSize = 70 * (self.frame.width/667.0)
        lbGameOver.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - (lbGameOver.frame.size.height/2))
        lbGameOver.fontColor = UIColor.whiteColor()
        self.addChild(lbGameOver)
        
        for i in 0 ..< aSnMeteroite.count {
            aSnMeteroite[i].physicsBody?.categoryBitMask = 0
            aSnMeteroite[i].blActive = false
            aSnMeteroite[i].removeFromParent()
        }
        aSnMeteroite.removeAll()
        for i in 0 ..< aSnLaser01.count {
            aSnLaser01[i].physicsBody?.categoryBitMask = 0
            aSnLaser01[i].blActive = false
            aSnLaser01[i].removeFromParent()
        }
        aSnLaser01.removeAll()
        //print("MetArrayCount: " + String(aSnMeteroite.count))
    }
    
    func fctNewGame() {
        flMeteroiteSpeed = flMeteroiteSpeedInit
        iMeteroiteSpawnTime = iMeteroiteSpawnTimeInit
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
        
        //snShip = TLShip(size: CGSizeMake(flShipSizeWidth, flShipSizeHeight))
        //snShip.position = CGPoint(x: 120, y: (view!.frame.height/2) - 50)
        //flShipPosX = snShip.position.x
        //flShipPosY = snShip.position.y
        //addChild(snShip)
    }
}
