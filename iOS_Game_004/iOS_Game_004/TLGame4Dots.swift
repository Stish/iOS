//
//  TLGame4Dots.swift
//  iOS_Game_004
//
//  Created by Alexander Wegner on 27.04.17.
//  Copyright © 2017 Alexander Wegner. All rights reserved.
//

import SpriteKit
import AVFoundation

class TLGame4Dots: SKScene, SKPhysicsContactDelegate {
    
    var aSnGame4Dots = Array<SKShapeNode>()
    var snButtonBack: SKShapeNode!
    var iGame4DotsCnt = Int(4)
    var apC4: AVAudioPlayer!
    var apF4: AVAudioPlayer!
    var apG4: AVAudioPlayer!
    var apC5: AVAudioPlayer!
    var apBack: AVAudioPlayer!
    var iSequence = Array<Int>()
    var iDotsInSequence = Int(0)
    var iNumOfUseInputs = Int(0)
    var blUserInputAllowed = Bool(false)
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        for i in 0 ..< iGame4DotsCnt {
            let dot = SKShapeNode(rectOf: CGSize(width: 48 * flScreenWidthRatio, height: 48 * flScreenHeightRatio), cornerRadius: 5)
            dot.strokeColor = SKColor.blue
            dot.glowWidth = 0.0
            dot.lineWidth = 2.0
            dot.fillColor = SKColor.clear
            //dot.fillColor = UIColor.withAlphaComponent(dot.fillColor)(0.2)
            //dot.position = CGPoint(x: CGFloat((i * 2) + 3) * (flScreenWidth / 14), y: CGFloat(5 * (flScreenWidth / 14)))
            dot.zPosition = 1.0
            dot.alpha = 1.0
            dot.name = "Dot_" +  String(i)
            self.addChild(dot)
            aSnGame4Dots.append(dot)
        }
        
        iSequence.removeAll()
        iSequence.append(fctRandomInt(min: 0, 3))
        iDotsInSequence = 1
        iNumOfUseInputs = 0
        blUserInputAllowed = false
        // print("##### " + String(iSequence[0])) // #debug
        
        aSnGame4Dots[0].position = CGPoint(x: CGFloat(7 * (flScreenWidth / 14)), y: CGFloat(13 * (flScreenWidth / 14)))
        aSnGame4Dots[0].strokeColor = uiCol1
        //aSnGame4Dots[0].strokeColor = UIColor.withAlphaComponent(aSnGame4Dots[0].strokeColor)(0.8)
        aSnGame4Dots[1].position = CGPoint(x: CGFloat(9 * (flScreenWidth / 14)), y: CGFloat(11 * (flScreenWidth / 14)))
        aSnGame4Dots[1].strokeColor = uiCol4
        aSnGame4Dots[2].position = CGPoint(x: CGFloat(7 * (flScreenWidth / 14)), y: CGFloat(9 * (flScreenWidth / 14)))
        aSnGame4Dots[2].strokeColor = uiCol5
        aSnGame4Dots[3].position = CGPoint(x: CGFloat(5 * (flScreenWidth / 14)), y: CGFloat(11 * (flScreenWidth / 14)))
        aSnGame4Dots[3].strokeColor = uiCol8
        // --- Menu: Back button ---
        snButtonBack = SKShapeNode(rectOf: CGSize(width: 48 * flScreenWidthRatio, height: 48 * flScreenHeightRatio), cornerRadius: 5)
        snButtonBack.strokeColor = SKColor.gray
        snButtonBack.glowWidth = 0.0
        snButtonBack.lineWidth = 2.0
        snButtonBack.fillColor = SKColor.clear
        snButtonBack.position = CGPoint(x: 1 * (flScreenWidth / 14), y: 23 * (flScreenWidth / 14))
        snButtonBack.zPosition = 1.0
        snButtonBack.alpha = 1.0
        snButtonBack.name = "ButtonBack"
        self.addChild(snButtonBack)
        
        // --- Sounds: C4 ---
        var path = Bundle.main.path(forResource: "Media/sounds/c4_002", ofType:"wav")
        var fileURL = URL(fileURLWithPath: path!)
        do {
            try apC4 = AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apC4.numberOfLoops = 0
        // --- Sounds: F4 ---
        path = Bundle.main.path(forResource: "Media/sounds/f4_002", ofType:"wav")
        fileURL = URL(fileURLWithPath: path!)
        do {
            try apF4 = AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apF4.numberOfLoops = 0
        // --- Sounds: G4 ---
        path = Bundle.main.path(forResource: "Media/sounds/g4_002", ofType:"wav")
        fileURL = URL(fileURLWithPath: path!)
        do {
            try apG4 = AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apG4.numberOfLoops = 0
        // --- Sounds: C5 ---
        path = Bundle.main.path(forResource: "Media/sounds/c5_002", ofType:"wav")
        fileURL = URL(fileURLWithPath: path!)
        do {
            try apC5 = AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apC5.numberOfLoops = 0
        // --- Sounds: Back ---
        path = Bundle.main.path(forResource: "Media/sounds/back_001", ofType:"wav")
        fileURL = URL(fileURLWithPath: path!)
        do {
            try apBack = AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apBack.numberOfLoops = 0
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            switch (touchedNode.name) {
            case "Dot_0"?:
                fctPlayC4()
                aSnGame4Dots[0].fillColor = uiCol1
                fctFadeInOutSKShapeNode(aSnGame4Dots[0], time: 0.7, alpha: 1.0, pause: 0.1)
                
                //fctPlaySequence(seq: iSequence)
                //iSequence.append(fctRandomInt(min: 0, 3))
            case "Dot_1"?:
                fctPlayF4()
                aSnGame4Dots[1].fillColor = uiCol4
                fctFadeInOutSKShapeNode(aSnGame4Dots[1], time: 0.7, alpha: 1.0, pause: 0.1)
            case "Dot_2"?:
                fctPlayG4()
                aSnGame4Dots[2].fillColor = uiCol5
                fctFadeInOutSKShapeNode(aSnGame4Dots[2], time: 0.7, alpha: 1.0, pause: 0.1)
            case "Dot_3"?:
                fctPlayC5()
                aSnGame4Dots[3].fillColor = uiCol8
                fctFadeInOutSKShapeNode(aSnGame4Dots[3], time: 0.7, alpha: 1.0, pause: 0.1)
            case "ButtonBack"?:
                fctPlayBack()
                snButtonBack.fillColor = UIColor.gray
                fctFadeInOutSKShapeNode(snButtonBack, time: 0.5, alpha: 1.0, pause: 0.1)
                let transition = SKTransition.fade(with: UIColor.black, duration: 0.5)
                let nextScene = GameScene(size: scene!.size)
                nextScene.scaleMode = .aspectFill
                scene?.view?.presentScene(nextScene, transition: transition)
                self.removeFromParent()
            default:
                ()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    func fctPlayC4() {
        if blSoundEffectsEnabled == true {
            apC4.volume = 1
            apC4.currentTime = 0
            apC4.prepareToPlay()
            apC4.play()
        }
    }
    
    func fctPlayF4() {
        if blSoundEffectsEnabled == true {
            apF4.volume = 1
            apF4.currentTime = 0
            apF4.prepareToPlay()
            apF4.play()
        }
    }
    
    func fctPlayG4() {
        if blSoundEffectsEnabled == true {
            apG4.volume = 1
            apG4.currentTime = 0
            apG4.prepareToPlay()
            apG4.play()
        }
    }
    
    func fctPlayC5() {
        if blSoundEffectsEnabled == true {
            apC5.volume = 1
            apC5.currentTime = 0
            apC5.prepareToPlay()
            apC5.play()
        }
    }
    
    func fctPlayBack() {
        if blSoundEffectsEnabled == true {
            apBack.volume = 1
            apBack.currentTime = 0
            apBack.prepareToPlay()
            apBack.play()
        }
    }
    
    func fctRandomInt(min: Int, _ max: Int) -> Int {
        guard min < max else {return min}
        return Int(arc4random_uniform(UInt32(1 + max - min))) + min
    }
    
    func fctPlaySequence(seq: Array<Int>) {
        if seq.count == 0 {
            return
        }
        //var flSec = 0.0
        self.blUserInputAllowed = false
        for i in 0...seq.count {
            //flSec = 0.5 * Double(i)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(i * 700)) {
                if i < seq.count {
                    switch (seq[i]) {
                    case 0:
                        self.fctPlayC4()
                        self.aSnGame4Dots[0].fillColor = uiCol1
                        self.fctFadeInOutSKShapeNode(self.aSnGame4Dots[0], time: 0.7, alpha: 1.0, pause: 0.1)
                    case 1:
                        self.fctPlayF4()
                        self.aSnGame4Dots[1].fillColor = uiCol4
                        self.fctFadeInOutSKShapeNode(self.aSnGame4Dots[1], time: 0.7, alpha: 1.0, pause: 0.1)
                    case 2:
                        self.fctPlayG4()
                        self.aSnGame4Dots[2].fillColor = uiCol5
                        self.fctFadeInOutSKShapeNode(self.aSnGame4Dots[2], time: 0.7, alpha: 1.0, pause: 0.1)
                    case 3:
                        self.fctPlayC5()
                        self.aSnGame4Dots[3].fillColor = uiCol8
                        self.fctFadeInOutSKShapeNode(self.aSnGame4Dots[3], time: 0.7, alpha: 1.0, pause: 0.1)
                    default:
                        ()
                    }
                }
                else {
                    print("#### Sequence finished!")
                    self.blUserInputAllowed = true
                }
            }
        }
        //seq.append(fctRandomInt(min: 0, 3))
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

}
