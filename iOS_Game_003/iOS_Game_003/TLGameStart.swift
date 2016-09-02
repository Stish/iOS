//
//  TLGameStart.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 06.07.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import SpriteKit
import AVFoundation

class TLGameStart: SKScene, SKPhysicsContactDelegate {
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        // --- Loading Game Data ---
        fctLoadGameData()
        // --- collision setup ---
        physicsWorld.contactDelegate = self
        view.showsPhysics = false // #debug
        
        flScreenWidth = view.frame.size.width
        flScreenHeight = view.frame.size.height
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        self.anchorPoint = CGPointMake(0, 0)
        
        let flLogoRatio: CGFloat
        let txLogo = SKTexture(imageNamed: "Media/tinylabs_logo_04.png")
        flLogoRatio = txLogo.size().width / txLogo.size().height
        
        let snlogo = SKSpriteNode(texture: txLogo, color: UIColor.clearColor(), size: CGSizeMake(550 * (self.frame.width/667.0), 550 * (self.frame.height/375.0) / flLogoRatio))
        snlogo.anchorPoint = CGPointMake(0.5, 0.5)
        snlogo.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        snlogo.zPosition = 1.0
        snlogo.alpha = 1.0
        addChild(snlogo)
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            let transition = SKTransition.fadeWithColor(.blackColor(), duration: 2)
            
            let nextScene = TLGameMenu(size: self.scene!.size)
            nextScene.scaleMode = .AspectFill
            
            self.scene?.view?.presentScene(nextScene, transition: transition)
        }
        self.removeFromParent()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    func fctLoadGameData() {
        GameData = TLGameData()
        GameData.aHighscoresScore.removeAll()
        GameData.aHighscoresTime.removeAll()
        for row in 0...aSkHighscoresRows - 1 {
            GameData.aHighscoresScore.append(TLHighscoreMember())
            GameData.aHighscoresTime.append(TLHighscoreMember())
        }
        if blResetGameData == false {
            do {
                try SDGameData = NSKeyedUnarchiver.unarchiveObjectWithFile(TLSaveData.ArchiveURL.path!) as? TLSaveData
                //print("Path: " + TLSaveData.ArchiveURL.path!) // #debug
                if (SDGameData != nil) {
                    GameData.strPlayerName = SDGameData.strPlayerName
                    GameData.blSoundEffectsEnabled = SDGameData.blSoundEffectsEnabled
                    GameData.blMusicEnabled = SDGameData.blMusicEnabled
                    GameData.flSoundsVolume = SDGameData.flSoundsVolume
                    GameData.flMusicVolume = SDGameData.flMusicVolume
                    let aStrHighscoreTime = SDGameData.strHighscoreTime.componentsSeparatedByString("\t")
                    for row in 0...(aStrHighscoreTime.count / 3) - 1 {
                        GameData.aHighscoresTime[row].iScore = Int(aStrHighscoreTime[(row*3) + 0])
                        GameData.aHighscoresTime[row].iTime = Int(aStrHighscoreTime[(row*3) + 1])
                        GameData.aHighscoresTime[row].strName = aStrHighscoreTime[(row*3) + 2]
                    }
                    let aStrHighscoreScore = SDGameData.strHighscoreScore.componentsSeparatedByString("\t")
                    for row in 0...(aStrHighscoreTime.count / 3) - 1 {
                        GameData.aHighscoresScore[row].iScore = Int(aStrHighscoreScore[(row*3) + 0])
                        GameData.aHighscoresScore[row].iTime = Int(aStrHighscoreScore[(row*3) + 1])
                        GameData.aHighscoresScore[row].strName = aStrHighscoreScore[(row*3) + 2]
                    }
                } else {
                    SDGameData = TLSaveData(strPlayerName: GameData.strPlayerName, blSoundEffectsEnabled: GameData.blSoundEffectsEnabled, blMusicEnabled: GameData.blMusicEnabled, flSoundsVolume: GameData.flSoundsVolume, flMusicVolume: GameData.flMusicVolume, strHighscoreTime: strHighscoreDummy, strHighscoreScore: strHighscoreDummy)
                    NSKeyedArchiver.archiveRootObject(SDGameData, toFile: TLSaveData.ArchiveURL.path!)
                }
            } catch {
                SDGameData = TLSaveData(strPlayerName: GameData.strPlayerName, blSoundEffectsEnabled: GameData.blSoundEffectsEnabled, blMusicEnabled: GameData.blMusicEnabled, flSoundsVolume: GameData.flSoundsVolume, flMusicVolume: GameData.flMusicVolume, strHighscoreTime: strHighscoreDummy, strHighscoreScore: strHighscoreDummy)
                NSKeyedArchiver.archiveRootObject(SDGameData, toFile: TLSaveData.ArchiveURL.path!)
            }
        } else {
            SDGameData = TLSaveData(strPlayerName: GameData.strPlayerName, blSoundEffectsEnabled: GameData.blSoundEffectsEnabled, blMusicEnabled: GameData.blMusicEnabled, flSoundsVolume: GameData.flSoundsVolume, flMusicVolume: GameData.flMusicVolume, strHighscoreTime: strHighscoreDummy, strHighscoreScore: strHighscoreDummy)
            NSKeyedArchiver.archiveRootObject(SDGameData, toFile: TLSaveData.ArchiveURL.path!)
        }
        let testString = "Stish" + "\t" + "1234" + "\t" + "5678"
        let testStringArr = testString.componentsSeparatedByString("\t")
        print("Name: " + testStringArr[0])
        print("Time: " + testStringArr[1])
        print("Score: " + testStringArr[2])
        
        // Highscore by score array
    }
    
}
