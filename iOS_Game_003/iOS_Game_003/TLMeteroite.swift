//
//  TLmeteroite.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 17.12.15.
//  Copyright © 2015 Alexander Wegner. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class TLMeteroite: SKSpriteNode {
    var blDestroyed = false
    var blActive = false
    
    init(size: CGSize) {
        super.init(texture: SKTexture(imageNamed: "objects/meteroite_001.png"), color: UIColor.clearColor(), size: CGSizeMake(size.width, size.height))
        self.anchorPoint = CGPointMake(0.5, 0.5)
        self.position = CGPoint(x: flScreenWidth + 88/2, y: CGFloat(arc4random_uniform(UInt32(flScreenHeight)) + 1))
        // --- physics body ---
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = enBodyType.meteroite.rawValue
        self.physicsBody?.contactTestBitMask = enBodyType.laser.rawValue | enBodyType.ship.rawValue | enBodyType.meteroite.rawValue
        self.physicsBody?.collisionBitMask = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fctMoveLeft() {
        let actMoveLeft = SKAction.moveByX(-(flScreenWidth + 100), y: 0, duration: flMeteroiteSpeed)

        runAction(actMoveLeft, completion: {() in
            self.removeFromParent()
            self.blActive = false
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
        
        let lbScore = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbScore.text = "+100"
        lbScore.fontSize = 40
        lbScore.position = CGPoint(x: 0, y: 0 - (lbScore.frame.size.height / 2))
        lbScore.fontColor = UIColor.orangeColor()
        self.addChild(lbScore)
        
        self.runAction(actExplode, completion: {() in
            self.removeFromParent()
            lbScore.removeFromParent()
            self.blActive = false
        })
    }
}