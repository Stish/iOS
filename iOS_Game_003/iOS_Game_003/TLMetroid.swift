//
//  TLMetroid.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 17.12.15.
//  Copyright © 2015 Alexander Wegner. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class TLMetroid: SKSpriteNode {
    var blDestroyed = false
    
    init(size: CGSize) {
        super.init(texture: SKTexture(imageNamed: "objects/metroid_001.png"), color: UIColor.clearColor(), size: CGSizeMake(size.width, size.height))
        self.anchorPoint = CGPointMake(0.5, 0.5)
        self.position = CGPoint(x: flScreenWidth + 88/2, y: CGFloat(arc4random_uniform(UInt32(flScreenHeight)) + 1))
        // 1
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        // 2
        self.physicsBody?.dynamic = true
        // 3
        self.physicsBody?.affectedByGravity = false
        // 4
        self.physicsBody?.allowsRotation = false
        // 5
        self.physicsBody?.categoryBitMask = enBodyType.metroid.rawValue
        // 6
        self.physicsBody?.contactTestBitMask = enBodyType.laser.rawValue | enBodyType.ship.rawValue
        // 7
        self.physicsBody?.collisionBitMask = 0
        // --- Sounds: Shooting ---
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fctMoveLeft() {
        let actMoveLeft = SKAction.moveByX(-(flScreenWidth + 100), y: 0, duration: 2.5)

        runAction(actMoveLeft, completion: {() in
            self.removeFromParent()
            self.name = "inactive"
        })
    }
    
    func fctExplode() {
        let actExplode = SKAction.animateWithTextures(aExplosion_01, timePerFrame: 0.07)
        self.blDestroyed = true
        iGameScore = iGameScore + 100
        lbGameScore.text = String(iGameScore)
        self.removeAllActions()
        apExplosionSound.prepareToPlay()
        apExplosionSound.play()
        
        let lbScore = SKLabelNode(fontNamed:"Menlo")
        lbScore.text = "+100"
        lbScore.fontSize = 25
        lbScore.position = CGPoint(x: 0, y: 0)
        lbScore.fontColor = UIColor.orangeColor()
        self.addChild(lbScore)
        
        self.runAction(actExplode, completion: {() in
            self.removeFromParent()
            lbScore.removeFromParent()
            //aSnLaser01[0] = nil
            self.name = "inactive"
        })
    }
}