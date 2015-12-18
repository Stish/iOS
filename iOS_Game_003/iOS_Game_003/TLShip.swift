//
//  TLShip.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 15.12.15.
//  Copyright © 2015 Alexander Wegner. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class TLShip: SKSpriteNode {
    var aShipFlyFront = Array<SKTexture>()
    var aShipFlyLeft = Array<SKTexture>()
    var aShipFlyRight = Array<SKTexture>()
    var apShootingSound: AVAudioPlayer!
    
    init(size: CGSize) {
        let taShip = SKTextureAtlas(named:"ship.atlas")
        
        aShipFlyFront.append(taShip.textureNamed("ship_001"))
        aShipFlyFront.append(taShip.textureNamed("ship_002"))
        aShipFlyLeft.append(taShip.textureNamed("ship_left_001"))
        aShipFlyLeft.append(taShip.textureNamed("ship_left_002"))
        aShipFlyRight.append(taShip.textureNamed("ship_right_001"))
        aShipFlyRight.append(taShip.textureNamed("ship_right_002"))
        
        super.init(texture: aShipFlyFront[0], color: UIColor.clearColor(), size: CGSizeMake(size.width, size.height))
        self.anchorPoint = CGPointMake(0.5, 0.5)
        self.fctStartFlyAnimationFront()
        // --- physics body ---
        // 1
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        // 2
        self.physicsBody?.dynamic = true
        // 3
        self.physicsBody?.affectedByGravity = false
        // 4
        self.physicsBody?.allowsRotation = false
        // 5
        self.physicsBody?.categoryBitMask = enBodyType.ship.rawValue
        // 6
        self.physicsBody?.contactTestBitMask = enBodyType.metroid.rawValue
        // 7
        self.physicsBody?.collisionBitMask = 0
        // --- Sounds: Shooting ---
        let path = NSBundle.mainBundle().pathForResource("/sounds/laser_002", ofType:"wav")
        let fileURL = NSURL(fileURLWithPath: path!)
        do {
            try apShootingSound = AVAudioPlayer(contentsOfURL: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apShootingSound.numberOfLoops = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fctMoveShipByY(delatY: CGFloat) {
        let cnt = delatY / 10
        if cnt >= 1 {
            self.fctStartFlyAnimationLeft()
            let actMoveShipVertByY = SKAction.moveBy(CGVector.init(dx: 0, dy: 10), duration: 0.02)
            self.runAction(SKAction.repeatAction(actMoveShipVertByY, count: Int(cnt)), completion: {() in
                self.fctStartFlyAnimationFront()
            })
        } else if cnt <= -1 {
            self.fctStartFlyAnimationRight()
            let actMoveShipVertByY = SKAction.moveBy(CGVector.init(dx: 0, dy: -10), duration: 0.02)
            self.runAction(SKAction.repeatAction(actMoveShipVertByY, count: Int(cnt * (-1))), completion: {() in
                self.fctStartFlyAnimationFront()
            })
        }
    }
    
    func fctStartFlyAnimationFront() {
        self.removeAllActions()
        let actFlyFront = SKAction.animateWithTextures(self.aShipFlyFront, timePerFrame: 0.15);
        self.runAction(SKAction.repeatActionForever(actFlyFront))
    }
    
    func fctStartFlyAnimationLeft() {
        self.removeAllActions()
        let actFlyLeft = SKAction.animateWithTextures(self.aShipFlyLeft, timePerFrame: 0.15);
        self.runAction(SKAction.repeatActionForever(actFlyLeft))
    }
    
    func fctStartFlyAnimationRight() {
        self.removeAllActions()
        let actFlyRight = SKAction.animateWithTextures(self.aShipFlyRight, timePerFrame: 0.15);
        self.runAction(SKAction.repeatActionForever(actFlyRight))
    }
    

//        snLaser = SKSpriteNode(texture: SKTexture(imageNamed: "laser_001.png"), color: UIColor.clearColor(), size: CGSizeMake(60, 5))
//        snLaser.anchorPoint = CGPointMake(0.0, 0.5)
//        snLaser.position = CGPoint(x: self.frame.size.width, y: 0)
//        addChild(snLaser)
//        let actShoot = SKAction.moveByX(iScreenWidth, y: 0, duration: 1.0)
//        snLaser.runAction(actShoot, completion: {() in
//            self.snLaser.removeFromParent()
//        })
    
    func fctPlayShootingSound() {
        //apShootingSound.prepareToPlay()
        apShootingSound.play()
    }
    
    func fctExplode() {
        let actExplode = SKAction.animateWithTextures(aExplosion_01, timePerFrame: 0.07)
        self.removeAllActions()
        apExplosionSound.prepareToPlay()
        apExplosionSound.play()
        
        self.runAction(actExplode, completion: {() in
            self.removeFromParent()
            self.name = "inactive"
        })
    }
}
