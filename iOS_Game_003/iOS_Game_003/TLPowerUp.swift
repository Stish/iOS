//
//  TLPowerUp.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 17.12.15.
//  Copyright © 2015 Alexander Wegner. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class TLPowerUp: SKSpriteNode {
    var blDestroyed = false
    var blActive = false
    var iScore = 300
    var apExplosionSound: AVAudioPlayer!
    var iPowerUp: Int!
    //var blHasPowerUp: Bool!
    
    init(size: CGSize, pos: CGPoint, type: Int) {
        super.init(texture: SKTexture(imageNamed: "Media/pu_shield_001.png"), color: UIColor.clear, size: CGSize(width: size.width, height: size.height))

        switch (type) {
            case 1:
                self.texture = SKTexture(imageNamed: "Media/pu_bomb_001.png")
            case 2:
                self.texture = SKTexture(imageNamed: "Media/pu_shield_001.png")
            case 3:
                self.texture = SKTexture(imageNamed: "Media/pu_wpn_laser_sphere_2.png")
                self.size.width = 40 * (flScreenWidth/667.0)
                self.size.height = 40 * (flScreenHeight/375.0)
                self.iScore = 1000
            case 4:
                self.texture = SKTexture(imageNamed: "Media/pu_wpn_laser_cone_2.png")
                self.size.width = 40 * (flScreenWidth/667.0)
                self.size.height = 40 * (flScreenHeight/375.0)
                self.iScore = 1000
            default:
                ()
        }
        self.iPowerUp = type
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = pos
        // --- physics body ---
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.categoryBitMask = enBodyType.powerup.rawValue
        self.physicsBody?.contactTestBitMask = enBodyType.ship.rawValue
        self.physicsBody?.collisionBitMask = 0
        
        self.fctRotate(4, iDirection: 1)
        self.zPosition = 1.1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fctRotate (_ flRotationSpeed: CGFloat, iDirection: Int) {
        let actRotate = SKAction.rotate(byAngle: CGFloat(Double(iDirection)*M_PI*2.0), duration: 10.0)
        
        run(SKAction.repeatForever(actRotate))
    }
    
    func fctMoveLeft() {
        let actMoveLeft = SKAction.moveBy(x: -(flScreenWidth + 100), y: 0, duration: flmeteoriteSpeed * 2)
        
        run(actMoveLeft, completion: {() in
            self.physicsBody?.categoryBitMask = 0
            self.physicsBody?.contactTestBitMask = 0
            self.removeFromParent()
            self.blActive = false
        })
    }
    
    func fctExplode() {
        self.blDestroyed = true
        iGameScore = iGameScore + iScore
        lbGameScore.text = String(iGameScore)
        self.removeAllActions()
        self.physicsBody?.categoryBitMask = 0
        self.physicsBody?.contactTestBitMask = 0
        self.blActive = false
        self.size.width = 0
        self.size.width = 0
        // --- load sounds ---
        if GameData.blSoundEffectsEnabled == true {
            let path = Bundle.main.path(forResource: "Media/sounds/powerup_001", ofType:"wav")
            let fileURL = URL(fileURLWithPath: path!)
            do {
                apExplosionSound = try AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
                apExplosionSound.volume = GameData.flSoundsVolume
                apExplosionSound.numberOfLoops = 0
                apExplosionSound.prepareToPlay()
                apExplosionSound.play()
            } catch {
                print("Could not create audio player: \(error)")
                return
            }
        }
        // --- Score ---
        let lbScore = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbScore.text = "+" + String(iScore)
        lbScore.fontSize = 30 * (flScreenWidth/667.0)
        lbScore.position = CGPoint(x: 0 + 50, y: 0 - (lbScore.frame.size.height / 2))
        lbScore.fontColor = UIColor(red: 102/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        self.run(SKAction.rotate(toAngle: 0, duration: 0), completion: {() in
            self.addChild(lbScore)
        })
        self.run(SKAction.rotate(toAngle: 0, duration: 0.5), completion: {() in
            self.blActive = false
            self.removeAllActions()
            self.removeFromParent()
        })
    }
}
