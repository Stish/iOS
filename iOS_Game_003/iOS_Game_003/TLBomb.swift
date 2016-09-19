//
//  TLBomb.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 17.12.15.
//  Copyright © 2015 Alexander Wegner. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class TLBomb: SKSpriteNode {
    var blExploded = false
    var blActive = false
    var aExplosion_02 = Array<SKTexture>()
    var apExplosionSound: AVAudioPlayer!
    var snExplosion: SKSpriteNode!
    var snExplosion2: SKSpriteNode!
    var snExplosion3: SKSpriteNode!
    var apBombShootingSound: AVAudioPlayer!
    
    init(size: CGSize) {
        super.init(texture: SKTexture(imageNamed: "Media/pu_bomb_001.png"), color: UIColor.clear, size: CGSize(width: size.width, height: size.height))
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = CGPoint(x: flShipPosX + (snShip.frame.size.width/2) + (size.width/2), y: flShipPosY)
        // --- physics body ---
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = enBodyType.bomb.rawValue
        self.physicsBody?.contactTestBitMask = enBodyType.meteorite.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.zPosition = 1.1
        // Explosion radius
        snExplosion = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 350.0 * (flScreenWidth/667.0), height: 350.0 * (flScreenHeight/375.0)))
        snExplosion.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snExplosion.physicsBody = SKPhysicsBody(circleOfRadius: snExplosion.size.width/2)
        snExplosion.physicsBody?.isDynamic = false
        snExplosion.physicsBody?.affectedByGravity = false
        snExplosion.physicsBody?.allowsRotation = false
        snExplosion.physicsBody?.categoryBitMask = enBodyType.bombExplosion.rawValue
        snExplosion.physicsBody?.contactTestBitMask = enBodyType.meteorite.rawValue | enBodyType.ship.rawValue
        snExplosion.physicsBody?.collisionBitMask = 0
        self.addChild(snExplosion)
        // Explosion help sprite for contact detection
        snExplosion2 = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 350.0 * (flScreenWidth/667.0), height: 5.0 * (flScreenHeight/375.0)))
        snExplosion2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snExplosion2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: snExplosion2.frame.width, height: snExplosion2.frame.height))
        snExplosion2.physicsBody?.isDynamic = false
        snExplosion2.physicsBody?.affectedByGravity = false
        snExplosion2.physicsBody?.allowsRotation = false
        snExplosion2.physicsBody?.categoryBitMask = enBodyType.bombExplosion.rawValue
        snExplosion2.physicsBody?.contactTestBitMask = enBodyType.meteorite.rawValue | enBodyType.ship.rawValue
        snExplosion2.physicsBody?.collisionBitMask = 0
        self.addChild(snExplosion2)
        // Explosion help sprite for contact detection
        snExplosion3 = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 5.0 * (flScreenWidth/667.0), height: 350.0 * (flScreenHeight/375.0)))
        snExplosion3.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snExplosion3.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: snExplosion3.frame.width, height: snExplosion3.frame.height))
        snExplosion3.physicsBody?.isDynamic = false
        snExplosion3.physicsBody?.affectedByGravity = false
        snExplosion3.physicsBody?.allowsRotation = false
        snExplosion3.physicsBody?.categoryBitMask = enBodyType.bombExplosion.rawValue
        snExplosion3.physicsBody?.contactTestBitMask = enBodyType.meteorite.rawValue | enBodyType.ship.rawValue
        snExplosion3.physicsBody?.collisionBitMask = 0
        self.addChild(snExplosion3)
        
        aExplosion_02.removeAll()
        aExplosion_02.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_02_001"))
        aExplosion_02.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_02_002"))
        aExplosion_02.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_02_003"))
        aExplosion_02.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_02_004"))
        aExplosion_02.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_02_005"))
        aExplosion_02.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_02_006"))
        aExplosion_02.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_02_007"))
        aExplosion_02.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_02_008"))
        if GameData.blSoundEffectsEnabled == true {
            let path = Bundle.main.path(forResource: "Media/sounds/bomb_001", ofType:"wav")
            let fileURL = URL(fileURLWithPath: path!)
            do {
                try apBombShootingSound = AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
            } catch {
                print("Could not create audio player: \(error)")
                return
            }
            apBombShootingSound.numberOfLoops = 0
            apBombShootingSound.volume = GameData.flSoundsVolume
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fctMoveRight() {
        let actShoot = SKAction.moveBy(x: 350  * (flScreenWidth/667.0), y: 0, duration: 1.0)
        self.run(actShoot, completion: {() in
            self.fctExplode()
        })
    }
    
    func fctExplode() {
        blBombFired = false
        self.blExploded = true
        self.blActive = false
        self.texture = SKTexture(imageNamed: "Media/transparent.png")
        let actExplode = SKAction.animate(with: aExplosion_02, timePerFrame: 0.05)
        self.removeAllActions()
        self.physicsBody?.categoryBitMask = 0
        self.physicsBody?.contactTestBitMask = 0
        // --- load sounds ---
        if GameData.blSoundEffectsEnabled == true {
            let path = Bundle.main.path(forResource: "Media/sounds/explosion_003", ofType:"wav")
            let fileURL = URL(fileURLWithPath: path!)
            do {
                apExplosionSound = try AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
                apExplosionSound.volume = GameData.flSoundsVolume * 4
                apExplosionSound.numberOfLoops = 0
                apExplosionSound.prepareToPlay()
                apExplosionSound.play()
            } catch {
                print("Could not create audio player: \(error)")
                return
            }
        }
        snExplosion.run(actExplode, completion: {() in
            self.blActive = false
            self.removeAllActions()
            self.removeFromParent()
        })
        snExplosion2.run(SKAction.rotate(byAngle: 2 * CGFloat(M_PI), duration: 0.8), completion: {() in
            self.snExplosion2.physicsBody?.categoryBitMask = 0
            self.snExplosion2.physicsBody?.contactTestBitMask = 0
        })
        snExplosion3.run(SKAction.rotate(byAngle: 2 * CGFloat(M_PI), duration: 0.8), completion: {() in
            self.snExplosion3.physicsBody?.categoryBitMask = 0
            self.snExplosion3.physicsBody?.contactTestBitMask = 0
        })
        self.snExplosion.physicsBody?.categoryBitMask = 0
        self.snExplosion.physicsBody?.contactTestBitMask = 0
    }
    
    func fctPlayShootingSound() {
        if GameData.blSoundEffectsEnabled == true {
            apBombShootingSound.volume = GameData.flSoundsVolume
            apBombShootingSound.prepareToPlay()
            apBombShootingSound.play()
        }
    }
}
