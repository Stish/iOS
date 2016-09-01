//
//  TLGameData.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 01.09.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import Foundation

class TLGameData: NSObject {
    // --- Game data and options ---
    // Highscores
    var aHighscoresScore = Array<TLHighscoreMember>()
    var aHighscoresTime = Array<TLHighscoreMember>()
    // Options
    var strPlayerName = "Player"
    var blSoundEffectsEnabled = true
    var blMusicEnabled = true
    var flSoundsVolume = Float(0.5)
    var flMusicVolume = Float(0.5)
    
    
}
