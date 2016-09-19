//
//  TLGameMenuHighscore.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 07.07.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import SpriteKit
import AVFoundation

class TLGameMenuHighscore: SKScene, SKPhysicsContactDelegate {
    var lbMenuHighscore: SKLabelNode!
    var snMenuHighscore: SKSpriteNode!
    var snMenuBack: SKSpriteNode!
    var snHighscoreSwitchScore: SKSpriteNode!
    var snHighscoreSwitchTime: SKSpriteNode!
    var lbHighscoreSwitchScore: SKLabelNode!
    var lbHighscoreSwitchTime: SKLabelNode!
    var lbHighscoreHeadRank: SKLabelNode!
    var lbHighscoreHeadScore: SKLabelNode!
    var lbHighscoreHeadTime: SKLabelNode!
    var lbHighscoreHeadName: SKLabelNode!
    var aSkHighscores = Array<Array<SKLabelNode>>()

    var iButtonPressed: Int!
    var apClick: AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        self.anchorPoint = CGPoint(x: 0, y: 0)
        let txGameMenuBackgrd = SKTexture(imageNamed: "Media/gamemenu_003.png")
        
        let snGameMenuBackgrd = SKSpriteNode(texture: txGameMenuBackgrd, color: UIColor.clear, size: CGSize(width: self.frame.width, height: self.frame.height))
        snGameMenuBackgrd.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snGameMenuBackgrd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        snGameMenuBackgrd.zPosition = 1.0
        snGameMenuBackgrd.alpha = 1.0
        addChild(snGameMenuBackgrd)
        // --- Highscore arrays ---
        // Highscore label array
        aSkHighscores.removeAll()
        for column in 0...aSkHighscoresColumns - 1 {
            aSkHighscores.append(Array(repeating: SKLabelNode(), count: aSkHighscoresRows))
        }
        for column in 0...aSkHighscoresColumns - 1 {
            for row in 0...aSkHighscoresRows - 1 {
                aSkHighscores[column][row] = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
                aSkHighscores[column][row].horizontalAlignmentMode = .center;
                aSkHighscores[column][row].verticalAlignmentMode = .center
                aSkHighscores[column][row].fontSize = 26 * (self.frame.width/667.0)
                aSkHighscores[column][row].fontColor = UIColor.white
                aSkHighscores[column][row].zPosition = 1.0
                self.addChild(aSkHighscores[column][row])
                if column == 0 {
                    aSkHighscores[column][row].text = String(row + 1)
                    aSkHighscores[column][row].position = CGPoint(x: 3*(self.frame.width / 30), y: CGFloat(5-row)*(self.frame.height / 12))
                }
                if column == 1 {
                    aSkHighscores[column][row].text = String(GameData.aHighscoresScore[row].iScore)
                    aSkHighscores[column][row].position = CGPoint(x: 8.5*(self.frame.width / 30), y: CGFloat(5-row)*(self.frame.height / 12))
                }
                if column == 2 {
                    aSkHighscores[column][row].text = String(GameData.aHighscoresScore[row].iTime)
                    aSkHighscores[column][row].position = CGPoint(x: 15*(self.frame.width / 30), y: CGFloat(5-row)*(self.frame.height / 12))
                }
                if column == 3 {
                    aSkHighscores[column][row].text = GameData.aHighscoresScore[row].strName
                    aSkHighscores[column][row].position = CGPoint(x: 23*(self.frame.width / 30), y: CGFloat(5-row)*(self.frame.height / 12))
                }
            }
        }
        fctUpdateHighscoreTable()
        
        // Menu sprite size
        let flMenuSpriteWidth = (SKTexture(imageNamed: "Media/menu_headline.png").size().width) * (self.frame.width/667.0)
        let flMenuSpriteHeight = (SKTexture(imageNamed: "Media/menu_headline.png").size().height) * (self.frame.height/375.0)
        let flMenuBackSpriteWidth = (SKTexture(imageNamed: "Media/menu_back.png").size().width) * (self.frame.width/667.0)
        let flMenuBackSpriteHeight = (SKTexture(imageNamed: "Media/menu_back.png").size().height) * (self.frame.height/375.0)
        let flHighscoreCheckboxWidth = 0.9*(SKTexture(imageNamed: "Media/checkbox_checked.png").size().width) * (self.frame.width/667.0)
        let flHighscoreCheckboxHeight = 0.9*(SKTexture(imageNamed: "Media/checkbox_checked.png").size().height) * (self.frame.height/375.0)
        // Menu "Highscore" Sprite
        snMenuHighscore = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_headline.png"), color: UIColor.clear, size: CGSize(width: flMenuSpriteWidth, height: flMenuSpriteHeight))
        snMenuHighscore.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        snMenuHighscore.position = CGPoint(x: 15*(self.frame.width / 16), y: 10*(self.frame.height / 12))
        snMenuHighscore.zPosition = 1.0
        snMenuHighscore.alpha = 1.0
        snMenuHighscore.name = "MenuHighscore"
        addChild(snMenuHighscore)
        // Menu "Highscore" Text
        lbMenuHighscore = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuHighscore.horizontalAlignmentMode = .center;
        lbMenuHighscore.verticalAlignmentMode = .center
        lbMenuHighscore.text = "HIGHSCORE"
        lbMenuHighscore.fontSize = 30 * (self.frame.width/667.0)
        lbMenuHighscore.position = CGPoint(x: snMenuHighscore.frame.midX, y: 10*(self.frame.height / 12))
        lbMenuHighscore.fontColor = UIColor.white
        lbMenuHighscore.zPosition = 1.0
        lbMenuHighscore.name = "MenuHighscore"
        self.addChild(lbMenuHighscore)
        // Menu "Back" Sprite
        snMenuBack = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_back.png"), color: UIColor.clear, size: CGSize(width: flMenuBackSpriteWidth, height: flMenuBackSpriteHeight))
        snMenuBack.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        snMenuBack.position = CGPoint(x: 1*(self.frame.width / 16), y: 10*(self.frame.height / 12))
        snMenuBack.zPosition = 1.0
        snMenuBack.alpha = 1.0
        snMenuBack.name = "MenuBack"
        self.addChild(snMenuBack)
        // --- Hishscore switch time/score ---
        // "Score" Text
        lbHighscoreSwitchScore = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbHighscoreSwitchScore.horizontalAlignmentMode = .left;
        lbHighscoreSwitchScore.verticalAlignmentMode = .center
        lbHighscoreSwitchScore.text = "SCORE"
        lbHighscoreSwitchScore.fontSize = 32 * (self.frame.width/667.0)
        lbHighscoreSwitchScore.position = CGPoint(x: 2*(self.frame.width / 30), y: 7.5*(self.frame.height / 12))
        lbHighscoreSwitchScore.fontColor = UIColor.white
        lbHighscoreSwitchScore.zPosition = 1.0
        self.addChild(lbHighscoreSwitchScore)
        // "Score" Checkbox
        snHighscoreSwitchScore = SKSpriteNode(texture: SKTexture(imageNamed: "Media/checkbox_checked.png"), color: UIColor.clear, size: CGSize(width: flHighscoreCheckboxWidth, height: flHighscoreCheckboxHeight))
        snHighscoreSwitchScore.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        snHighscoreSwitchScore.position = CGPoint(x: 9*(self.frame.width / 30), y: 7.5*(self.frame.height / 12))
        snHighscoreSwitchScore.zPosition = 1.0
        snHighscoreSwitchScore.alpha = 1.0
        snHighscoreSwitchScore.name = "HighscoreCheckboxScore"
        self.addChild(snHighscoreSwitchScore)
        if blScoreSwitchChecked == true {
            snHighscoreSwitchScore.texture = SKTexture(imageNamed: "Media/checkbox_checked.png")
        } else {
            snHighscoreSwitchScore.texture = SKTexture(imageNamed: "Media/checkbox_unchecked.png")
        }
        // "Time" Text
        lbHighscoreSwitchTime = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbHighscoreSwitchTime.horizontalAlignmentMode = .left;
        lbHighscoreSwitchTime.verticalAlignmentMode = .center
        lbHighscoreSwitchTime.text = "TIME"
        lbHighscoreSwitchTime.fontSize = 32 * (self.frame.width/667.0)
        lbHighscoreSwitchTime.position = CGPoint(x: 13*(self.frame.width / 30), y: 7.5*(self.frame.height / 12))
        lbHighscoreSwitchTime.fontColor = UIColor.white
        lbHighscoreSwitchTime.zPosition = 1.0
        self.addChild(lbHighscoreSwitchTime)
        // "Time" Checkbox
        snHighscoreSwitchTime = SKSpriteNode(texture: SKTexture(imageNamed: "Media/checkbox_checked.png"), color: UIColor.clear, size: CGSize(width: flHighscoreCheckboxWidth, height: flHighscoreCheckboxHeight))
        snHighscoreSwitchTime.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        snHighscoreSwitchTime.position = CGPoint(x: 19*(self.frame.width / 30), y: 7.5*(self.frame.height / 12))
        snHighscoreSwitchTime.zPosition = 1.0
        snHighscoreSwitchTime.alpha = 1.0
        snHighscoreSwitchTime.name = "HighscoreCheckboxTime"
        self.addChild(snHighscoreSwitchTime)
        if blScoreSwitchChecked == false {
            snHighscoreSwitchTime.texture = SKTexture(imageNamed: "Media/checkbox_checked.png")
        } else {
            snHighscoreSwitchTime.texture = SKTexture(imageNamed: "Media/checkbox_unchecked.png")
        }
        // --- Hishscore ranking ---
        // --- Headline rank ---
        lbHighscoreHeadRank = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbHighscoreHeadRank.horizontalAlignmentMode = .center;
        lbHighscoreHeadRank.verticalAlignmentMode = .center
        lbHighscoreHeadRank.text = "NO"
        lbHighscoreHeadRank.fontSize = 26 * (self.frame.width/667.0)
        lbHighscoreHeadRank.position = CGPoint(x: 3*(self.frame.width / 30), y: 6*(self.frame.height / 12))
        lbHighscoreHeadRank.fontColor = UIColor.white
        lbHighscoreHeadRank.zPosition = 1.0
        self.addChild(lbHighscoreHeadRank)
        // --- Hishscore score ---
        // --- Headline score ---
        lbHighscoreHeadScore = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbHighscoreHeadScore.horizontalAlignmentMode = .center;
        lbHighscoreHeadScore.verticalAlignmentMode = .center
        lbHighscoreHeadScore.text = "SCORE"
        lbHighscoreHeadScore.fontSize = 26 * (self.frame.width/667.0)
        lbHighscoreHeadScore.position = CGPoint(x: 8.5*(self.frame.width / 30), y: 6*(self.frame.height / 12))
        lbHighscoreHeadScore.fontColor = UIColor.white
        lbHighscoreHeadScore.zPosition = 1.0
        self.addChild(lbHighscoreHeadScore)
        // --- Hishscore time ---
        // --- Headline time ---
        lbHighscoreHeadTime = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbHighscoreHeadTime.horizontalAlignmentMode = .center;
        lbHighscoreHeadTime.verticalAlignmentMode = .center
        lbHighscoreHeadTime.text = "TIME"
        lbHighscoreHeadTime.fontSize = 26 * (self.frame.width/667.0)
        lbHighscoreHeadTime.position = CGPoint(x: 15*(self.frame.width / 30), y: 6*(self.frame.height / 12))
        lbHighscoreHeadTime.fontColor = UIColor.white
        lbHighscoreHeadTime.zPosition = 1.0
        self.addChild(lbHighscoreHeadTime)
        // --- Hishscore name ---
        // --- Headline name ---
        lbHighscoreHeadName = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbHighscoreHeadName.horizontalAlignmentMode = .center;
        lbHighscoreHeadName.verticalAlignmentMode = .center
        lbHighscoreHeadName.text = "NAME"
        lbHighscoreHeadName.fontSize = 26 * (self.frame.width/667.0)
        lbHighscoreHeadName.position = CGPoint(x: 23*(self.frame.width / 30), y: 6*(self.frame.height / 12))
        lbHighscoreHeadName.fontColor = UIColor.white
        lbHighscoreHeadName.zPosition = 1.0
        self.addChild(lbHighscoreHeadName)
        // --- Sounds: Click ---
        let path = Bundle.main.path(forResource: "Media/sounds/click_001", ofType:"wav")
        let fileURL = URL(fileURLWithPath: path!)
        do {
            try apClick = AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apClick.numberOfLoops = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            switch (touchedNode.name) {
            case "MenuBack"?:
                snMenuBack.texture = SKTexture(imageNamed: "Media/menu_back_pressed.png")
                iButtonPressed = 1
                fctPlayClickSound()
            case "HighscoreCheckboxScore"?:
                iButtonPressed = 2
                if blScoreSwitchChecked == false {
                    fctPlayClickSound()
                }
            case "HighscoreCheckboxTime"?:
                iButtonPressed = 3
                if blScoreSwitchChecked == true {
                    fctPlayClickSound()
                }
            default:
                ()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // Reset pressed sprites
        snMenuBack.texture = SKTexture(imageNamed: "Media/menu_back.png")
        // Screen elements
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            switch (touchedNode.name) {
            case "MenuBack"?:
                if iButtonPressed == 1 {
                    let transition = SKTransition.fade(with: UIColor.black, duration: 0.2)
                    let nextScene = TLGameMenu(size: scene!.size)
                    nextScene.scaleMode = .aspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
                    self.removeFromParent()
                }
            case "HighscoreCheckboxScore"?:
                if iButtonPressed == 2 {
                    if blScoreSwitchChecked == false {
                        blScoreSwitchChecked = true
                        snHighscoreSwitchScore.texture = SKTexture(imageNamed: "Media/checkbox_checked.png")
                        snHighscoreSwitchTime.texture = SKTexture(imageNamed: "Media/checkbox_unchecked.png")
                        fctUpdateHighscoreTable()
                    }
                }
            case "HighscoreCheckboxTime"?:
                if iButtonPressed == 3 {
                    if blScoreSwitchChecked == true {
                        blScoreSwitchChecked = false
                        snHighscoreSwitchTime.texture = SKTexture(imageNamed: "Media/checkbox_checked.png")
                        snHighscoreSwitchScore.texture = SKTexture(imageNamed: "Media/checkbox_unchecked.png")
                        fctUpdateHighscoreTable()
                    }
                }
            default:
                ()
            }
        }
        snMenuBack.texture = SKTexture(imageNamed: "Media/menu_back.png")
        iButtonPressed = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    func fctPlayClickSound() {
        if GameData.blSoundEffectsEnabled == true {
            apClick.volume = GameData.flSoundsVolume
            apClick.prepareToPlay()
            apClick.play()
        }
    }
    
    func fctUpdateHighscoreTable() {
        for column in 1...aSkHighscoresColumns - 1 {
            for row in 0...aSkHighscoresRows - 1 {
                if column == 1 {
                    if blScoreSwitchChecked == true {
                        aSkHighscores[column][row].text = String(GameData.aHighscoresScore[row].iScore)
                    } else {
                        aSkHighscores[column][row].text = String(GameData.aHighscoresTime[row].iScore)
                    }
                }
                if column == 2 {
                    if blScoreSwitchChecked == true {
                        aSkHighscores[column][row].text = String(GameData.aHighscoresScore[row].iTime)
                    } else {
                        aSkHighscores[column][row].text = String(GameData.aHighscoresTime[row].iTime)
                    }
                }
                if column == 3 {
                    if blScoreSwitchChecked == true {
                        aSkHighscores[column][row].text = GameData.aHighscoresScore[row].strName
                    } else {
                        aSkHighscores[column][row].text = GameData.aHighscoresTime[row].strName
                    }
                }
            }
        }
    }
}

