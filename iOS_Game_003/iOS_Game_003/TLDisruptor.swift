//
//  TLDisruptor.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 24.10.16.
//  Copyright © 2015 Alexander Wegner. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class TLDisruptor: SKSpriteNode {
    var blDestroyed = false
    var blActive = false
    var aShootingAnimation = Array<SKTexture>()
    var apDisruptorShootingSound: AVAudioPlayer!
    var snPhysicsBody: SKSpriteNode!
    
    init(size: CGSize) {
        super.init(texture: SKTexture(imageNamed: "Media/effects/disruptor_001.png"), color: UIColor.clear, size: CGSize(width: size.width, height: size.height))
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = CGPoint(x: flShipPosX + (snShip.frame.size.width/2) + (size.width/2), y: flShipPosY)
        self.zPosition = 1.1
        // --- physics body ---
        snPhysicsBody = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 21 * (flScreenWidth/667.0), height: 21 * (flScreenHeight/375.0)))
        snPhysicsBody.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //snPhysicsBody.position = CGPoint(x: self.position.x - self.frame.width, y: self.snPhysicsBody.position.y)
        snPhysicsBody.position = CGPoint(x: 0 - (self.frame.width/2), y: 0)
        snPhysicsBody.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 21 * (flScreenWidth/667.0), height: 21 * (flScreenHeight/375.0)))
        snPhysicsBody.physicsBody?.isDynamic = false
        snPhysicsBody.physicsBody?.affectedByGravity = false
        snPhysicsBody.physicsBody?.allowsRotation = false
        snPhysicsBody.physicsBody?.categoryBitMask = enBodyType.laserSphere.rawValue
        snPhysicsBody.physicsBody?.contactTestBitMask = enBodyType.meteorite.rawValue
        snPhysicsBody.physicsBody?.collisionBitMask = 0
        snPhysicsBody.zPosition = 1.1
        self.addChild(snPhysicsBody)
        // Animation
        aShootingAnimation.removeAll()
        aShootingAnimation.append(SKTexture(imageNamed: "Media/effects/disruptor_001.png"))
        aShootingAnimation.append(SKTexture(imageNamed: "Media/effects/disruptor_002.png"))
        self.removeAllActions()
        let actMoving = SKAction.animate(with: aShootingAnimation, timePerFrame: 0.06)
        self.run(SKAction.repeatForever(actMoving))
        // Sounds
        if GameData.blSoundEffectsEnabled == true {
            // Sounds for laser
            let path = Bundle.main.path(forResource: "Media/sounds/laser_002", ofType:"wav")
            let fileURL = URL(fileURLWithPath: path!)
            do {
                try apDisruptorShootingSound = AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
            } catch {
                print("Could not create audio player: \(error)")
                return
            }
            apDisruptorShootingSound.numberOfLoops = 0
            apDisruptorShootingSound.volume = GameData.flSoundsVolume
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fctMoveRight() {
        let actShoot = SKAction.moveBy(x: flScreenWidth, y: 0, duration: 0.15)
        snPhysicsBody.run(actShoot, completion: {() in
            self.snPhysicsBody.position = CGPoint(x: 0 - (self.frame.width/2), y: 0)
            self.snPhysicsBody.run(actShoot, completion: {() in
                self.snPhysicsBody.position = CGPoint(x: 0 - (self.frame.width/2), y: 0)
                self.snPhysicsBody.run(actShoot, completion: {() in
                    self.snPhysicsBody.position = CGPoint(x: 0 - (self.frame.width/2), y: 0)
                    self.snPhysicsBody.run(actShoot, completion: {() in
                        self.removeAllActions()
                        blLaserDisruptorFiring = false
                        snShip.speed = 1.0
                        self.blActive = false
                        self.blDestroyed = true
                        self.snPhysicsBody.physicsBody?.categoryBitMask = 0
                        self.snPhysicsBody.physicsBody?.contactTestBitMask = 0
                        self.removeFromParent()
                    })
                })
            })
        })
    }
    
    func fctExplode() {
        self.blDestroyed = true
        self.removeFromParent()
        self.blActive = false
    }
    
    func fctPlayShootingSound() {
        if GameData.blSoundEffectsEnabled == true {
            apDisruptorShootingSound.volume = GameData.flSoundsVolume
            apDisruptorShootingSound.prepareToPlay()
            apDisruptorShootingSound.play()
        }
    }
}
