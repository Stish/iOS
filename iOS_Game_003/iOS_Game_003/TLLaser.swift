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
    var blActive = false
    var apLaserShootingSound: AVAudioPlayer!
    
    init(size: CGSize) {
        super.init(texture: SKTexture(imageNamed: "Media/effects/laser_001.png"), color: UIColor.clear, size: CGSize(width: size.width, height: size.height))
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = CGPoint(x: flShipPosX + (snShip.frame.size.width/2) + (size.width/2), y: flShipPosY)
        // --- physics body ---
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width/2, height: size.height))
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = enBodyType.laser.rawValue
        self.physicsBody?.contactTestBitMask = enBodyType.meteorite.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.zPosition = 1.1
        if GameData.blSoundEffectsEnabled == true {
            // Sounds for laser
            let path = Bundle.main.path(forResource: "Media/sounds/laser_002", ofType:"wav")
            let fileURL = URL(fileURLWithPath: path!)
            do {
                try apLaserShootingSound = AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
            } catch {
                print("Could not create audio player: \(error)")
                return
            }
            apLaserShootingSound.numberOfLoops = 0
            apLaserShootingSound.volume = GameData.flSoundsVolume
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fctMoveRight() {
        let actShoot = SKAction.moveBy(x: flScreenWidth, y: 0, duration: 1.0)
        self.run(actShoot, completion: {() in
            self.removeFromParent()
            self.blActive = false
        })
    }
    
    func fctExplode() {
        self.blDestroyed = true
        self.removeFromParent()
        self.blActive = false
    }
    
    func fctPlayShootingSound() {
        if GameData.blSoundEffectsEnabled == true {
            apLaserShootingSound.volume = GameData.flSoundsVolume
            apLaserShootingSound.prepareToPlay()
            apLaserShootingSound.play()
        }
    }
}
