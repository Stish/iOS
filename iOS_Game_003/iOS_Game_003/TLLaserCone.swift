//
//  TLLaserCone.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 17.12.15.
//  Copyright © 2015 Alexander Wegner. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class TLLaserCone: SKSpriteNode {
    var blExploded = false
    var blActive = false
    var blDestroyed: Bool!
    var aAnimation = Array<SKTexture>()
    var iAngle: Int!
    var apLaserConeShootingSound: AVAudioPlayer!
    
    init(size: CGSize, angle: Int) {
        super.init(texture: SKTexture(imageNamed: "Media/effects/cone_001.png"), color: UIColor.clearColor(), size: CGSizeMake(size.width, size.height))
        self.anchorPoint = CGPointMake(0.0, 0.5)
        self.position = CGPoint(x: flShipPosX + (snShip.frame.size.width/2), y: flShipPosY)
        // --- physics body ---
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(size.width, size.height), center: CGPoint(x: self.size.width / 2, y: 0))
        self.physicsBody?.dynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.categoryBitMask = enBodyType.laserCone.rawValue
        self.physicsBody?.contactTestBitMask = enBodyType.meteorite.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.zPosition = 1.1
        // Angle describes the orientation of the laser:
        // 0: Upper laser, which moves in the upper right corner
        // 1: Middle laser, which moves parallel to x-axis
        // 2: Lower laser, which moves in the lower right corner
        iAngle = angle
        blDestroyed = false
        switch (angle) {
        case 0:
            self.zRotation = atan(((flScreenHeight / 2)) / (flScreenWidth - (self.position.x) + 50))
            if GameData.blSoundEffectsEnabled == true {
                // Sounds for laser cone
                let path = NSBundle.mainBundle().pathForResource("Media/sounds/laser_004", ofType:"wav")
                let fileURL = NSURL(fileURLWithPath: path!)
                do {
                    try apLaserConeShootingSound = AVAudioPlayer(contentsOfURL: fileURL, fileTypeHint: nil)
                } catch {
                    print("Could not create audio player: \(error)")
                    return
                }
                apLaserConeShootingSound.numberOfLoops = 0
                apLaserConeShootingSound.volume = GameData.flSoundsVolume * 0.4
            }
        case 1:
            self.zRotation = 0
        case 2:
            self.zRotation =  -1 * atan(((flScreenHeight / 2)) / (flScreenWidth - (self.position.x) + 50))
        default:
            ()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fctMove(angle: Int) {
        switch (angle) {
        case 0:
            let actShoot = SKAction.moveTo(CGPointMake(flScreenWidth + 50, self.position.y + (flScreenHeight / 2)), duration: 1.0)
            //(flScreenWidth, y: 0, duration: 1.0)
            self.runAction(actShoot, completion: {() in
                self.removeFromParent()
                self.blActive = false
            })
        case 1:
            let actShoot = SKAction.moveByX(flScreenWidth, y: 0, duration: 1.0)
            self.runAction(actShoot, completion: {() in
                self.removeFromParent()
                self.blActive = false
            })
        case 2:
            let actShoot = SKAction.moveTo(CGPointMake(flScreenWidth + 50, self.position.y - (flScreenHeight / 2)), duration: 1.0)
            //(flScreenWidth, y: 0, duration: 1.0)
            self.runAction(actShoot, completion: {() in
                self.removeFromParent()
                self.blActive = false
            })
        default:
            ()
        }
    }
    
    func fctExplode() {
        self.blExploded = true
        self.blActive = false
        self.removeAllActions()
        self.physicsBody?.categoryBitMask = 0
        self.physicsBody?.contactTestBitMask = 0
        self.removeFromParent()
    }
    
    func fctPlayShootingSound() {
        if (GameData.blSoundEffectsEnabled == true) && (iAngle == 0) {
            apLaserConeShootingSound.volume = GameData.flSoundsVolume * 0.6
            apLaserConeShootingSound.prepareToPlay()
            apLaserConeShootingSound.play()
        }
    }
}
