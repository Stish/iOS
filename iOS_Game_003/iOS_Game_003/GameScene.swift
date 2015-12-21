//
//  GameScene.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 15.12.15.
//  Copyright (c) 2015 Alexander Wegner. All rights reserved.
//

import SpriteKit
import AVFoundation

// Game positions
var flScreenWidth: CGFloat!
var flScreenHeight: CGFloat!
var flShipPosX: CGFloat!
var flShipPosY: CGFloat!
// --- game attributes ---
var iGameScore = 0
var blGameOver = false
// --- game speed ---
let flMeteroiteSpeedInit = Double(2.5)
let iMeteroiteSpawnTimeInit = 10
var flMeteroiteSpeed: Double!
var iMeteroiteSpawnTime: Int!

var myLabel: SKLabelNode!
var lbGameScore: SKLabelNode!
var lbGameOver: SKLabelNode!
var lbGameTime: SKLabelNode!
var lbLifes: SKLabelNode!
var snBackground: TLBackground!
var snShip: TLShip!
var blGameStarted = false

// --- game fonts ---
//let fnGameFont = UIFont(name: "HomespunTTBRK", size: 10)
//let fnGameFont = UIFont(name: "KarmaticArcade", size: 10)
//let fnGameFont = UIFont(name: "Menlo", size: 10)
let fnGameFont = UIFont(name: "Masaaki-Regular", size: 10)
//let fnGameFont = UIFont(name: "OrigamiMommy", size: 10)

var aExplosion_01 = Array<SKTexture>()

enum enBodyType: UInt32 {
    case ship = 1
    case laser = 2
    case meteroite = 4
}
// --- sounds ---
var apExplosionSound: AVAudioPlayer!


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
    var iSpeedUpateCycleTimeSec: Int!
    var iGameTimeSec: Int!
    var iTime100ms: Int!
    var iGameRestartCnt: Int!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        // --- collision setup ---
        physicsWorld.contactDelegate = self
        //view.showsPhysics = true // #debug
        // --- explosion sprites ---
        let taExplosion_01 = SKTextureAtlas(named:"explosion.atlas")
        aExplosion_01.append(taExplosion_01.textureNamed("explosion_01_001"))
        aExplosion_01.append(taExplosion_01.textureNamed("explosion_01_002"))
        aExplosion_01.append(taExplosion_01.textureNamed("explosion_01_003"))
        aExplosion_01.append(taExplosion_01.textureNamed("explosion_01_004"))
        aExplosion_01.append(taExplosion_01.textureNamed("explosion_01_005"))
        aExplosion_01.append(taExplosion_01.textureNamed("explosion_01_006"))
        aExplosion_01.append(taExplosion_01.textureNamed("explosion_01_007"))
        aExplosion_01.append(taExplosion_01.textureNamed("explosion_01_008"))
        aExplosion_01.append(taExplosion_01.textureNamed("explosion_01_009"))
        aExplosion_01.append(taExplosion_01.textureNamed("explosion_01_010"))
        aExplosion_01.append(taExplosion_01.textureNamed("explosion_01_011"))
        aExplosion_01.append(taExplosion_01.textureNamed("explosion_01_012"))
        
//        for family: String in UIFont.familyNames()
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNamesForFamilyName(family)
//            {
//                print("== \(names)")
//            }
//        }
        
        flMeteroiteSpeed = flMeteroiteSpeedInit
        iMeteroiteSpawnTime = iMeteroiteSpawnTimeInit
        iSpeedUpateCycleTimeSec = 10
        iGameTimeSec = 0
        iTimeSec = 0
        iTime100ms = 0
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
        
        snShip = TLShip(size: CGSizeMake(86.0, 78.0))
        snShip.position = CGPoint(x: 120, y: (view.frame.height/2) - 50)
        flShipPosX = snShip.position.x
        flShipPosY = snShip.position.y
        addChild(snShip)
        
        //myLabel = SKLabelNode(fontNamed:"KarmaticArcade")
        myLabel = SKLabelNode(fontNamed: fnGameFont?.fontName)
        myLabel.text = "Touch to start"
        myLabel.fontSize = 60
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - (myLabel.frame.size.height/2))
        myLabel.fontColor = UIColor.whiteColor()
        self.addChild(myLabel)
        
        // --- Interface ---
        //lbGameScore = SKLabelNode(fontNamed:"Menlo")
        lbGameScore = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbGameScore.text = "0"
        lbGameScore.fontSize = 30
        lbGameScore.position = CGPoint(x: CGRectGetMidX(self.frame) + 220, y: 12)
        lbGameScore.fontColor = UIColor.orangeColor()
        lbGameScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        lbGameScore.zPosition = 1.0
        self.addChild(lbGameScore)
        
        let snHud = SKSpriteNode(texture: SKTexture(imageNamed: "hud_001.png"), color: UIColor.clearColor(), size: CGSizeMake(470, 50))
        snHud.anchorPoint = CGPointMake(0.5, 0)
        snHud.position = CGPoint(x: CGRectGetMidX(self.frame), y: 0)
        snHud.zPosition = 1.0
        snHud.alpha = 0.75
        addChild(snHud)
        
        lbGameTime = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbGameTime.text = "0s"
        lbGameTime.fontSize = 30
        lbGameTime.position = CGPoint(x: CGRectGetMidX(self.frame), y: 15)
        lbGameTime.fontColor = UIColor.greenColor()
        lbGameTime.zPosition = 1.0
        self.addChild(lbGameTime)

        lbLifes = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbLifes.text = "> > > >"
        lbLifes.fontSize = 30
        lbLifes.position = CGPoint(x: CGRectGetMidX(self.frame) - 220, y: 12)
        lbLifes.fontColor = UIColor.blueColor()
        lbLifes.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        lbLifes.zPosition = 1.0
        self.addChild(lbLifes)
        
        // --- load sounds ---
        let path = NSBundle.mainBundle().pathForResource("/sounds/explosion_002", ofType:"wav")
        let fileURL = NSURL(fileURLWithPath: path!)
        do {
            try apExplosionSound = AVAudioPlayer(contentsOfURL: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apExplosionSound.numberOfLoops = 0
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
                if touch.locationInView(view).x <= view!.frame.size.width/2 {
                    let deltaY = (view!.frame.height - touch.locationInView(view).y) - snShip.position.y
                    snShip.fctMoveShipByY(deltaY)
                    //print("left")
                } else {
                    if snShip.apShootingSound.playing == false {
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
            fctNewGame()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (blGameOver == false) && (blGameStarted == true) {
            for touch in touches {
                if touch.locationInView(view).x <= view!.frame.size.width/2 {
                    let deltaY = (view!.frame.height - touch.locationInView(view).y) - snShip.position.y
                    if (deltaY >= 3 && deltaY <= 50) {
                        snShip.fctStartFlyAnimationLeft()
                        snShip.position.y = snShip.position.y + deltaY
                    } else if (deltaY <= -3 && deltaY >= -50) {
                        snShip.fctStartFlyAnimationRight()
                        snShip.position.y = snShip.position.y + deltaY
                    } else if (deltaY < 3 && deltaY > -3) {
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
        // --- every 100ms ---
        if iTime100ms != Int(currentTime * 10) {
            iTime100ms = Int(currentTime * 10)
            if blGameOver == true {
                iGameRestartCnt = iGameRestartCnt + 1
            }
            if (iTime100ms % iMeteroiteSpawnTime == 0) && (blGameOver == false) && (blGameStarted == true) {
                //print(iTimeSec) // #debug
                if aSnMeteroite.count == 0
                {
                    aSnMeteroite.append(TLMeteroite(size: CGSizeMake(88, 83)))
                    aSnMeteroite[0].blActive = false
                }
                allElements: for var i = 0; i < aSnMeteroite.count; i++ {
                    if aSnMeteroite[i].blActive == false {
                        aSnMeteroite[i] = TLMeteroite(size: CGSizeMake(88, 83))
                        aSnMeteroite[i].blActive = true
                        addChild(aSnMeteroite[i])
                        aSnMeteroite[i].fctMoveLeft()
                        break allElements
                    }
                    if i == (aSnMeteroite.count - 1) {
                        aSnMeteroite.append(TLMeteroite(size: CGSizeMake(88, 83)))
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
                lbGameTime.text = String(iGameTimeSec) + "s"
                if iGameTimeSec % iSpeedUpateCycleTimeSec == 0 {
                    if flMeteroiteSpeed > 0.1 {
                        flMeteroiteSpeed = flMeteroiteSpeed - 0.1
                    }
                    if iMeteroiteSpawnTime > 1 {
                        iMeteroiteSpawnTime = iMeteroiteSpawnTime - 1
                    }
                }
            }
        }
    }
    
    func fctPlayBackgroundMusic() {
        let path = NSBundle.mainBundle().pathForResource("/sounds/music_001", ofType:"mp3")
        let fileURL = NSURL(fileURLWithPath: path!)
        do {
            try apBackgroundMusic = AVAudioPlayer(contentsOfURL: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apBackgroundMusic.numberOfLoops = -1
        apBackgroundMusic.prepareToPlay()
        apBackgroundMusic.play()
    }
    
    func fctShootLaser01() {
        //snLaser.removeAllActions()
        if aSnLaser01.count == 0
        {
            aSnLaser01.append(TLLaser(size: CGSizeMake(60, 5)))
            aSnLaser01[0].blActive = false
        }
        allElements: for var i = 0; i < aSnLaser01.count; i++ {
            if aSnLaser01[i].blActive == false {
                aSnLaser01[i] = TLLaser(size: CGSizeMake(60, 5))
                aSnLaser01[i].blActive = true
                addChild(aSnLaser01[i])
                aSnLaser01[i].fctMoveRight()
                break allElements
            }
            if i == (aSnLaser01.count - 1) {
                aSnLaser01.append(TLLaser(size: CGSizeMake(60, 5)))
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
                for var i = 0; i < aSnMeteroite.count; i++ {
                    if (secondNode == aSnMeteroite[i] || firstNode == aSnMeteroite[i]) && (aSnMeteroite[i].blDestroyed == false) {
                        aSnMeteroite[i].physicsBody?.categoryBitMask = 0
                        aSnMeteroite[i].physicsBody?.contactTestBitMask = 0
                        aSnMeteroite[i].fctExplode()
                    }
                }
                for var i = 0; i < aSnLaser01.count; i++ {
                    if (secondNode == aSnLaser01[i] || firstNode == aSnLaser01[i]) && (aSnLaser01[i].blDestroyed == false)  {
                        aSnLaser01[i].physicsBody?.categoryBitMask = 0
                        aSnLaser01[i].physicsBody?.contactTestBitMask = 0
                        aSnLaser01[i].fctExplode()
                    }
                }
            case (enBodyType.ship.rawValue | enBodyType.meteroite.rawValue):
                blGameOver = true
                iGameRestartCnt = 0
                let secondNode = contact.bodyB.node
                let firstNode = contact.bodyA.node
                for var i = 0; i < aSnMeteroite.count; i++ {
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
            case (enBodyType.meteroite.rawValue):
                let secondNode = contact.bodyB.node
                let firstNode = contact.bodyA.node
                for var i = 0; i < aSnMeteroite.count; i++ {
                    if (secondNode == aSnMeteroite[i] || firstNode == aSnMeteroite[i]) && (aSnMeteroite[i].blDestroyed == false) {
                        aSnMeteroite[i].physicsBody?.categoryBitMask = 0
                        aSnMeteroite[i].physicsBody?.contactTestBitMask = 0
                        aSnMeteroite[i].fctExplode()
                    }
                }
            default:
                return
            }
        }
    }
    
    func fctGameOver() {
        iGameRestartCnt = 0
        lbGameOver = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbGameOver.text = "GAME OVER"
        lbGameOver.fontSize = 90
        lbGameOver.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - (lbGameOver.frame.size.height/2))
        lbGameOver.fontColor = UIColor.whiteColor()
        self.addChild(lbGameOver)
        
        for var i = 0; i < aSnMeteroite.count; i++ {
            aSnMeteroite[i].physicsBody?.categoryBitMask = 0
            aSnMeteroite[i].blActive = false
            aSnMeteroite[i].removeFromParent()
        }
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
        myLabel.hidden = false
        blGameStarted = false
        iGameScore = 0
        lbGameScore.text = "0"
        
        snShip = TLShip(size: CGSizeMake(86.0, 78.0))
        snShip.position = CGPoint(x: 120, y: (view!.frame.height/2) - 50)
        flShipPosX = snShip.position.x
        flShipPosY = snShip.position.y
        addChild(snShip)
    }
}
