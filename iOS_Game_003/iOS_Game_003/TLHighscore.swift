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
    let dateOfScore:Date;
    
    init(score:Int, dateOfScore:Date) {
        self.score = score;
        self.dateOfScore = dateOfScore;
    }
    
    required init(coder: NSCoder) {
        self.score = coder.decodeObject(forKey: "score")! as! Int;
        self.dateOfScore = coder.decodeObject(forKey: "dateOfScore")! as! Date;
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.score, forKey: "score")
        coder.encode(self.dateOfScore, forKey: "dateOfScore")
    }
}
