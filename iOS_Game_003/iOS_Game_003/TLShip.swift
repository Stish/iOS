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
    var blActive = false
    
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
        self.physicsBody = SKPhysicsBody(circleOfRadius: (self.size.width/2) - 10)
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = enBodyType.ship.rawValue
        self.physicsBody?.contactTestBitMask = enBodyType.meteroite.rawValue
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
    
    func fctPlayShootingSound() {
        apShootingSound.prepareToPlay()
        apShootingSound.play()
    }
    
    func fctExplode() {
        let actExplode = SKAction.animateWithTextures(aExplosion_01, timePerFrame: 0.07)
        self.removeAllActions()
        apExplosionSound.prepareToPlay()
        apExplosionSound.play()
        
        self.runAction(actExplode, completion: {() in
            self.removeFromParent()
            self.blActive = false
        })
    }
}
