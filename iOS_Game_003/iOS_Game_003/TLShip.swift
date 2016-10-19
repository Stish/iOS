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
    var blActive = false
    var iHealth = 500
    var snShipShield: SKSpriteNode!
    //var apThrust: AVAudioPlayer!
    
    init(size: CGSize) {
        //let taShip = SKTextureAtlas(named:"ship.atlas")
        aShipFlyFront.removeAll()
        aShipFlyLeft.removeAll()
        aShipFlyRight.removeAll()
        switch (iSelectedShip) {
        case 0:
            aShipFlyFront.append(SKTexture(imageNamed: "Media/ship.atlas/ship_01_001.png"))
            aShipFlyFront.append(SKTexture(imageNamed: "Media/ship.atlas/ship_01_002"))
            aShipFlyLeft.append(SKTexture(imageNamed: "Media/ship.atlas/ship_01_left_001"))
            aShipFlyLeft.append(SKTexture(imageNamed: "Media/ship.atlas/ship_01_left_002"))
            aShipFlyRight.append(SKTexture(imageNamed: "Media/ship.atlas/ship_01_right_001"))
            aShipFlyRight.append(SKTexture(imageNamed: "Media/ship.atlas/ship_01_right_002"))
        case 1:
            aShipFlyFront.append(SKTexture(imageNamed: "Media/ship.atlas/ship_02_001.png"))
            aShipFlyFront.append(SKTexture(imageNamed: "Media/ship.atlas/ship_02_002"))
            aShipFlyLeft.append(SKTexture(imageNamed: "Media/ship.atlas/ship_02_left_001"))
            aShipFlyLeft.append(SKTexture(imageNamed: "Media/ship.atlas/ship_02_left_002"))
            aShipFlyRight.append(SKTexture(imageNamed: "Media/ship.atlas/ship_02_right_001"))
            aShipFlyRight.append(SKTexture(imageNamed: "Media/ship.atlas/ship_02_right_002"))
        case 2:
            ()
        default:
            ()
        }
        super.init(texture: aShipFlyFront[0], color: UIColor.clear, size: CGSize(width: size.width, height: size.height))
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.fctStartFlyAnimationFront()
        // --- physics body ---
        self.physicsBody = SKPhysicsBody(circleOfRadius: (self.size.width/2) - (10 * (flScreenWidth/667.0)))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = enBodyType.ship.rawValue
        self.physicsBody?.contactTestBitMask = enBodyType.meteorite.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.zPosition = 1.1
        // --- Shield ---
        snShipShield = SKSpriteNode(texture: SKTexture(imageNamed: "Media/ship.atlas/ship_shield_001.png"), color: UIColor.blue, size: CGSize(width: 40 * (flScreenWidth/667.0), height: 80 * (flScreenHeight/375.0)))
        snShipShield.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        snShipShield.position = CGPoint(x: self.position.x, y: self.position.y)
        snShipShield.zPosition = 1.1
        snShipShield.alpha = 0.0
        self.addChild(snShipShield)
        // --- Sounds: Thrust ---
//        let path = NSBundle.mainBundle().pathForResource("Media/sounds/thrust_002", ofType:"wav")
//        let fileURL = NSURL(fileURLWithPath: path!)
//        do {
//            try apThrust = AVAudioPlayer(contentsOfURL: fileURL, fileTypeHint: nil)
//        } catch {
//            print("Could not create audio player: \(error)")
//            return
//        }
//        apThrust.numberOfLoops = -1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fctMoveShipByY(_ delatY: CGFloat) {
        let cnt = delatY / 10
        if cnt >= 1 {
            self.fctStartFlyAnimationLeft()
            let actMoveShipVertByY = SKAction.move(by: CGVector.init(dx: 0, dy: 10), duration: 0.01)
            self.run(SKAction.repeat(actMoveShipVertByY, count: Int(cnt)), completion: {() in
                self.fctStartFlyAnimationFront()
            })
        } else if cnt <= -1 {
            self.fctStartFlyAnimationRight()
            let actMoveShipVertByY = SKAction.move(by: CGVector.init(dx: 0, dy: -10), duration: 0.01)
            self.run(SKAction.repeat(actMoveShipVertByY, count: Int(cnt * (-1))), completion: {() in
                self.fctStartFlyAnimationFront()
            })
        }
    }
    
    func fctStartFlyAnimationFront() {
        self.removeAllActions()
        let actFlyFront = SKAction.animate(with: self.aShipFlyFront, timePerFrame: 0.15);
        self.run(SKAction.repeatForever(actFlyFront))
    }
    
    func fctStartFlyAnimationLeft() {
        self.removeAllActions()
        //apThrust.prepareToPlay()
        //apThrust.play()
        let actFlyLeft = SKAction.animate(with: self.aShipFlyLeft, timePerFrame: 0.15);
        self.run(SKAction.repeatForever(actFlyLeft))
    }
    
    func fctStartFlyAnimationRight() {
        self.removeAllActions()
        //apThrust.prepareToPlay()
        //apThrust.play()
        let actFlyRight = SKAction.animate(with: self.aShipFlyRight, timePerFrame: 0.15);
        self.run(SKAction.repeatForever(actFlyRight))
    }
    
    func fctExplode() {
        let actExplode = SKAction.animate(with: aExplosion_01, timePerFrame: 0.10)
        self.removeAllActions()
        // --- load sounds ---
        if GameData.blSoundEffectsEnabled == true {
            let path = Bundle.main.path(forResource: "Media/sounds/explosion_002", ofType:"wav")
            let fileURL = URL(fileURLWithPath: path!)
            do {
                let apExplosionSound = try AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
                apExplosionSound.volume = GameData.flSoundsVolume
                apExplosionSound.numberOfLoops = 0
                apExplosionSound.prepareToPlay()
                apExplosionSound.play()
            } catch {
                print("Could not create audio player: \(error)")
                return
            }
        }
        
        self.run(actExplode, completion: {() in
            self.removeFromParent()
            self.blActive = false
        })
    }
}
