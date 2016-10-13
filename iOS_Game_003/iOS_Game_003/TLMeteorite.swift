//
//  TLMeteorite.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 17.12.15.
//  Copyright © 2015 Alexander Wegner. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class TLMeteorite: SKSpriteNode {
    var blDestroyed = false
    var blActive = false
    var iHealth = 100
    var iScore = 100
    var iDamage = 100
    var apExplosionSound: AVAudioPlayer!
    var apHitSound: AVAudioPlayer!
    //var blHasPowerUp: Bool!
    var iPowerUp = 0
    var blInBombRadius: Bool!
    
    init(size: CGSize, rotSpeed: CGFloat, rotDirec: Int) {
        super.init(texture: SKTexture(imageNamed: "Media/objects/meteorite_001.png"), color: UIColor.clear, size: CGSize(width: size.width, height: size.height))
        // Different textures
        //blHasPowerUp = false
        blInBombRadius = false
        iPowerUp = 0
        switch (arc4random_uniform(UInt32(100)) + 1) {
        case 1...30:
            self.texture = SKTexture(imageNamed: "Media/objects/meteorite_001.png")
        case 31...60:
            self.texture = SKTexture(imageNamed: "Media/objects/meteorite_002.png")
        case 61...90:
            self.texture = SKTexture(imageNamed: "Media/objects/meteorite_003.png")
        case 91...93:
            self.texture = SKTexture(imageNamed: "Media/objects/meteorite_004.png")
            iHealth = 200
            iDamage = 200
            iScore = 500
            //blHasPowerUp = true
            iPowerUp = Int(arc4random_uniform(UInt32(4)) + 1)
            //print("PowerUp Type: " + String(iPowerUp)) // #debug
        case 94...96:
            self.texture = SKTexture(imageNamed: "Media/objects/meteorite_005.png")
            iHealth = 200
            iScore = 500
            iDamage = 200
            //blHasPowerUp = true
            iPowerUp = Int(arc4random_uniform(UInt32(4)) + 1)
            //print("PowerUp Type: " + String(iPowerUp)) // #debug
        case 97...100:
            self.texture = SKTexture(imageNamed: "Media/objects/meteorite_006.png")
            iHealth = 200
            iScore = 500
            iDamage = 200
            //blHasPowerUp = true
            iPowerUp = Int(arc4random_uniform(UInt32(4)) + 1)
            //print("PowerUp Type: " + String(iPowerUp)) // #debug
        default:
            ()
        }
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = CGPoint(x: flScreenWidth + 88/2, y: CGFloat(arc4random_uniform(UInt32(flScreenHeight)) + 1))
        // --- physics body ---
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.categoryBitMask = enBodyType.meteorite.rawValue
        self.physicsBody?.contactTestBitMask = enBodyType.laser.rawValue | enBodyType.ship.rawValue | enBodyType.meteorite.rawValue
        self.physicsBody?.collisionBitMask = 0
        
        self.fctRotate(rotSpeed, iDirection: rotDirec)
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
        let actMoveLeft = SKAction.moveBy(x: -(flScreenWidth + 100), y: 0, duration: flmeteoriteSpeed)

        run(actMoveLeft, completion: {() in
            self.physicsBody?.categoryBitMask = 0
            self.physicsBody?.contactTestBitMask = 0
            self.removeFromParent()
            self.blActive = false
        })
    }
    
    func fctExplode() {
        let actExplode = SKAction.animate(with: aExplosion_01, timePerFrame: 0.10)
        self.blDestroyed = true
        iGameScore = iGameScore + iScore
        lbGameScore.text = String(iGameScore)
        self.removeAllActions()
        self.physicsBody?.categoryBitMask = 0
        self.physicsBody?.contactTestBitMask = 0
        // --- load sounds ---
        if GameData.blSoundEffectsEnabled == true {
            let path = Bundle.main.path(forResource: "Media/sounds/explosion_004", ofType:"wav")
            let fileURL = URL(fileURLWithPath: path!)
            do {
                apExplosionSound = try AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
                apExplosionSound.volume = GameData.flSoundsVolume * 3
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
        lbScore.position = CGPoint(x: 0, y: 0 - (lbScore.frame.size.height / 2))
        lbScore.fontColor = UIColor.orange
        self.run(SKAction.rotate(toAngle: 0, duration: 0), completion: {() in
            self.addChild(lbScore)
        })
        // --- Achievement ---
        GameData.iMeteoriteCnt = GameData.iMeteoriteCnt + 1
        print("### Asteroids destroyed: " + String(GameData.iMeteoriteCnt)) // #debug
        
        self.run(actExplode, completion: {() in
            lbScore.removeFromParent()
            self.blActive = false
            self.removeAllActions()
            self.removeFromParent()
            self.iPowerUp = 0
        })
    }
    
    func fctHit() {
        // --- load sounds ---
        if GameData.blSoundEffectsEnabled == true {
            let path = Bundle.main.path(forResource: "Media/sounds/hit_001", ofType:"mp3")
            let fileURL = URL(fileURLWithPath: path!)
            do {
                apHitSound = try AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
                apHitSound.numberOfLoops = 0
                apHitSound.volume = GameData.flSoundsVolume
                apHitSound.prepareToPlay()
                apHitSound.play()
            } catch {
                print("Could not create audio player: \(error)")
                return
            }
        }
    }
}
