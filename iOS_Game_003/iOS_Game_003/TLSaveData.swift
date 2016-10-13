//
//  TLSaveData.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 01.09.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import Foundation

class TLSaveData: NSObject {
    // Options
    var strPlayerName: String
    var blSoundEffectsEnabled: Bool
    var blMusicEnabled: Bool
    var flSoundsVolume: Float
    var flMusicVolume: Float
    // Highscore by time
    var strHighscoreTime: String
    // Highscore by score
    var strHighscoreScore: String
    var userDefaults: UserDefaults
    var iMeteoriteCnt: Int
    var iAchieved: Int
    
    // MARK: Archiving Paths
    
    //static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    //static let ArchiveURL = DocumentsDirectory.appendingPathComponent("SDGameData")
    
    // MARK: Types
    
    //struct PropertyKey {
    //    static let strPlayerNameKey = "strPlayerName"
    //    static let blSoundEffectsKey = "blSoundEffects"
    //    static let blMusicKey = "blMusicKey"
    //    static let flSoundVolumeKey = "flSoundVolume"
    //    static let flMusicVolumeKey = "flMusicVolume"
    //    static let strHighscoreTimeKey = "strHighscoreTime"
    //    static let strHighscoreScoreKey = "strHighscoreScore"
    //}
    
    // MARK: Initialization
    
    init?(strPlayerName: String, blSoundEffectsEnabled: Bool, blMusicEnabled: Bool, flSoundsVolume: Float, flMusicVolume: Float, strHighscoreTime: String, strHighscoreScore: String, iMeteoriteCnt: Int, iAchieved: Int) {
        // Initialize stored properties.
        self.strPlayerName = strPlayerName
        self.blSoundEffectsEnabled = blSoundEffectsEnabled
        self.blMusicEnabled = blMusicEnabled
        self.flSoundsVolume = flSoundsVolume
        self.flMusicVolume = flMusicVolume
        self.strHighscoreTime = strHighscoreTime
        self.strHighscoreScore = strHighscoreScore
        self.iMeteoriteCnt = iMeteoriteCnt
        self.iAchieved = iAchieved
        self.userDefaults = UserDefaults.standard
        
        //super.init()
    }
    
    func fctSaveData() {
        userDefaults.setValue(self.strPlayerName, forKey: "strPlayerName")
        userDefaults.set(self.blSoundEffectsEnabled, forKey: "blSoundEffectsEnabled")
        userDefaults.set(self.blMusicEnabled, forKey: "blMusicEnabled")
        userDefaults.set(self.flSoundsVolume, forKey: "flSoundsVolume")
        userDefaults.set(self.flMusicVolume, forKey: "flMusicVolume")
        userDefaults.setValue(self.strHighscoreTime, forKey: "strHighscoreTime")
        userDefaults.setValue(self.strHighscoreScore, forKey: "strHighscoreScore")
        userDefaults.set(self.iMeteoriteCnt, forKey: "iMeteoriteCnt")
        userDefaults.set(self.iAchieved, forKey: "iAchieved")
        userDefaults.synchronize()
    }
    
    func fctLoadData() {
        //highscore = userDefaults.valueForKey("highscore")
        
        self.strPlayerName = userDefaults.value(forKey: "strPlayerName") as! String
        self.blSoundEffectsEnabled = userDefaults.value(forKey: "blSoundEffectsEnabled") as! Bool
        self.blMusicEnabled = userDefaults.value(forKey: "blMusicEnabled") as! Bool
        self.flSoundsVolume = userDefaults.value(forKey: "flSoundsVolume") as! Float
        self.flMusicVolume = userDefaults.value(forKey: "flMusicVolume") as! Float
        self.strHighscoreTime = userDefaults.value(forKey: "strHighscoreTime") as! String
        self.strHighscoreScore = userDefaults.value(forKey: "strHighscoreScore") as! String
        self.iMeteoriteCnt = userDefaults.value(forKey: "iMeteoriteCnt") as! Int
        self.iAchieved = userDefaults.value(forKey: "iAchieved") as! Int
    }
    
    // MARK: NSCoding
    
   // func encode(with aCoder: NSCoder) {
   //     aCoder.encode(strPlayerName, forKey: PropertyKey.strPlayerNameKey)
   //     aCoder.encode(blSoundEffectsEnabled, forKey: PropertyKey.blSoundEffectsKey)
   //     aCoder.encode(blMusicEnabled, forKey: PropertyKey.blMusicKey)
   //     aCoder.encode(flSoundsVolume, forKey: PropertyKey.flSoundVolumeKey)
   //     aCoder.encode(flMusicVolume, forKey: PropertyKey.flMusicVolumeKey)
   //     aCoder.encode(strHighscoreTime, forKey: PropertyKey.strHighscoreTimeKey)
   //     aCoder.encode(strHighscoreScore, forKey: PropertyKey.strHighscoreScoreKey)
   // }
    
    //required convenience init?(coder aDecoder: NSCoder) {
    //    let strPlayerName = aDecoder.decodeObject(forKey: PropertyKey.strPlayerNameKey) as! String
    //    let blSoundEffectsEnabled = aDecoder.decodeObject(forKey: PropertyKey.blSoundEffectsKey) as! Bool
    //    let blMusicEnabled = aDecoder.decodeObject(forKey: PropertyKey.blMusicKey) as! Bool
    //    let flSoundsVolume = aDecoder.decodeObject(forKey: PropertyKey.flSoundVolumeKey) as! Float
    //    let flMusicVolume = aDecoder.decodeObject(forKey: PropertyKey.flMusicVolumeKey) as! Float
    //    let strHighscoreTime = aDecoder.decodeObject(forKey: PropertyKey.strHighscoreTimeKey) as! String
    //    let strHighscoreScore = aDecoder.decodeObject(forKey: PropertyKey.strHighscoreScoreKey) as! String
        
        // Must call designated initializer.
    //    self.init(strPlayerName: strPlayerName, blSoundEffectsEnabled: blSoundEffectsEnabled, blMusicEnabled: blMusicEnabled, flSoundsVolume: flSoundsVolume, flMusicVolume: flMusicVolume, strHighscoreTime: strHighscoreTime, strHighscoreScore: strHighscoreScore)
    //}
}
