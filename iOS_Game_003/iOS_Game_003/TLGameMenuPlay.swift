//
//  TLGameMenuPlay.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 17.10.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import SpriteKit
import AVFoundation

class TLGameMenuPlay: SKScene, SKPhysicsContactDelegate {
    var snMenuBack: SKSpriteNode!
    var snShipSelect1: SKSpriteNode!
    var snShipSelect2: SKSpriteNode!
    var snShipSelect3: SKSpriteNode!
    var lbPlayTextline1: SKLabelNode!
    var lbPlayTextline2: SKLabelNode!
    var lbPlayTextline3: SKLabelNode!
    var lbPlayStart: SKLabelNode!
    var snPlayStart: SKSpriteNode!
    var snChar: SKSpriteNode!
    var iButtonPressed: Int!
    var apClick: AVAudioPlayer!
    var apTypewriterSound: AVAudioPlayer!
    var blStarted: Bool!
    
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
        //GameData.iAchieved = GameData.iAchieved | (1<<5) | (1<<0) // #debug
        // Menu sprite size
        let flMenuBackSpriteWidth = (SKTexture(imageNamed: "Media/menu_back.png").size().width) * (self.frame.width/667.0)
        let flMenuBackSpriteHeight = (SKTexture(imageNamed: "Media/menu_back.png").size().height) * (self.frame.height/375.0)
        let flShipSelectWidth = (SKTexture(imageNamed: "Media/ship_select_001.png").size().width) * (self.frame.width/667.0)
        let flShipSelectHeight = (SKTexture(imageNamed: "Media/ship_select_001.png").size().height) * (self.frame.height/375.0)
        // Menu "Back" Sprite
//        snMenuBack = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_back.png"), color: UIColor.clear, size: CGSize(width: flMenuBackSpriteWidth, height: flMenuBackSpriteHeight))
//        snMenuBack.anchorPoint = CGPoint(x: 0.0, y: 0.5)
//        snMenuBack.position = CGPoint(x: 1*(self.frame.width / 16), y: 10*(self.frame.height / 12))
//        snMenuBack.zPosition = 1.0
//        snMenuBack.alpha = 1.0
//        snMenuBack.name = "MenuBack"
//        self.addChild(snMenuBack)
        // Black background
        let snBackground_001 = SKSpriteNode(texture: nil,color: UIColor.black, size: CGSize(width: size.width, height: size.height))
        snBackground_001.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snBackground_001.position = CGPoint(x: flScreenWidth / 2, y: flScreenHeight / 2)
        snBackground_001.alpha = 0.5
        snBackground_001.zPosition = 1.0
        addChild(snBackground_001)
        // Ship select 1:
        snShipSelect1 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/ship_selected_001.png"), color: UIColor.clear, size: CGSize(width: flShipSelectWidth, height: flShipSelectHeight))
        snShipSelect1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snShipSelect1.position = CGPoint(x: 4*(self.frame.width / 16), y: 4.75*(self.frame.height / 12))
        snShipSelect1.zPosition = 1.0
        snShipSelect1.alpha = 1.0
        snShipSelect1.name = "ShipSelect1"
        self.addChild(snShipSelect1)
        // Ship select 2:
        snShipSelect2 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/ship_select_000_2.png"), color: UIColor.clear, size: CGSize(width: flShipSelectWidth, height: flShipSelectHeight))
        if (GameData.iAchieved & (1<<0) == (1<<0)) {
            snShipSelect2.texture = SKTexture(imageNamed: "Media/ship_select_002.png")
        }
        snShipSelect2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snShipSelect2.position = CGPoint(x: 8*(self.frame.width / 16), y: 4.75*(self.frame.height / 12))
        snShipSelect2.zPosition = 1.0
        snShipSelect2.alpha = 1.0
        snShipSelect2.name = "ShipSelect2"
        self.addChild(snShipSelect2)
        // Ship select 3:
        snShipSelect3 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/ship_select_000_2.png"), color: UIColor.clear, size: CGSize(width: flShipSelectWidth, height: flShipSelectHeight))
        if (GameData.iAchieved & (1<<5) == (1<<5)) {
            snShipSelect3.texture = SKTexture(imageNamed: "Media/ship_select_003.png")
        }
        snShipSelect3.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snShipSelect3.position = CGPoint(x: 12*(self.frame.width / 16), y: 4.75*(self.frame.height / 12))
        snShipSelect3.zPosition = 1.0
        snShipSelect3.alpha = 1.0
        snShipSelect3.name = "ShipSelect3"
        self.addChild(snShipSelect3)
        // Character portrait:
        snChar = SKSpriteNode(texture: SKTexture(imageNamed: "Media/char_002.png"), color: UIColor.clear, size: CGSize(width: flShipSelectWidth, height: flShipSelectHeight))
        snChar.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        snChar.position = CGPoint(x: 1*(self.frame.width / 16), y: 9*(self.frame.height / 12))
        snChar.zPosition = 1.0
        snChar.alpha = 1.0
        snChar.name = "Char"
        self.addChild(snChar)
        // Play text line 1
        lbPlayTextline1 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lbPlayTextline1.horizontalAlignmentMode = .left;
        lbPlayTextline1.verticalAlignmentMode = .center
        lbPlayTextline1.text = "Commander:"
        lbPlayTextline1.fontSize = 20 * (self.frame.width/667.0)
        lbPlayTextline1.position = CGPoint(x: 4*(self.frame.width / 16), y: 10*(self.frame.height / 12))
        lbPlayTextline1.fontColor = UIColor.white
        lbPlayTextline1.zPosition = 1.0
        lbPlayTextline1.name = "PlayTextline1"
        self.addChild(lbPlayTextline1)
        // Play text line 2
        lbPlayTextline2 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lbPlayTextline2.horizontalAlignmentMode = .left;
        lbPlayTextline2.verticalAlignmentMode = .center
        lbPlayTextline2.text = ""
        lbPlayTextline2.fontSize = 20 * (self.frame.width/667.0)
        lbPlayTextline2.position = CGPoint(x: 4*(self.frame.width / 16), y: 9*(self.frame.height / 12))
        lbPlayTextline2.fontColor = UIColor.white
        lbPlayTextline2.zPosition = 1.0
        lbPlayTextline2.name = "PlayTextline2"
        self.addChild(lbPlayTextline2)
        // Play text line 3
        lbPlayTextline3 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lbPlayTextline3.horizontalAlignmentMode = .left;
        lbPlayTextline3.verticalAlignmentMode = .center
        lbPlayTextline3.text = ""
        lbPlayTextline3.fontSize = 20 * (self.frame.width/667.0)
        lbPlayTextline3.position = CGPoint(x: 4*(self.frame.width / 16), y: 8*(self.frame.height / 12))
        lbPlayTextline3.fontColor = UIColor.white
        lbPlayTextline3.zPosition = 1.0
        lbPlayTextline3.name = "PlayTextline3"
        self.addChild(lbPlayTextline3)
        // Menu "Options" Sprite
        let flMenuSpriteWidth = (SKTexture(imageNamed: "Media/menu_top.png").size().width) * (self.frame.width/667.0)
        let flMenuSpriteHeight = (SKTexture(imageNamed: "Media/menu_top.png").size().height) * (self.frame.height/375.0)
        snPlayStart = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_bottom.png"), color: UIColor.clear, size: CGSize(width: flMenuSpriteWidth, height: flMenuSpriteHeight))
        snPlayStart.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snPlayStart.position = CGPoint(x: self.frame.midX, y: 1.5*(self.frame.height / 12))
        snPlayStart.zPosition = 1.0
        snPlayStart.alpha = 1.0
        snPlayStart.name = "PlayStart"
        addChild(snPlayStart)
        // Menu "Options" Text
        lbPlayStart = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbPlayStart.horizontalAlignmentMode = .center;
        lbPlayStart.verticalAlignmentMode = .center
        lbPlayStart.text = "START"
        lbPlayStart.fontSize = 30 * (self.frame.width/667.0)
        lbPlayStart.position = CGPoint(x: self.frame.midX, y: 1.5*(self.frame.height / 12))
        lbPlayStart.fontColor = UIColor.white
        lbPlayStart.zPosition = 1.0
        lbPlayStart.name = "PlayStart"
        self.addChild(lbPlayStart)
        // ----
        iSelectedShip = 0
        iButtonPressed = 0
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
        // --- Sounds: Typewriter ---
        let path2 = Bundle.main.path(forResource: "Media/sounds/typewriter_001", ofType:"wav")
        let fileURL2 = URL(fileURLWithPath: path2!)
        do {
            try apTypewriterSound = AVAudioPlayer(contentsOf: fileURL2, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apTypewriterSound.numberOfLoops = 0
        // Text
        blStarted = false
        fctTypewriter(lb1: lbPlayTextline1, lb2: lbPlayTextline2, lb3: lbPlayTextline3, tx1: " Das ist die erste Zeile mit Text!", tx2: "Und das ist die zweite Zeile mit Text!", tx3: "...und das ist die dritte Zeile mit Text!")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            switch (touchedNode.name) {
            case "MenuBack"?:
                ()
//                snMenuBack.texture = SKTexture(imageNamed: "Media/menu_back_pressed.png")
//                iButtonPressed = 1
//                fctPlayClickSound()
            case "ShipSelect1"?:
                if iSelectedShip != 0 {
                    iButtonPressed = 2
                    fctPlayClickSound()
                }
            case "ShipSelect2"?:
                if (iSelectedShip != 1) && (GameData.iAchieved & (1<<0) == (1<<0)) {
                    iButtonPressed = 3
                    fctPlayClickSound()
                }
            case "ShipSelect3"?:
                if (iSelectedShip != 2) && (GameData.iAchieved & (1<<5) == (1<<5)) {
                    iButtonPressed = 4
                    fctPlayClickSound()
                }
            case "PlayStart"?:
                iButtonPressed = 5
                snPlayStart.texture = SKTexture(imageNamed: "Media/menu_bottom_pressed.png")
                lbPlayStart.fontColor = UIColor.black
                fctPlayClickSound()
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
        //snMenuBack.texture = SKTexture(imageNamed: "Media/menu_back.png")
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
            case "ShipSelect1"?:
                if iButtonPressed == 2 {
                    snShipSelect1.texture = SKTexture(imageNamed: "Media/ship_selected_001.png")
                    if GameData.iAchieved & (1<<0) == (1<<0) {
                        snShipSelect2.texture = SKTexture(imageNamed: "Media/ship_select_002.png")
                    } else {
                        snShipSelect2.texture = SKTexture(imageNamed: "Media/ship_select_000_2.png")
                    }
                    if GameData.iAchieved & (1<<5) == (1<<5) {
                        snShipSelect3.texture = SKTexture(imageNamed: "Media/ship_select_003.png")
                    } else {
                        snShipSelect3.texture = SKTexture(imageNamed: "Media/ship_select_000_2.png")
                    }
                    iSelectedShip = 0
                }
            case "ShipSelect2"?:
                if iButtonPressed == 3 {
                    snShipSelect1.texture = SKTexture(imageNamed: "Media/ship_select_001.png")
                    snShipSelect2.texture = SKTexture(imageNamed: "Media/ship_selected_002.png")
                    if GameData.iAchieved & (1<<5) == (1<<5) {
                        snShipSelect3.texture = SKTexture(imageNamed: "Media/ship_select_003.png")
                    } else {
                        snShipSelect3.texture = SKTexture(imageNamed: "Media/ship_select_000_2.png")
                    }
                    iSelectedShip = 1
                }
            case "ShipSelect3"?:
                if iButtonPressed == 4 {
                    snShipSelect1.texture = SKTexture(imageNamed: "Media/ship_select_001.png")
                    if GameData.iAchieved & (1<<0) == (1<<0) {
                        snShipSelect2.texture = SKTexture(imageNamed: "Media/ship_select_002.png")
                    } else {
                        snShipSelect2.texture = SKTexture(imageNamed: "Media/ship_select_000_2.png")
                    }
                    snShipSelect3.texture = SKTexture(imageNamed: "Media/ship_selected_003.png")
                    iSelectedShip = 2
                }
            case "PlayStart"?:
                if iButtonPressed == 5 {
                    blStarted = true
                    let transition = SKTransition.fade(with: .black, duration: 0.2)
                    gzGame = GameScene(size: scene!.size)
                    gzGame.scaleMode = .aspectFill
                    scene?.view?.presentScene(gzGame, transition: transition)
                    self.removeFromParent()
                }
            default:
                ()
            }
        }
        //snMenuBack.texture = SKTexture(imageNamed: "Media/menu_back.png")
        iButtonPressed = 0
        snPlayStart.texture = SKTexture(imageNamed: "Media/menu_bottom.png")
        lbPlayStart.fontColor = UIColor.white
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
    
    func fctPlayTypewriterSound() {
        if GameData.blSoundEffectsEnabled == true {
            apTypewriterSound.volume = GameData.flSoundsVolume
            apTypewriterSound.prepareToPlay()
            apTypewriterSound.play()
        }
    }
    
    func fctTypewriter(lb1: SKLabelNode, lb2: SKLabelNode, lb3: SKLabelNode, tx1: String, tx2: String, tx3: String) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            Thread.sleep(forTimeInterval: 0.5)
            if self.blStarted == true {
                Thread.current.cancel()
            }
            for char in tx1.characters {
                if self.blStarted == true {
                    Thread.current.cancel()
                    break
                }
                lb1.text = lb1.text! + String(char)
                self.fctPlayTypewriterSound()
                Thread.sleep(forTimeInterval: 0.02)
            }
            for char in tx2.characters {
                if self.blStarted == true {
                    Thread.current.cancel()
                    break
                }
                lb2.text = lb2.text! + String(char)
                self.fctPlayTypewriterSound()
                Thread.sleep(forTimeInterval: 0.02)
            }
            for char in tx3.characters {
                if self.blStarted == true {
                    Thread.current.cancel()
                    break
                }
                lb3.text = lb3.text! + String(char)
                self.fctPlayTypewriterSound()
                Thread.sleep(forTimeInterval: 0.02)
            }
        }
    }
}


