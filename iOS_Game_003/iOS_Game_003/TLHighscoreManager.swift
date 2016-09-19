//
//  TLHighscoreManager.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 06.07.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import Foundation

class HighScoreManager {
    var scores:Array<HighScore> = [];
    
    init() {
        // load existing high scores or set up an empty array
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        let path = documentsDirectory + "HighScores.plist"
        let fileManager = FileManager.default
        
        // check if file exists
        if !fileManager.fileExists(atPath: path) {
            // create an empty file if it doesn't exist
            if let bundle = Bundle.main.path(forResource: "DefaultFile", ofType: "plist") {
                do  {
                    try fileManager.copyItem(atPath: bundle, toPath: path)
                }
                catch {
                    //Catch error here
                }
            }
        }
        
        if let rawData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            // do we get serialized data back from the attempted path?
            // if so, unarchive it into an AnyObject, and then convert to an array of HighScores, if possible
            let scoreArray: AnyObject? = NSKeyedUnarchiver.unarchiveObject(with: rawData) as AnyObject?;
            self.scores = scoreArray as? [HighScore] ?? [];
        }
    }
    
    func save() {
        // find the save directory our app has permission to use, and save the serialized version of self.scores - the HighScores array.
        let saveData = NSKeyedArchiver.archivedData(withRootObject: self.scores);
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray;
        let documentsDirectory = paths.object(at: 0) as! NSString;
        let path = documentsDirectory.appendingPathComponent("HighScores.plist");
        
        try? saveData.write(to: URL(fileURLWithPath: path), options: [.atomic]);
    }
    
    // a simple function to add a new high score, to be called from your game logic
    // note that this doesn't sort or filter the scores in any way
    func addNewScore(_ newScore:Int) {
        let newHighScore = HighScore(score: newScore, dateOfScore: Date());
        self.scores.append(newHighScore);
        self.save();
    }
}
