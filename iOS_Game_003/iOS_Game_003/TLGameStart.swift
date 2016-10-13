//
//  TLGameStart.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 06.07.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import SpriteKit
import AVFoundation

var gzGame: GameScene!

class TLGameStart: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        // --- Loading Game Data ---
        fctLoadGameData()
        // --- collision setup ---
        physicsWorld.contactDelegate = self
        view.showsPhysics = false // #debug
        
        flScreenWidth = view.frame.size.width
        flScreenHeight = view.frame.size.height
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        let flLogoRatio: CGFloat
        let txLogo = SKTexture(imageNamed: "Media/tinylabs_logo_04.png")
        flLogoRatio = txLogo.size().width / txLogo.size().height
        
        let snlogo = SKSpriteNode(texture: txLogo, color: UIColor.clear, size: CGSize(width: 550 * (self.frame.width/667.0), height: 550 * (self.frame.height/375.0) / flLogoRatio))
        snlogo.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snlogo.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        snlogo.zPosition = 1.0
        snlogo.alpha = 1.0
        addChild(snlogo)
        
        //let time = DispatchTime(uptimeNanoseconds: UInt64(DispatchTime.now())) + Double(2 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        
        
        //DispatchQueue.main.asyncAfter(deadline: time) {
          //  let transition = SKTransition.fade(with: .black(), duration: 2)
            
            //let nextScene = TLGameMenu(size: self.scene!.size)
            //nextScene.scaleMode = .aspectFill
            
            //self.scene?.view?.presentScene(nextScene, transition: transition)
        //}
        
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            let transition = SKTransition.fade(with: .black, duration: 2)
            
            let nextScene = TLGameMenu(size: self.scene!.size)
            nextScene.scaleMode = .aspectFill
            
            self.scene?.view?.presentScene(nextScene, transition: transition)
        })
        
        self.removeFromParent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
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
            SDGameData = TLSaveData(strPlayerName: GameData.strPlayerName, blSoundEffectsEnabled: GameData.blSoundEffectsEnabled, blMusicEnabled: GameData.blMusicEnabled, flSoundsVolume: GameData.flSoundsVolume, flMusicVolume: GameData.flMusicVolume, strHighscoreTime: strHighscoreDummy, strHighscoreScore: strHighscoreDummy, iMeteoriteCnt: GameData.iMeteoriteCnt, iAchieved: GameData.iAchieved)
            SDGameData.fctLoadData()
        }
        else {
            SDGameData = TLSaveData(strPlayerName: GameData.strPlayerName, blSoundEffectsEnabled: GameData.blSoundEffectsEnabled, blMusicEnabled: GameData.blMusicEnabled, flSoundsVolume: GameData.flSoundsVolume, flMusicVolume: GameData.flMusicVolume, strHighscoreTime: strHighscoreDummy, strHighscoreScore: strHighscoreDummy, iMeteoriteCnt: GameData.iMeteoriteCnt, iAchieved: GameData.iAchieved)
            SDGameData.fctSaveData()
        }
        GameData.strPlayerName = SDGameData.strPlayerName
        GameData.blSoundEffectsEnabled = SDGameData.blSoundEffectsEnabled
        GameData.blMusicEnabled = SDGameData.blMusicEnabled
        GameData.flSoundsVolume = SDGameData.flSoundsVolume
        GameData.flMusicVolume = SDGameData.flMusicVolume
        GameData.iMeteoriteCnt = SDGameData.iMeteoriteCnt
        GameData.iAchieved = SDGameData.iAchieved
        let aStrHighscoreTime = SDGameData.strHighscoreTime.components(separatedBy: "\t")
        for row in 0...(aStrHighscoreTime.count / 3) - 1 {
            GameData.aHighscoresTime[row].iScore = Int(aStrHighscoreTime[(row*3) + 0])
            GameData.aHighscoresTime[row].iTime = Int(aStrHighscoreTime[(row*3) + 1])
            GameData.aHighscoresTime[row].strName = aStrHighscoreTime[(row*3) + 2]
        }
        let aStrHighscoreScore = SDGameData.strHighscoreScore.components(separatedBy: "\t")
        for row in 0...(aStrHighscoreTime.count / 3) - 1 {
            GameData.aHighscoresScore[row].iScore = Int(aStrHighscoreScore[(row*3) + 0])
            GameData.aHighscoresScore[row].iTime = Int(aStrHighscoreScore[(row*3) + 1])
            GameData.aHighscoresScore[row].strName = aStrHighscoreScore[(row*3) + 2]
        }
        /*
        if blResetGameData == false {
            do {
                //try SDGameData = NSKeyedUnarchiver.unarchiveObject(withFile: TLSaveData.ArchiveURL.path) as? TLSaveData
                try SDGameData.fctLoadData()
                //print("Path: " + TLSaveData.ArchiveURL.path!) // #debug
                if (SDGameData != nil) {
                    GameData.strPlayerName = SDGameData.strPlayerName
                    GameData.blSoundEffectsEnabled = SDGameData.blSoundEffectsEnabled
                    GameData.blMusicEnabled = SDGameData.blMusicEnabled
                    GameData.flSoundsVolume = SDGameData.flSoundsVolume
                    GameData.flMusicVolume = SDGameData.flMusicVolume
                    let aStrHighscoreTime = SDGameData.strHighscoreTime.components(separatedBy: "\t")
                    for row in 0...(aStrHighscoreTime.count / 3) - 1 {
                        GameData.aHighscoresTime[row].iScore = Int(aStrHighscoreTime[(row*3) + 0])
                        GameData.aHighscoresTime[row].iTime = Int(aStrHighscoreTime[(row*3) + 1])
                        GameData.aHighscoresTime[row].strName = aStrHighscoreTime[(row*3) + 2]
                    }
                    let aStrHighscoreScore = SDGameData.strHighscoreScore.components(separatedBy: "\t")
                    for row in 0...(aStrHighscoreTime.count / 3) - 1 {
                        GameData.aHighscoresScore[row].iScore = Int(aStrHighscoreScore[(row*3) + 0])
                        GameData.aHighscoresScore[row].iTime = Int(aStrHighscoreScore[(row*3) + 1])
                        GameData.aHighscoresScore[row].strName = aStrHighscoreScore[(row*3) + 2]
                    }
                } else {
                    SDGameData = TLSaveData(strPlayerName: GameData.strPlayerName, blSoundEffectsEnabled: GameData.blSoundEffectsEnabled, blMusicEnabled: GameData.blMusicEnabled, flSoundsVolume: GameData.flSoundsVolume, flMusicVolume: GameData.flMusicVolume, strHighscoreTime: strHighscoreDummy, strHighscoreScore: strHighscoreDummy)
                    //NSKeyedArchiver.archiveRootObject(SDGameData, toFile: TLSaveData.ArchiveURL.path)
                    SDGameData.fctSaveData()
                }
            } catch {
                SDGameData = TLSaveData(strPlayerName: GameData.strPlayerName, blSoundEffectsEnabled: GameData.blSoundEffectsEnabled, blMusicEnabled: GameData.blMusicEnabled, flSoundsVolume: GameData.flSoundsVolume, flMusicVolume: GameData.flMusicVolume, strHighscoreTime: strHighscoreDummy, strHighscoreScore: strHighscoreDummy)
                //NSKeyedArchiver.archiveRootObject(SDGameData, toFile: TLSaveData.ArchiveURL.path)
                SDGameData.fctSaveData()
            }
        } else {
            SDGameData = TLSaveData(strPlayerName: GameData.strPlayerName, blSoundEffectsEnabled: GameData.blSoundEffectsEnabled, blMusicEnabled: GameData.blMusicEnabled, flSoundsVolume: GameData.flSoundsVolume, flMusicVolume: GameData.flMusicVolume, strHighscoreTime: strHighscoreDummy, strHighscoreScore: strHighscoreDummy)
            //NSKeyedArchiver.archiveRootObject(SDGameData, toFile: TLSaveData.ArchiveURL.path)
            SDGameData.fctSaveData()
        }
 */
        let testString = "Stish" + "\t" + "1234" + "\t" + "5678"
        let testStringArr = testString.components(separatedBy: "\t")
        //print("Name: " + testStringArr[0]) // #debug
        //print("Time: " + testStringArr[1]) // #debug
        //print("Score: " + testStringArr[2]) // #debug
        
        // Highscore by score array
    }
    
}
