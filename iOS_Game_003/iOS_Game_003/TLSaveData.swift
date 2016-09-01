//
//  TLSaveData.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 01.09.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import Foundation

class TLSaveData: NSObject, NSCoding {
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
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("SDGameData")
    
    // MARK: Types
    
    struct PropertyKey {
        static let strPlayerNameKey = "strPlayerName"
        static let blSoundEffectsKey = "blSoundEffects"
        static let blMusicKey = "blMusicKey"
        static let flSoundVolumeKey = "flSoundVolume"
        static let flMusicVolumeKey = "flMusicVolume"
        static let strHighscoreTimeKey = "strHighscoreTime"
        static let strHighscoreScoreKey = "strHighscoreScore"
    }
    
    // MARK: Initialization
    
    init?(strPlayerName: String, blSoundEffectsEnabled: Bool, blMusicEnabled: Bool, flSoundsVolume: Float, flMusicVolume: Float, strHighscoreTime: String, strHighscoreScore: String) {
        // Initialize stored properties.
        self.strPlayerName = strPlayerName
        self.blSoundEffectsEnabled = blSoundEffectsEnabled
        self.blMusicEnabled = blMusicEnabled
        self.flSoundsVolume = flSoundsVolume
        self.flMusicVolume = flMusicVolume
        self.strHighscoreTime = strHighscoreTime
        self.strHighscoreScore = strHighscoreScore
        
        super.init()
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(strPlayerName, forKey: PropertyKey.strPlayerNameKey)
        aCoder.encodeObject(blSoundEffectsEnabled, forKey: PropertyKey.blSoundEffectsKey)
        aCoder.encodeObject(blMusicEnabled, forKey: PropertyKey.blMusicKey)
        aCoder.encodeObject(flSoundsVolume, forKey: PropertyKey.flSoundVolumeKey)
        aCoder.encodeObject(flMusicVolume, forKey: PropertyKey.flMusicVolumeKey)
        aCoder.encodeObject(strHighscoreTime, forKey: PropertyKey.strHighscoreTimeKey)
        aCoder.encodeObject(strHighscoreScore, forKey: PropertyKey.strHighscoreScoreKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let strPlayerName = aDecoder.decodeObjectForKey(PropertyKey.strPlayerNameKey) as! String
        let blSoundEffectsEnabled = aDecoder.decodeObjectForKey(PropertyKey.blSoundEffectsKey) as! Bool
        let blMusicEnabled = aDecoder.decodeObjectForKey(PropertyKey.blMusicKey) as! Bool
        let flSoundsVolume = aDecoder.decodeObjectForKey(PropertyKey.flSoundVolumeKey) as! Float
        let flMusicVolume = aDecoder.decodeObjectForKey(PropertyKey.flMusicVolumeKey) as! Float
        let strHighscoreTime = aDecoder.decodeObjectForKey(PropertyKey.strHighscoreTimeKey) as! String
        let strHighscoreScore = aDecoder.decodeObjectForKey(PropertyKey.strHighscoreScoreKey) as! String
        
        // Must call designated initializer.
        self.init(strPlayerName: strPlayerName, blSoundEffectsEnabled: blSoundEffectsEnabled, blMusicEnabled: blMusicEnabled, flSoundsVolume: flSoundsVolume, flMusicVolume: flMusicVolume, strHighscoreTime: strHighscoreTime, strHighscoreScore: strHighscoreScore)
    }
}
