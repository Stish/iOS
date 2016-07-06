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
    var iHealth = 100
    var iScore = 100
    
    init(size: CGSize, rotSpeed: CGFloat, rotDirec: Int) {
        super.init(texture: SKTexture(imageNamed: "objects/meteroite_001.png"), color: UIColor.clearColor(), size: CGSizeMake(size.width, size.height))
        // Different textures
        switch (arc4random_uniform(UInt32(100)) + 1) {
        case 1...30:
            self.texture = SKTexture(imageNamed: "objects/meteroite_001.png")
        case 31...60:
            self.texture = SKTexture(imageNamed: "objects/meteroite_002.png")
        case 61...90:
            self.texture = SKTexture(imageNamed: "objects/meteroite_003.png")
        case 91...93:
            self.texture = SKTexture(imageNamed: "objects/meteroite_004.png")
            iHealth = 200
            iScore = 200
        case 94...96:
            self.texture = SKTexture(imageNamed: "objects/meteroite_005.png")
            iHealth = 200
            iScore = 200
        case 97...100:
            self.texture = SKTexture(imageNamed: "objects/meteroite_006.png")
            iHealth = 200
            iScore = 200
        default:
            return
        }
        
        self.anchorPoint = CGPointMake(0.5, 0.5)
        self.position = CGPoint(x: flScreenWidth + 88/2, y: CGFloat(arc4random_uniform(UInt32(flScreenHeight)) + 1))
        // --- physics body ---
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.categoryBitMask = enBodyType.meteroite.rawValue
        self.physicsBody?.contactTestBitMask = enBodyType.laser.rawValue | enBodyType.ship.rawValue | enBodyType.meteroite.rawValue
        self.physicsBody?.collisionBitMask = 0
        
        self.fctRotate(rotSpeed, iDirection: rotDirec)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fctRotate (flRotationSpeed: CGFloat, iDirection: Int) {
        let actRotate = SKAction.rotateByAngle(CGFloat(Double(iDirection)*M_PI*2.0), duration: 10.0)
        
        runAction(SKAction.repeatActionForever(actRotate))
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
        iGameScore = iGameScore + iScore
        lbGameScore.text = String(iGameScore)
        self.removeAllActions()
        apExplosionSound.prepareToPlay()
        apExplosionSound.play()
        
        let lbScore = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbScore.text = "+" + String(iScore)
        lbScore.fontSize = 40
        lbScore.position = CGPoint(x: 0, y: 0 - (lbScore.frame.size.height / 2))
        lbScore.fontColor = UIColor.orangeColor()
        self.runAction(SKAction.rotateToAngle(0, duration: 0))
        self.addChild(lbScore)
        
        self.runAction(actExplode, completion: {() in
            self.removeFromParent()
            lbScore.removeFromParent()
            self.blActive = false
        })
    }
    
    func fctHit() {
        apHitSound.prepareToPlay()
        apHitSound.play()
    }
}