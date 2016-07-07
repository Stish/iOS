//
//  TLHighscore.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 06.07.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import Foundation

class HighScore: NSObject, NSCoding {
    let score:Int;
    let dateOfScore:NSDate;
    
    init(score:Int, dateOfScore:NSDate) {
        self.score = score;
        self.dateOfScore = dateOfScore;
    }
    
    required init(coder: NSCoder) {
        self.score = coder.decodeObjectForKey("score")! as! Int;
        self.dateOfScore = coder.decodeObjectForKey("dateOfScore")! as! NSDate;
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.score, forKey: "score")
        coder.encodeObject(self.dateOfScore, forKey: "dateOfScore")
    }
}
