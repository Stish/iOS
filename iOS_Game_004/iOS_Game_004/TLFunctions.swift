//
//  TLFunctions.swift
//  iOS_Game_004
//
//  Created by Alexander Wegner on 05.05.17.
//  Copyright © 2017 Alexander Wegner. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import Social

func fctTweet(scene: SKScene) {
    if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
        // 2
        let tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        // 3
        tweetSheet?.setInitialText("Test Tweet")
        scene.view?.window?.rootViewController?.present(tweetSheet!, animated: true, completion: nil)
    } else {
        // 5
        print("error")
    }
}

func fctRandomInt(min: Int, _ max: Int) -> Int {
    guard min < max else {return min}
    return Int(arc4random_uniform(UInt32(1 + max - min))) + min
}

func fctRandomCGFloat(min: Int, _ max: Int) -> CGFloat {
    guard min < max else {return CGFloat(min)}
    return CGFloat(Int(arc4random_uniform(UInt32(1 + max - min))) + min)
}

func fctRandColor() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
}

func fctShakeShape(shape: SKShapeNode) {
    let actMoveLeft = SKAction.moveBy(x: -4, y: 0, duration: 0.03)
    let actMoveRight = SKAction.moveBy(x: 4, y: 0, duration: 0.03)
    let actMoveUp = SKAction.moveBy(x: 0, y: 4, duration: 0.03)
    let actMoveDown = SKAction.moveBy(x: 0, y: -4, duration: 0.03)
    let actRotateLeft = SKAction.rotate(byAngle: -0.15, duration: 0.03)
    let actRotateRight = SKAction.rotate(byAngle: 0.15, duration: 0.03)
    //let resetPosition = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0)
    let seqMoveLeft = SKAction.sequence([actMoveLeft, actRotateLeft, actMoveRight, actMoveRight, actRotateRight, actRotateRight, actMoveLeft, actMoveUp, actRotateLeft, actRotateLeft, actMoveDown, actMoveDown, actRotateRight, actMoveUp])
    shape.run(SKAction.repeat(seqMoveLeft, count: 1))
}

func fctPlaySound(player: AVAudioPlayer) {
    if blSoundEffectsEnabled == true {
        player.volume = 1
        player.currentTime = 0
        player.prepareToPlay()
        player.play()
    }
}

func fctFadeInOutSKShapeNode (_ node: SKShapeNode, time: TimeInterval, alpha: CGFloat, pause: TimeInterval) {
    //node.alpha = 0.0
    
    let deltaAlpha = alpha/5
    let deltaTime = time/10
    var sumAlpha = CGFloat(0.0)
    
    node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
    
    node.removeAllActions()
    node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
        sumAlpha = sumAlpha + deltaAlpha
        node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
        node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
            sumAlpha = sumAlpha + deltaAlpha
            node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
            node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                sumAlpha = sumAlpha + deltaAlpha
                node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                    sumAlpha = sumAlpha + deltaAlpha
                    node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                    node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                        sumAlpha = sumAlpha + deltaAlpha
                        node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                        node.run(SKAction.rotate(toAngle: 0, duration: pause), completion: {() in
                            // Pause
                            node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                                // Fade out
                                sumAlpha = sumAlpha - deltaAlpha
                                node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                                node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                                    sumAlpha = sumAlpha - deltaAlpha
                                    node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                                    node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                                        sumAlpha = sumAlpha - deltaAlpha
                                        node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                                        node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                                            sumAlpha = sumAlpha - deltaAlpha
                                            node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                                            node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                                                sumAlpha = sumAlpha - deltaAlpha
                                                node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                                                node.removeAllActions()
                                                //print("finish!!") // #debug
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        })
    })
}

