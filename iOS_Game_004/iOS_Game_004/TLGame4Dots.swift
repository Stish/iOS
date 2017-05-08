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
    var aSnDots = Array<Array<SKShapeNode>>()
    var snButtonBack: SKShapeNode!
    var snButtonBackPic: SKSpriteNode!
    var snButtonTwitter: SKShapeNode!
    var snButtonTwitterPic: SKSpriteNode!
    var snButtonRetry: SKShapeNode!
    var snButtonRetryPic: SKSpriteNode!
    var snButtonSound: SKShapeNode!
    var snButtonSoundPic: SKSpriteNode!
    var snButtonScore: SKShapeNode!
    var lbButtonScore: SKLabelNode!
    var snScoreBoard: SKShapeNode!
    var lbScoreBoardLine1: SKLabelNode!
    var lbScoreBoardLine2: SKLabelNode!
    var lbScoreBoardLine3: SKLabelNode!
    var iGame4DotsCnt = Int(4)
    var apC4: AVAudioPlayer!
    var apF4: AVAudioPlayer!
    var apG4: AVAudioPlayer!
    var apC5: AVAudioPlayer!
    var apBack: AVAudioPlayer!
    var iSequence = Array<Int>()
    var iDotsInSequence = Int(0)
    var iNumOfUserInputs = Int(0)
    var blUserInputAllowed = Bool(false)
    // ### Auxiliary var
    var strButtonPressedName = ""
    var blGameStopped = Bool(false)
    //var dwiSequence = Array<DispatchWorkItem>()
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        
        // ### Dots array
        aSnDots.removeAll()
        for x in 0 ..< iDotsCntX {
            var dotCol:[SKShapeNode] = []
            for y in 0 ..< iDotsCntY {
                let dot = SKShapeNode(rectOf: CGSize(width: 48 * flScreenWidthRatio, height: 48 * flScreenHeightRatio), cornerRadius: 5)
                //let dot = SKSpriteNode(texture: SKTexture(imageNamed: "Media/dot_001.png"), color: UIColor.clear, size: CGSize(width: 51 * flScreenWidthRatio, height: 51 * flScreenHeightRatio))
                //dot.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                dot.strokeColor = SKColor.blue
                dot.glowWidth = 0.0
                dot.lineWidth = 0.0
                dot.fillColor = UIColor(red:   CGFloat(arc4random()) / CGFloat(UInt32.max),
                                        green: CGFloat(arc4random()) / CGFloat(UInt32.max),
                                        blue:  CGFloat(arc4random()) / CGFloat(UInt32.max),
                                        alpha: 1.0)
                dot.position = CGPoint(x: CGFloat((x * 2) + 1) * (flScreenWidth / 14), y: CGFloat((y * 2) + 1) * (flScreenHeight / 24))
                dot.zPosition = 1.0
                dot.alpha = 0.2
                dot.name = "Dot"
                self.addChild(dot)
                dotCol.append(dot)
            }
            aSnDots.append(dotCol)
        }
        aSnDots[0][11].alpha = 0.0
        aSnDots[2][11].alpha = 0.0
        aSnDots[3][11].alpha = 0.0
        aSnDots[4][11].alpha = 0.0
        aSnDots[6][11].alpha = 0.0
        aSnDots[2][5].alpha = 0.0
        aSnDots[3][6].alpha = 0.0
        aSnDots[3][4].alpha = 0.0
        aSnDots[4][5].alpha = 0.0
        // ### 4 Dots
        for i in 0 ..< iGame4DotsCnt {
            let dot = SKShapeNode(rectOf: CGSize(width: 48 * flScreenWidthRatio, height: 48 * flScreenHeightRatio), cornerRadius: 5)
            dot.strokeColor = SKColor.blue
            dot.glowWidth = 0.0
            dot.lineWidth = 2.0
            dot.fillColor = SKColor.clear
            //dot.fillColor = UIColor.withAlphaComponent(dot.fillColor)(0.25)
            //dot.position = CGPoint(x: CGFloat((i * 2) + 3) * (flScreenWidth / 14), y: CGFloat(5 * (flScreenWidth / 14)))
            dot.zPosition = 1.0
            dot.alpha = 1.0
            dot.name = "Dot_" +  String(i)
            self.addChild(dot)
            aSnGame4Dots.append(dot)
        }
        //dwiSequence.removeAll()
        blGameStopped = false
        iSequence.removeAll()
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        /*iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))
        iSequence.append(fctRandomInt(min: 0, 3))*/
        iDotsInSequence = iSequence.count
        iNumOfUserInputs = 0
        blUserInputAllowed = false
        // print("##### " + String(iSequence[0])) // #debug
        
        aSnGame4Dots[0].position = CGPoint(x: CGFloat(7 * (flScreenWidth / 14)), y: CGFloat(13 * (flScreenHeight / 24)))
        aSnGame4Dots[0].strokeColor = uiCol1
        //aSnGame4Dots[0].strokeColor = UIColor.withAlphaComponent(aSnGame4Dots[0].strokeColor)(0.8)
        aSnGame4Dots[1].position = CGPoint(x: CGFloat(9 * (flScreenWidth / 14)), y: CGFloat(11 * (flScreenHeight / 24)))
        aSnGame4Dots[1].strokeColor = uiCol4
        aSnGame4Dots[2].position = CGPoint(x: CGFloat(7 * (flScreenWidth / 14)), y: CGFloat(9 * (flScreenHeight / 24)))
        aSnGame4Dots[2].strokeColor = uiCol5
        aSnGame4Dots[3].position = CGPoint(x: CGFloat(5 * (flScreenWidth / 14)), y: CGFloat(11 * (flScreenHeight / 24)))
        aSnGame4Dots[3].strokeColor = uiCol8
        // ### Menu: Back button
        snButtonBack = SKShapeNode(rectOf: CGSize(width: 48 * flScreenWidthRatio, height: 48 * flScreenHeightRatio), cornerRadius: 5)
        snButtonBack.strokeColor = SKColor.gray
        snButtonBack.glowWidth = 0.0
        snButtonBack.lineWidth = 2.0
        snButtonBack.fillColor = SKColor.clear
        snButtonBack.position = CGPoint(x: 1 * (flScreenWidth / 14), y: 23 * (flScreenHeight / 24))
        snButtonBack.zPosition = 1.0
        snButtonBack.alpha = 1.0
        snButtonBack.name = "ButtonBack"
        self.addChild(snButtonBack)
        snButtonBackPic = SKSpriteNode(texture: SKTexture(imageNamed: "Media/button_back_002.png"), color: UIColor.clear, size: CGSize(width: 17 * flScreenWidthRatio, height: 31 * flScreenHeightRatio))
        snButtonBackPic.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snButtonBackPic.position = CGPoint(x: 1 * (flScreenWidth / 14), y: 23 * (flScreenHeight / 24))
        snButtonBackPic.zPosition = 1.0
        snButtonBackPic.alpha = 1.0
        snButtonBackPic.name = "ButtonBack"
        self.addChild(snButtonBackPic)
        // ### Menu: Sound button
        snButtonSound = SKShapeNode(rectOf: CGSize(width: 48 * flScreenWidthRatio, height: 48 * flScreenHeightRatio), cornerRadius: 5)
        snButtonSound.strokeColor = SKColor.gray
        snButtonSound.glowWidth = 0.0
        snButtonSound.lineWidth = 2.0
        snButtonSound.fillColor = SKColor.clear
        snButtonSound.position = CGPoint(x: 13 * (flScreenWidth / 14), y: 23 * (flScreenHeight / 24))
        snButtonSound.zPosition = 1.0
        snButtonSound.alpha = 1.0
        snButtonSound.name = "ButtonSound"
        self.addChild(snButtonSound)
        snButtonSoundPic = SKSpriteNode(texture: SKTexture(imageNamed: "Media/button_sound_off_001.png"), color: UIColor.clear, size: CGSize(width: 48 * flScreenWidthRatio, height: 48 * flScreenHeightRatio))
        snButtonSoundPic.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snButtonSoundPic.position = CGPoint(x: 13 * (flScreenWidth / 14), y: 23 * (flScreenHeight / 24))
        snButtonSoundPic.zPosition = 1.0
        snButtonSoundPic.alpha = 1.0
        snButtonSoundPic.name = "ButtonSound"
        self.addChild(snButtonSoundPic)
        // ### Menu: Score button
        snButtonScore = SKShapeNode(rectOf: CGSize(width: (48 * flScreenWidthRatio) + (4 * (flScreenWidth / 14)), height: 48 * flScreenHeightRatio), cornerRadius: 5)
        snButtonScore.strokeColor = SKColor.gray
        snButtonScore.glowWidth = 0.0
        snButtonScore.lineWidth = 2.0
        snButtonScore.fillColor = UIColor.withAlphaComponent(SKColor.gray)(0.2)
        snButtonScore.position = CGPoint(x: 7 * (flScreenWidth / 14), y: 23 * (flScreenHeight / 24))
        snButtonScore.zPosition = 1.0
        snButtonScore.alpha = 1.0
        snButtonScore.name = "ButtonScore"
        self.addChild(snButtonScore)
        lbButtonScore = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lbButtonScore.text = String(self.iNumOfUserInputs) + "/" + String(iSequence.count)
        lbButtonScore.fontSize = 22 * flScreenWidthRatio
        lbButtonScore.position = CGPoint(x: 7 * (flScreenWidth / 14), y: 23 * (flScreenHeight / 24))
        lbButtonScore.fontColor = UIColor.gray
        lbButtonScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        lbButtonScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        lbButtonScore.zPosition = 1.0
        self.addChild(lbButtonScore)
        // ### Video mode
        if blVideoMode == true {
            snDotClick = SKShapeNode(circleOfRadius: 20)
            snDotClick.strokeColor = SKColor.white
            snDotClick.glowWidth = 0.0
            snDotClick.lineWidth = 0.0
            snDotClick.fillColor = UIColor.withAlphaComponent(SKColor.white)(0.0)
            //snDotClick.position = CGPoint(x: 1 * (flScreenWidth / 14), y: 23 * (flScreenHeight / 24))
            snDotClick.zPosition = 1.0
            snDotClick.alpha = 1.0
            self.addChild(snDotClick)
        }
        // --- Sounds: C4 ---
        var path = Bundle.main.path(forResource: "Media/sounds/c4_004", ofType:"wav")
        var fileURL = URL(fileURLWithPath: path!)
        do {
            try apC4 = AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apC4.numberOfLoops = 0
        // --- Sounds: F4 ---
        path = Bundle.main.path(forResource: "Media/sounds/f4_004", ofType:"wav")
        fileURL = URL(fileURLWithPath: path!)
        do {
            try apF4 = AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apF4.numberOfLoops = 0
        // --- Sounds: G4 ---
        path = Bundle.main.path(forResource: "Media/sounds/g4_004", ofType:"wav")
        fileURL = URL(fileURLWithPath: path!)
        do {
            try apG4 = AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apG4.numberOfLoops = 0
        // --- Sounds: C5 ---
        path = Bundle.main.path(forResource: "Media/sounds/c5_004", ofType:"wav")
        fileURL = URL(fileURLWithPath: path!)
        do {
            try apC5 = AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apC5.numberOfLoops = 0
        // --- Sounds: Back ---
        path = Bundle.main.path(forResource: "Media/sounds/back_004", ofType:"wav")
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
            // print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                // print("AVAudioSession is Active")
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        fctUpdateInterface()
        // ### Start sequence
        fctPlaySequence(seq: iSequence)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            if blVideoMode == true {
                snDotClick.position = location
                //snDotClick.position.y = flScreenHeight - snDotClick.position.y
                fctFadeInOutSKShapeNode(snDotClick, time: 0.15, alpha: 1.0, pause: 0.05)
            }
            strButtonPressedName = ""
            switch (touchedNode.name) {
            case "Dot_0"?:
                if blUserInputAllowed == true {
                    iNumOfUserInputs = iNumOfUserInputs + 1
                    if iSequence[iNumOfUserInputs - 1] == 0 {
                        fctPlaySound(player: apC4)
                        aSnGame4Dots[0].fillColor = uiCol1
                        fctFadeInOutSKShapeNode(aSnGame4Dots[0], time: 0.7, alpha: 1.0, pause: 0.1)
                        self.lbButtonScore.text = String(self.iNumOfUserInputs) + "/" + String(self.iSequence.count)
                    } else {
                        fctShakeShape(shape: aSnGame4Dots[0])
                        fctWrongSeq()
                    }
                    if (iNumOfUserInputs == iSequence.count) && (blGameStopped == false) {
                        fctCorrectSeq()
                        blUserInputAllowed = false
                        iNumOfUserInputs = 0
                        iSequence.append(fctRandomInt(min: 0, 3))
                        iDotsInSequence = iSequence.count
                        fctPlaySequence(seq: iSequence)
                    }
                }
            case "Dot_1"?:
                if blUserInputAllowed == true {
                    iNumOfUserInputs = iNumOfUserInputs + 1
                    if iSequence[iNumOfUserInputs - 1] == 1 {
                        fctPlaySound(player: apF4)
                        aSnGame4Dots[1].fillColor = uiCol4
                        fctFadeInOutSKShapeNode(aSnGame4Dots[1], time: 0.7, alpha: 1.0, pause: 0.1)
                        self.lbButtonScore.text = String(self.iNumOfUserInputs) + "/" + String(self.iSequence.count)
                    } else {
                        fctShakeShape(shape: aSnGame4Dots[1])
                        fctWrongSeq()
                    }
                    if (iNumOfUserInputs == iSequence.count) && (blGameStopped == false) {
                        fctCorrectSeq()
                        blUserInputAllowed = false
                        iNumOfUserInputs = 0
                        iSequence.append(fctRandomInt(min: 0, 3))
                        iDotsInSequence = iSequence.count
                        fctPlaySequence(seq: iSequence)
                    }
                }
            case "Dot_2"?:
                if blUserInputAllowed == true {
                    iNumOfUserInputs = iNumOfUserInputs + 1
                    if iSequence[iNumOfUserInputs - 1] == 2 {
                        fctPlaySound(player: apG4)
                        aSnGame4Dots[2].fillColor = uiCol5
                        fctFadeInOutSKShapeNode(aSnGame4Dots[2], time: 0.7, alpha: 1.0, pause: 0.1)
                        self.lbButtonScore.text = String(self.iNumOfUserInputs) + "/" + String(self.iSequence.count)
                    } else {
                        fctShakeShape(shape: aSnGame4Dots[2])
                        fctWrongSeq()
                    }
                    if (iNumOfUserInputs == iSequence.count) && (blGameStopped == false) {
                        fctCorrectSeq()
                        blUserInputAllowed = false
                        iNumOfUserInputs = 0
                        iSequence.append(fctRandomInt(min: 0, 3))
                        iDotsInSequence = iSequence.count
                        fctPlaySequence(seq: iSequence)
                    }
                }
            case "Dot_3"?:
                if blUserInputAllowed == true {
                    iNumOfUserInputs = iNumOfUserInputs + 1
                    if iSequence[iNumOfUserInputs - 1] == 3 {
                        fctPlaySound(player: apC5)
                        aSnGame4Dots[3].fillColor = uiCol8
                        fctFadeInOutSKShapeNode(aSnGame4Dots[3], time: 0.7, alpha: 1.0, pause: 0.1)
                        self.lbButtonScore.text = String(self.iNumOfUserInputs) + "/" + String(self.iSequence.count)
                    } else {
                        fctShakeShape(shape: aSnGame4Dots[3])
                        fctWrongSeq()
                    }
                    if (iNumOfUserInputs == iSequence.count) && (blGameStopped == false) {
                        fctCorrectSeq()
                        blUserInputAllowed = false
                        iNumOfUserInputs = 0
                        iSequence.append(fctRandomInt(min: 0, 3))
                        iDotsInSequence = iSequence.count
                        fctPlaySequence(seq: iSequence)
                    }
                }
            case "ButtonBack"?:
                snButtonBack.fillColor = UIColor.withAlphaComponent(UIColor.gray)(0.7)
                strButtonPressedName = "ButtonBack"
            case "ButtonSound"?:
                snButtonSound.fillColor = UIColor.withAlphaComponent(UIColor.gray)(0.7)
                strButtonPressedName = "ButtonSound"
            case "ButtonRetry"?:
                snButtonRetry.fillColor = UIColor.withAlphaComponent(UIColor.gray)(0.7)
                strButtonPressedName = "ButtonRetry"
            case "ButtonTwitter"?:
                snButtonTwitter.fillColor = UIColor.withAlphaComponent(uiColTwitter)(0.7)
                strButtonPressedName = "ButtonTwitter"
            default:
                ()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            switch (touchedNode.name) {
            case "ButtonSound"?:
                if strButtonPressedName == "ButtonSound" {
                    if blSoundEffectsEnabled == true {
                        blSoundEffectsEnabled = false
                    } else {
                        blSoundEffectsEnabled = true
                    }
                }
            //fctUpdateInterface()
            case "ButtonBack"?:
                if strButtonPressedName == "ButtonBack" {
//                    if dwiSequence.count > 0 {
//                        for i in 0..<dwiSequence.count {
//                            dwiSequence[i].cancel()
//                        }
//                    }
                    blBackPressed = true
                    fctPlaySound(player: apBack)
                    snButtonBack.fillColor = UIColor.gray
                    fctFadeInOutSKShapeNode(snButtonBack, time: 0.5, alpha: 1.0, pause: 0.1)
                    let transition = SKTransition.crossFade(withDuration: 0.75)
                    let nextScene = GameScene(size: scene!.size)
                    nextScene.scaleMode = .aspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
                    self.removeFromParent()
                }
            case "ButtonRetry"?:
                if (strButtonPressedName == "ButtonRetry") && (blGameStopped == true) {
                    fctPlaySound(player: apBack)
                    //let transition = SKTransition.
                    let transition = SKTransition.crossFade(withDuration: 0.75)
                    let nextScene = TLGame4Dots(size: scene!.size)
                    nextScene.scaleMode = .aspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
                    //DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                    //sleep(1)
                    self.removeFromParent()
                    //}
                }
            case "ButtonTwitter"?:
                if (strButtonPressedName == "ButtonTwitter") && (blGameStopped == true) {
                    fctPlaySound(player: apBack)
                    print("### Twitter") // #debug
                    fctTweet(scene: self)
                }
            default:
                snButtonSound.fillColor = UIColor.withAlphaComponent(UIColor.gray)(0.25)
                snButtonBack.fillColor = UIColor.withAlphaComponent(UIColor.gray)(0.25)
            }
            fctUpdateInterface()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    func fctPlaySequence(seq: Array<Int>) {
        if seq.count == 0 {
            return
        }
        self.blUserInputAllowed = false
        DispatchQueue.global().async {
            usleep(500000)
            for i in 0...seq.count {
                if blBackPressed == true {
                    return
                }
                usleep(700000)
                DispatchQueue.main.async {
                    self.lbButtonScore.text = String(self.iNumOfUserInputs) + "/" + String(self.iSequence.count)
                    if i < seq.count {
                        switch (seq[i]) {
                        case 0:
                            fctPlaySound(player: self.apC4)
                            self.aSnGame4Dots[0].fillColor = uiCol1
                            fctFadeInOutSKShapeNode(self.aSnGame4Dots[0], time: 0.7, alpha: 1.0, pause: 0.1)
                        case 1:
                            fctPlaySound(player: self.apF4)
                            self.aSnGame4Dots[1].fillColor = uiCol4
                            fctFadeInOutSKShapeNode(self.aSnGame4Dots[1], time: 0.7, alpha: 1.0, pause: 0.1)
                        case 2:
                            fctPlaySound(player: self.apG4)
                            self.aSnGame4Dots[2].fillColor = uiCol5
                            fctFadeInOutSKShapeNode(self.aSnGame4Dots[2], time: 0.7, alpha: 1.0, pause: 0.1)
                        case 3:
                            fctPlaySound(player: self.apC5)
                            self.aSnGame4Dots[3].fillColor = uiCol8
                            fctFadeInOutSKShapeNode(self.aSnGame4Dots[3], time: 0.7, alpha: 1.0, pause: 0.1)
                        default:
                            ()
                        }
                    }
                    else {
                        print("#### Sequence finished!")
                        self.blUserInputAllowed = true
                        self.iNumOfUserInputs = 0
                        self.lbButtonScore.text = String(self.iNumOfUserInputs) + "/" + String(seq.count)
                    }
                }
            }
        }
    }
    
//    func fctPlaySequence(seq: Array<Int>) {
//        if seq.count == 0 {
//            return
//        }
//        //var flSec = 0.0
//        self.blUserInputAllowed = false
//        dwiSequence.removeAll()
//        var tTimeNow = NSDate().timeIntervalSince1970
//        for i in 0...seq.count {
//            //flSec = 0.5 * Double(i)
//            //DispatchQueue.main.a
//            dwiSequence.append(DispatchWorkItem {
//                self.lbButtonScore.text = String(self.iNumOfUserInputs) + "/" + String(self.iSequence.count)
//                if i < seq.count {
//                    switch (seq[i]) {
//                    case 0:
//                        //fctPlaySound(player: self.apC4)
//                        self.aSnGame4Dots[0].fillColor = uiCol1
//                        fctFadeInOutSKShapeNode(self.aSnGame4Dots[0], time: 0.7, alpha: 1.0, pause: 0.1)
//                    case 1:
//                        //fctPlaySound(player: self.apF4)
//                        self.aSnGame4Dots[1].fillColor = uiCol4
//                        fctFadeInOutSKShapeNode(self.aSnGame4Dots[1], time: 0.7, alpha: 1.0, pause: 0.1)
//                    case 2:
//                        //fctPlaySound(player: self.apG4)
//                        self.aSnGame4Dots[2].fillColor = uiCol5
//                        fctFadeInOutSKShapeNode(self.aSnGame4Dots[2], time: 0.7, alpha: 1.0, pause: 0.1)
//                    case 3:
//                        //fctPlaySound(player: self.apC5)
//                        self.aSnGame4Dots[3].fillColor = uiCol8
//                        fctFadeInOutSKShapeNode(self.aSnGame4Dots[3], time: 0.7, alpha: 1.0, pause: 0.1)
//                    default:
//                        ()
//                    }
//                }
//                else {
//                    print("#### Sequence finished!")
//                    self.blUserInputAllowed = true
//                    self.iNumOfUserInputs = 0
//                    self.lbButtonScore.text = String(self.iNumOfUserInputs) + "/" + String(seq.count)
//                }
//                print("### " + String(NSDate().timeIntervalSince1970))
//            })
//            //tTimeNow = tTimeNow + (0.7 * Double(i))
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) + .milliseconds(700 * i), execute: dwiSequence[i])
////            if i < seq.count {
////                print("### " + String(seq[i])) // #debug
////            }
//            //let time = DispatchTime.now() + Double(1) + Double(700 * i)
//            //print("###" + String(time))
//        }
//    }
    
    /*func fctPlaySequence(seq: Array<Int>) {
        if seq.count == 0 {
            return
        }
        //var flSec = 0.0
        self.blUserInputAllowed = false
        for i in 0...seq.count {
            //flSec = 0.5 * Double(i)
            //DispatchQueue.main.a
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) + .milliseconds(i * 700)) {
                self.lbButtonScore.text = String(self.iNumOfUserInputs) + "/" + String(self.iSequence.count)
                if i < seq.count {
                    switch (seq[i]) {
                    case 0:
                        fctPlaySound(player: self.apC4)
                        self.aSnGame4Dots[0].fillColor = uiCol1
                        fctFadeInOutSKShapeNode(self.aSnGame4Dots[0], time: 0.7, alpha: 1.0, pause: 0.1)
                    case 1:
                        fctPlaySound(player: self.apF4)
                        self.aSnGame4Dots[1].fillColor = uiCol4
                        fctFadeInOutSKShapeNode(self.aSnGame4Dots[1], time: 0.7, alpha: 1.0, pause: 0.1)
                    case 2:
                        fctPlaySound(player: self.apG4)
                        self.aSnGame4Dots[2].fillColor = uiCol5
                        fctFadeInOutSKShapeNode(self.aSnGame4Dots[2], time: 0.7, alpha: 1.0, pause: 0.1)
                    case 3:
                        fctPlaySound(player: self.apC5)
                        self.aSnGame4Dots[3].fillColor = uiCol8
                        fctFadeInOutSKShapeNode(self.aSnGame4Dots[3], time: 0.7, alpha: 1.0, pause: 0.1)
                    default:
                        ()
                    }
                }
                else {
                    print("#### Sequence finished!")
                    self.blUserInputAllowed = true
                    self.iNumOfUserInputs = 0
                    self.lbButtonScore.text = String(self.iNumOfUserInputs) + "/" + String(seq.count)
                }
            }
        }
        //seq.append(fctRandomInt(min: 0, 3))
    }*/

    
    func fctUpdateInterface() {
        if blSoundEffectsEnabled == true {
            snButtonSoundPic.texture = SKTexture(imageNamed: "Media/button_sound_on_001.png")
        } else {
            snButtonSoundPic.texture = SKTexture(imageNamed: "Media/button_sound_off_001.png")
        }
        snButtonSound.fillColor = UIColor.withAlphaComponent(UIColor.gray)(0.2)
        snButtonBack.fillColor = UIColor.withAlphaComponent(UIColor.gray)(0.2)
        if (snButtonRetry != nil) && (blGameStopped == true) {
            snButtonRetry.fillColor = UIColor.withAlphaComponent(UIColor.gray)(0.2)
        }
        if (snButtonTwitter != nil) && (blGameStopped == true) {
            snButtonTwitter.fillColor = UIColor.withAlphaComponent(uiColTwitter)(0.2)
        }
        //self.lbButtonScore.text = String(self.iNumOfUserInputs) + "/" + String(self.iSequence.count)
    }
    
    func fctCorrectSeq() {
        for x in 0 ..< iDotsCntX {
            for y in 0 ..< iDotsCntY {
                aSnDots[x][y].fillColor = UIColor(red: fctRandomCGFloat(min: 0, 127)/255.0, green: fctRandomCGFloat(min: 127, 255)/255.0, blue: fctRandomCGFloat(min: 0, 127)/255.0, alpha: 1.0)
                //aSnDots[x][y].alpha = 0.5
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            for x in 0 ..< iDotsCntX {
                for y in 0 ..< iDotsCntY {
                    self.aSnDots[x][y].fillColor = UIColor(red: fctRandColor(), green: fctRandColor(), blue: fctRandColor(), alpha: 1.0)
                    //self.aSnDots[x][y].alpha = 0.15
                }
            }
        }
    }
    
    func fctWrongSeq() {
        blGameStopped = true
        for x in 0 ..< iDotsCntX {
            for y in 0 ..< iDotsCntY {
                aSnDots[x][y].fillColor = UIColor(red: fctRandomCGFloat(min: 127, 255)/255.0, green: fctRandomCGFloat(min: 0, 127)/255.0, blue: fctRandomCGFloat(min: 0, 127)/255.0, alpha: 1.0)
                //aSnDots[x][y].alpha = 0.5
            }
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//            for x in 0 ..< iDotsCntX {
//                for y in 0 ..< iDotsCntY {
//                    self.aSnDots[x][y].fillColor = UIColor(red: fctRandColor(), green: fctRandColor(), blue: fctRandColor(), alpha: 1.0)
//                    //self.aSnDots[x][y].alpha = 0.15
//                }
//            }
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(750)) {
            // ### Menu: Score board
            let cgScoreWidth = CGFloat((48 * flScreenWidthRatio) + (8 * (flScreenWidth / 14)))
            let cgScoreHeight = CGFloat((48 * flScreenHeightRatio) + (10 * (flScreenHeight / 24)))
//            let cgScoreWidthDelta = CGFloat(cgScoreWidth / 10)
//            let cgScoreHeightDelta = CGFloat(cgScoreHeight / 10)
//            let cgScoreStartX = CGFloat((((flScreenWidth / 7) - (48 * flScreenWidthRatio)) / 2) + (-5 * (flScreenWidth / 14)))
//            let cgScoreStartY = CGFloat((((flScreenHeight / 12) - (48 * flScreenHeightRatio)) / 2) + (-6 * (flScreenHeight / 24)))
            
            self.snScoreBoard = SKShapeNode(rectOf: CGSize(width: cgScoreWidth, height: cgScoreHeight), cornerRadius: 5)
            //self.snScoreBoard = SKShapeNode(rect: CGRect(x: cgScoreStartX, y: cgScoreStartY, width: cgScoreWidthDelta, height: cgScoreHeightDelta) , cornerRadius: 5)
            self.snScoreBoard.strokeColor = UIColor.withAlphaComponent(uiCol8)(0.5)
            self.snScoreBoard.glowWidth = 0.0
            self.snScoreBoard.lineWidth = 2.0
            self.snScoreBoard.fillColor = UIColor.black //UIColor.withAlphaComponent(uiCol8)(0.2)
            self.snScoreBoard.position = CGPoint(x: 7 * (flScreenWidth / 14), y: 12 * (flScreenHeight / 24))
            self.snScoreBoard.zPosition = 1.0
            self.snScoreBoard.alpha = 0.0
            self.snScoreBoard.name = "ScoreBoard"
            self.addChild(self.snScoreBoard)
            // ### Menu: Score board text line 1
            self.lbScoreBoardLine1 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
            self.lbScoreBoardLine1.text = "Wow! 10 in a row!"
            self.lbScoreBoardLine1.fontSize = 22 * flScreenWidthRatio
            self.lbScoreBoardLine1.position = CGPoint(x: 3 * (flScreenWidth / 14), y: 17 * (flScreenHeight / 24))
            self.lbScoreBoardLine1.fontColor = UIColor.white
            self.lbScoreBoardLine1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            self.lbScoreBoardLine1.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            self.lbScoreBoardLine1.zPosition = 1.0
            self.lbScoreBoardLine1.alpha = 0.0
            self.addChild(self.lbScoreBoardLine1)
            // ### Menu: Score board text line 1
            self.lbScoreBoardLine2 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
            self.lbScoreBoardLine2.text = "Wow! 10 in a row!"
            self.lbScoreBoardLine2.fontSize = 22 * flScreenWidthRatio
            self.lbScoreBoardLine2.position = CGPoint(x: 3 * (flScreenWidth / 14), y: 15 * (flScreenHeight / 24))
            self.lbScoreBoardLine2.fontColor = UIColor.white
            self.lbScoreBoardLine2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            self.lbScoreBoardLine2.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            self.lbScoreBoardLine2.zPosition = 1.0
            self.lbScoreBoardLine2.alpha = 0.0
            self.addChild(self.lbScoreBoardLine2)
            // ### Menu: Score board text line 1
            self.lbScoreBoardLine3 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
            self.lbScoreBoardLine3.text = "Wow! 10 in a row!"
            self.lbScoreBoardLine3.fontSize = 22 * flScreenWidthRatio
            self.lbScoreBoardLine3.position = CGPoint(x: 3 * (flScreenWidth / 14), y: 13 * (flScreenHeight / 24))
            self.lbScoreBoardLine3.fontColor = UIColor.white
            self.lbScoreBoardLine3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            self.lbScoreBoardLine3.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            self.lbScoreBoardLine3.zPosition = 1.0
            self.lbScoreBoardLine3.alpha = 0.0
            self.addChild(self.lbScoreBoardLine3)
            // ### Menu: Back lbScoreBoardLine1
            self.snButtonTwitter = SKShapeNode(rectOf: CGSize(width: 48 * flScreenWidthRatio, height: 48 * flScreenHeightRatio), cornerRadius: 5)
            self.snButtonTwitter.strokeColor = uiColTwitter
            self.snButtonTwitter.glowWidth = 0.0
            self.snButtonTwitter.lineWidth = 2.0
            self.snButtonTwitter.fillColor = UIColor.withAlphaComponent(uiColTwitter)(0.2)
            self.snButtonTwitter.position = CGPoint(x: 5 * (flScreenWidth / 14), y: 9 * (flScreenHeight / 24))
            self.snButtonTwitter.zPosition = 1.0
            self.snButtonTwitter.alpha = 0.0
            self.snButtonTwitter.name = "ButtonTwitter"
            self.addChild(self.snButtonTwitter)
            self.snButtonTwitterPic = SKSpriteNode(texture: SKTexture(imageNamed: "Media/button_twitter_001.png"), color: UIColor.clear, size: CGSize(width: 40 * flScreenWidthRatio, height: 40 * flScreenHeightRatio))
            self.snButtonTwitterPic.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.snButtonTwitterPic.position = CGPoint(x: 5 * (flScreenWidth / 14), y: 9 * (flScreenHeight / 24))
            self.snButtonTwitterPic.zPosition = 1.0
            self.snButtonTwitterPic.alpha = 0.0
            self.snButtonTwitterPic.name = "ButtonTwitter"
            self.addChild(self.snButtonTwitterPic)
            // ### Menu: Back twitter
            self.snButtonRetry = SKShapeNode(rectOf: CGSize(width: 48 * flScreenWidthRatio, height: 48 * flScreenHeightRatio), cornerRadius: 5)
            self.snButtonRetry.strokeColor = SKColor.gray
            self.snButtonRetry.glowWidth = 0.0
            self.snButtonRetry.lineWidth = 2.0
            self.snButtonRetry.fillColor = UIColor.withAlphaComponent(SKColor.gray)(0.2)

            self.snButtonRetry.position = CGPoint(x: 9 * (flScreenWidth / 14), y: 9 * (flScreenHeight / 24))
            self.snButtonRetry.zPosition = 1.0
            self.snButtonRetry.alpha = 0.0
            self.snButtonRetry.name = "ButtonRetry"
            self.addChild(self.snButtonRetry)
            self.snButtonRetryPic = SKSpriteNode(texture: SKTexture(imageNamed: "Media/button_retry_001.png"), color: UIColor.clear, size: CGSize(width: 40 * flScreenWidthRatio, height: 40 * flScreenHeightRatio))
            self.snButtonRetryPic.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.snButtonRetryPic.position = CGPoint(x: 9 * (flScreenWidth / 14), y: 9 * (flScreenHeight / 24))
            self.snButtonRetryPic.zPosition = 1.0
            self.snButtonRetryPic.alpha = 0.0
            self.snButtonRetryPic.name = "ButtonRetry"
            self.addChild(self.snButtonRetryPic)
            DispatchQueue.global().async {
                for i in 0...9 {
                    usleep(40000)
                    DispatchQueue.main.async {
                        self.snScoreBoard.alpha = self.snScoreBoard.alpha + 0.1
                        self.snButtonTwitter.alpha = self.snButtonTwitter.alpha + 0.1
                        self.snButtonTwitterPic.alpha = self.snButtonTwitterPic.alpha + 0.1
                        self.snButtonRetry.alpha = self.snButtonRetry.alpha + 0.1
                        self.snButtonRetryPic.alpha = self.snButtonRetryPic.alpha + 0.1
                        self.lbScoreBoardLine1.alpha = self.lbScoreBoardLine1.alpha + 0.1
                        self.lbScoreBoardLine2.alpha = self.lbScoreBoardLine1.alpha + 0.1
                        self.lbScoreBoardLine3.alpha = self.lbScoreBoardLine1.alpha + 0.1
                        //self.snScoreBoard.path = UIBezierPath(roundedRect: CGRect(x: cgScoreStartX, y: cgScoreStartY, width:  CGFloat(i + 1) * cgScoreWidthDelta, height: CGFloat(i + 1) * cgScoreHeightDelta), cornerRadius: 5).cgPath
                        //self.snScoreBoard.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width:  CGFloat(i + 1) * cgScoreWidthDelta, height: CGFloat(i+1) * cgScoreHeightDelta), cornerRadius: 5).cgPath
                        //self.snScoreBoard.yScale = self.snScoreBoard.yScale + cgScoreHeightDelta
                        }
                    }
                }
            }
        //snScoreBoard
    }
}
