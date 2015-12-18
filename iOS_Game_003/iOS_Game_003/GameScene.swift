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

var myLabel: SKLabelNode!
var lbGameScore: SKLabelNode!
var lbGameOver: SKLabelNode!
var snBackground: TLBackground!
var snShip: TLShip!
var blGameStarted = false

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
    var aSnmeteroite = Array<TLmeteroite>()
    var iTimeSec: Int!
    var iTime100ms: Int!
    var iGameRestartCnt: Int!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        // --- collision setup ---
        physicsWorld.contactDelegate = self
        //view.showsPhysics = true
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
        
        iTimeSec = 0
        iTime100ms = 0
        iGameRestartCnt = 0
        flScreenWidth = view.frame.size.width
        flScreenHeight = view.frame.size.height
        
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        self.anchorPoint = CGPointMake(0, 0)
        myLabel = SKLabelNode(fontNamed:"Arial")
        myLabel.text = "Touch to start"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - (myLabel.frame.size.height/2))
        myLabel.fontColor = UIColor.whiteColor()
        
        snBackground = TLBackground(size: CGSizeMake(view.frame.width, view.frame.height))
        self.anchorPoint = CGPointMake(0.0, 0.0)
        //snGameMap.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        snBackground.position = CGPoint(x: 0, y: 0)
        addChild(snBackground)
        self.addChild(myLabel)
        
        snShip = TLShip(size: CGSizeMake(86.0, 78.0))
        snShip.position = CGPoint(x: 120, y: view.frame.height/2)
        flShipPosX = snShip.position.x
        flShipPosY = snShip.position.y
        addChild(snShip)
        
        // --- Interface ---
        lbGameScore = SKLabelNode(fontNamed:"Menlo")
        lbGameScore.text = "0"
        lbGameScore.fontSize = 25
        lbGameScore.position = CGPoint(x:CGRectGetMidX(self.frame), y: self.frame.size.height - 30)
        lbGameScore.fontColor = UIColor.orangeColor()
        self.addChild(lbGameScore)
        
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
            if (iTime100ms % 10 == 0) && (blGameOver == false) && (blGameStarted == true) {
                //print(iTimeSec) // #debug
                if aSnmeteroite.count == 0
                {
                    aSnmeteroite.append(TLmeteroite(size: CGSizeMake(88, 83)))
                    aSnmeteroite[0].name = "inactive"
                }
                allElements: for var i = 0; i < aSnmeteroite.count; i++ {
                    if aSnmeteroite[i].name == "inactive" {
                        aSnmeteroite[i] = TLmeteroite(size: CGSizeMake(88, 83))
                        aSnmeteroite[i].name = "active"
                        addChild(aSnmeteroite[i])
                        aSnmeteroite[i].fctMoveLeft()
                        break allElements
                    }
                    if i == (aSnmeteroite.count - 1) {
                        aSnmeteroite.append(TLmeteroite(size: CGSizeMake(88, 83)))
                        aSnmeteroite[i+1].name = "active"
                        addChild(aSnmeteroite[i+1])
                        aSnmeteroite[i+1].fctMoveLeft()
                        break allElements
                    }
                }
                print(aSnmeteroite.count) // #debug
            }
        }
        // --- every 1s ---
        if (iTimeSec != Int(currentTime)) && (blGameStarted == true) {
            iTimeSec = Int(currentTime)
//            if (iTimeSec % 1 == 0) && (blGameOver == false) {
//                //print(iTimeSec) // #debug
//                if aSnmeteroite.count == 0
//                {
//                    aSnmeteroite.append(TLmeteroite(size: CGSizeMake(88, 83)))
//                    aSnmeteroite[0].name = "inactive"
//                }
//                allElements: for var i = 0; i < aSnmeteroite.count; i++ {
//                    if aSnmeteroite[i].name == "inactive" {
//                        aSnmeteroite[i] = TLmeteroite(size: CGSizeMake(88, 83))
//                        aSnmeteroite[i].name = "active"
//                        addChild(aSnmeteroite[i])
//                        aSnmeteroite[i].fctMoveLeft()
//                        break allElements
//                    }
//                    if i == (aSnmeteroite.count - 1) {
//                        aSnmeteroite.append(TLmeteroite(size: CGSizeMake(88, 83)))
//                        aSnmeteroite[i+1].name = "active"
//                        addChild(aSnmeteroite[i+1])
//                        aSnmeteroite[i+1].fctMoveLeft()
//                        break allElements
//                    }
//                }
//                print(aSnmeteroite.count) // #debug
//            }
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
            aSnLaser01[0].name = "inactive"
        }
        allElements: for var i = 0; i < aSnLaser01.count; i++ {
            if aSnLaser01[i].name == "inactive" {
                aSnLaser01[i] = TLLaser(size: CGSizeMake(60, 5))
                aSnLaser01[i].name = "active"
                addChild(aSnLaser01[i])
                aSnLaser01[i].fctMoveRight()
                break allElements
            }
            if i == (aSnLaser01.count - 1) {
                aSnLaser01.append(TLLaser(size: CGSizeMake(60, 5)))
                aSnLaser01[i+1].name = "active"
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
                for var i = 0; i < aSnmeteroite.count; i++ {
                    if (secondNode == aSnmeteroite[i] || firstNode == aSnmeteroite[i]) && (aSnmeteroite[i].blDestroyed == false) {
                        aSnmeteroite[i].physicsBody?.categoryBitMask = 0
                        aSnmeteroite[i].fctExplode()
                    }
                }
                for var i = 0; i < aSnLaser01.count; i++ {
                    if (secondNode == aSnLaser01[i] || firstNode == aSnLaser01[i]) && (aSnLaser01[i].blDestroyed == false)  {
                        aSnLaser01[i].physicsBody?.categoryBitMask = 0
                        aSnLaser01[i].fctExplode()
                    }
                }
            case (enBodyType.ship.rawValue | enBodyType.meteroite.rawValue):
                blGameOver = true
                iGameRestartCnt = 0
                let secondNode = contact.bodyB.node
                let firstNode = contact.bodyA.node
                for var i = 0; i < aSnmeteroite.count; i++ {
                    if secondNode == aSnmeteroite[i] || firstNode == aSnmeteroite[i] {
                        aSnmeteroite[i].physicsBody?.categoryBitMask = 0
                        aSnmeteroite[i].fctExplode()
                    }
                }
                //snShip.removeFromParent()
                self.fctGameOver()
                snShip.physicsBody?.categoryBitMask = 0
                snShip.fctExplode()
            default:
                return
            }
        }
    }
    
    func fctGameOver() {
        iGameRestartCnt = 0
        lbGameOver = SKLabelNode(fontNamed:"Menlo")
        lbGameOver.text = "GAME OVER"
        lbGameOver.fontSize = 70
        lbGameOver.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - (lbGameOver.frame.size.height/2))
        lbGameOver.fontColor = UIColor.whiteColor()
        self.addChild(lbGameOver)
    }
    
    func fctNewGame() {
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
        snShip.position = CGPoint(x: 120, y: view!.frame.height/2)
        flShipPosX = snShip.position.x
        flShipPosY = snShip.position.y
        addChild(snShip)
    }
}
