//
//  TLLaser.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 17.12.15.
//  Copyright © 2015 Alexander Wegner. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class TLLaser: SKSpriteNode {
    var blDestroyed = false
    
    init(size: CGSize) {
        super.init(texture: SKTexture(imageNamed: "effects/laser_001.png"), color: UIColor.clearColor(), size: CGSizeMake(size.width, size.height))
        self.anchorPoint = CGPointMake(0.5, 0.5)
        self.position = CGPoint(x: flShipPosX + (snShip.frame.size.width/2) + (size.width/2), y: flShipPosY)
        // --- collision ---
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(size.width/2, size.height))
        self.physicsBody?.dynamic = false
        // 3
        self.physicsBody?.affectedByGravity = false
        // 4
        self.physicsBody?.allowsRotation = false
        // 5
        self.physicsBody?.categoryBitMask = enBodyType.laser.rawValue
        // 6
        self.physicsBody?.contactTestBitMask = enBodyType.metroid.rawValue
        // 7
        self.physicsBody?.collisionBitMask = 0

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fctMoveRight() {
        let actShoot = SKAction.moveByX(flScreenWidth, y: 0, duration: 1.0)
        self.runAction(actShoot, completion: {() in
            self.removeFromParent()
            //aSnLaser01[0] = nil
            self.name = "inactive"
        })
    }
    
    func fctExplode() {
//        let actExplode = SKAction.animateWithTextures(aExplosion_01, timePerFrame: 0.05)
//        self.removeAllActions()
//        self.runAction(actExplode, completion: {() in
//            self.removeFromParent()
//            //aSnLaser01[0] = nil
//            self.name = "inactive"
//        })
        self.blDestroyed = true
        self.removeFromParent()
        //aSnLaser01[0] = nil
        self.name = "inactive"
    }
}
