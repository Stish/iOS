//
//  TLGameMenuAchievements.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 13.09.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import SpriteKit
import AVFoundation

class TLGameMenuAchievements: SKScene, SKPhysicsContactDelegate {
    var lbMenuAchieve: SKLabelNode!
    var snMenuAchieve: SKSpriteNode!
    var snMenuBack: SKSpriteNode!
    var snAchieveIcon1: SKSpriteNode!
    var snAchieveIcon2: SKSpriteNode!
    var snAchieveTextBorder1: SKSpriteNode!
    var snAchieveTextBorder2: SKSpriteNode!
    var lnAchieve1Text1: SKLabelNode!
    var lnAchieve1Text2: SKLabelNode!
    var lnAchieve1Text3: SKLabelNode!
    var lnAchieve1Text4: SKLabelNode!
    var lnAchieve2Text1: SKLabelNode!
    var lnAchieve2Text2: SKLabelNode!
    var lnAchieve2Text3: SKLabelNode!
    var lnAchieve2Text4: SKLabelNode!
    var snAchieveSliderBody: SKSpriteNode!
    var snAchieveSliderKnob: SKSpriteNode!
    var iButtonPressed: Int!
    var apClick: AVAudioPlayer!
    var iSliderPos: Int!
    var iSliderSteps: Int!
    var flAchieveSliderBodyHeight: CGFloat!
    var flSliderDeltaY: CGFloat!
    
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
        // Menu sprite size
        let flMenuSpriteWidth = (SKTexture(imageNamed: "Media/menu_headline.png").size().width) * (self.frame.width/667.0)
        let flMenuSpriteHeight = (SKTexture(imageNamed: "Media/menu_headline.png").size().height) * (self.frame.height/375.0)
        let flMenuBackSpriteWidth = (SKTexture(imageNamed: "Media/menu_back.png").size().width) * (self.frame.width/667.0)
        let flMenuBackSpriteHeight = (SKTexture(imageNamed: "Media/menu_back.png").size().height) * (self.frame.height/375.0)
        // Menu "Achieve" Sprite
        snMenuAchieve = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_headline.png"), color: UIColor.clear, size: CGSize(width: flMenuSpriteWidth, height: flMenuSpriteHeight))
        snMenuAchieve.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        snMenuAchieve.position = CGPoint(x: 15*(self.frame.width / 16), y: 10*(self.frame.height / 12))
        snMenuAchieve.zPosition = 1.0
        snMenuAchieve.alpha = 1.0
        snMenuAchieve.name = "MenuAchieve"
        addChild(snMenuAchieve)
        // Menu "Achieve" Text
        lbMenuAchieve = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuAchieve.horizontalAlignmentMode = .center;
        lbMenuAchieve.verticalAlignmentMode = .center
        lbMenuAchieve.text = "ACHIEVEMENT"
        lbMenuAchieve.fontSize = 30 * (self.frame.width/667.0)
        lbMenuAchieve.position = CGPoint(x: snMenuAchieve.frame.midX, y: 10*(self.frame.height / 12))
        lbMenuAchieve.fontColor = UIColor.white
        lbMenuAchieve.zPosition = 1.0
        lbMenuAchieve.name = "MenuAchieve"
        self.addChild(lbMenuAchieve)
        // Menu "Back" Sprite
        snMenuBack = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_back.png"), color: UIColor.clear, size: CGSize(width: flMenuBackSpriteWidth, height: flMenuBackSpriteHeight))
        snMenuBack.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        snMenuBack.position = CGPoint(x: 1*(self.frame.width / 16), y: 10*(self.frame.height / 12))
        snMenuBack.zPosition = 1.0
        snMenuBack.alpha = 1.0
        snMenuBack.name = "MenuBack"
        self.addChild(snMenuBack)
        // Achievements
        let flAchieveSliderBodyWidth = (SKTexture(imageNamed: "Media/slider_vertical_body.png").size().width) * (self.frame.width/667.0)
        flAchieveSliderBodyHeight = (SKTexture(imageNamed: "Media/slider_vertical_body.png").size().height) * (self.frame.height/375.0)
        let flAchieveSliderKnobWidth = (SKTexture(imageNamed: "Media/slider_vertical_knob.png").size().width) * (self.frame.width/667.0)
        let flAchieveSliderKnobHeight = (SKTexture(imageNamed: "Media/slider_vertical_knob.png").size().height) * (self.frame.height/375.0)
        let flAchieveIconWidth = (SKTexture(imageNamed: "Media/Achievements/achieve_icon_border.png").size().width) * (self.frame.width/667.0)
        let flAchieveIconHeight = (SKTexture(imageNamed: "Media/Achievements/achieve_icon_border.png").size().height) * (self.frame.height/375.0)
        let flAchieveTextBorderWidth = (SKTexture(imageNamed: "Media/Achievements/achieve_text_border.png").size().width) * (self.frame.width/667.0)
        let flAchieveTextBorderHeight = (SKTexture(imageNamed: "Media/Achievements/achieve_text_border.png").size().height) * (self.frame.height/375.0)
        // Achievement "Icon 1" Sprite
        snAchieveIcon1 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/Achievements/achieve_icon_border.png"), color: UIColor.clear, size: CGSize(width: flAchieveIconWidth, height: flAchieveIconHeight))
        snAchieveIcon1.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        snAchieveIcon1.position = CGPoint(x: 1*(self.frame.width / 16), y: 8*(self.frame.height / 12))
        snAchieveIcon1.zPosition = 1.0
        snAchieveIcon1.alpha = 1.0
        snAchieveIcon1.name = "AchieveIcon1"
        addChild(snAchieveIcon1)
        // Achievement "Icon 2" Sprite
        snAchieveIcon2 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/Achievements/achieve_icon_border.png"), color: UIColor.clear, size: CGSize(width: flAchieveIconWidth, height: flAchieveIconHeight))
        snAchieveIcon2.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        snAchieveIcon2.position = CGPoint(x: 1*(self.frame.width / 16), y: 4*(self.frame.height / 12))
        snAchieveIcon2.zPosition = 1.0
        snAchieveIcon2.alpha = 1.0
        snAchieveIcon2.name = "AchieveIcon2"
        addChild(snAchieveIcon2)
        // Achievement "Text border 1" Sprite
        snAchieveTextBorder1 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/Achievements/achieve_text_border.png"), color: UIColor.clear, size: CGSize(width: flAchieveTextBorderWidth, height: flAchieveTextBorderHeight))
        snAchieveTextBorder1.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        snAchieveTextBorder1.position = CGPoint(x: 13.5*(self.frame.width / 16), y: 8*(self.frame.height / 12))
        snAchieveTextBorder1.zPosition = 1.0
        snAchieveTextBorder1.alpha = 1.0
        snAchieveTextBorder1.name = "AchieveTextBorder1"
        addChild(snAchieveTextBorder1)
        // Achievement "Text border 2" Sprite
        snAchieveTextBorder2 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/Achievements/achieve_text_border.png"), color: UIColor.clear, size: CGSize(width: flAchieveTextBorderWidth, height: flAchieveTextBorderHeight))
        snAchieveTextBorder2.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        snAchieveTextBorder2.position = CGPoint(x: 13.5*(self.frame.width / 16), y: 4*(self.frame.height / 12))
        snAchieveTextBorder2.zPosition = 1.0
        snAchieveTextBorder2.alpha = 1.0
        snAchieveTextBorder2.name = "AchieveTextBorder2"
        addChild(snAchieveTextBorder2)
        // Achievement 1 Text line 1
        lnAchieve1Text1 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lnAchieve1Text1.horizontalAlignmentMode = .left;
        lnAchieve1Text1.verticalAlignmentMode = .center
        lnAchieve1Text1.fontSize = 20 * (self.frame.width/667.0)
        lnAchieve1Text1.fontColor = UIColor.white
        lnAchieve1Text1.zPosition = 1.0
        lnAchieve1Text1.text = "Blaster Master"
        lnAchieve1Text1.position = CGPoint(x: 4.2*(self.frame.width / 16), y: 8*(self.frame.height / 12) - 1*(flAchieveTextBorderHeight/5))
        self.addChild(lnAchieve1Text1)
        // Achievement 1 Text line 2
        lnAchieve1Text2 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lnAchieve1Text2.horizontalAlignmentMode = .left;
        lnAchieve1Text2.verticalAlignmentMode = .center
        lnAchieve1Text2.fontSize = 20 * (self.frame.width/667.0)
        lnAchieve1Text2.fontColor = UIColor.lightGray
        lnAchieve1Text2.zPosition = 1.0
        lnAchieve1Text2.text = "Number of destroyed asteroids"
        lnAchieve1Text2.position = CGPoint(x: 4.2*(self.frame.width / 16), y: 8*(self.frame.height / 12) - 2*(flAchieveTextBorderHeight/5))
        self.addChild(lnAchieve1Text2)
        // Achievement 1 Text line 3
        lnAchieve1Text3 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lnAchieve1Text3.horizontalAlignmentMode = .left;
        lnAchieve1Text3.verticalAlignmentMode = .center
        lnAchieve1Text3.fontSize = 20 * (self.frame.width/667.0)
        lnAchieve1Text3.fontColor = UIColor.lightGray
        lnAchieve1Text3.zPosition = 1.0
        lnAchieve1Text3.text = "Bla Bla Text"
        lnAchieve1Text3.position = CGPoint(x: 4.2*(self.frame.width / 16), y: 8*(self.frame.height / 12) - 3*(flAchieveTextBorderHeight/5))
        self.addChild(lnAchieve1Text3)
        // Achievement 1 Text line 4
        lnAchieve1Text4 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lnAchieve1Text4.horizontalAlignmentMode = .left;
        lnAchieve1Text4.verticalAlignmentMode = .center
        lnAchieve1Text4.fontSize = 20 * (self.frame.width/667.0)
        lnAchieve1Text4.fontColor = UIColor.red
        lnAchieve1Text4.zPosition = 1.0
        lnAchieve1Text4.text = "Weapon power +1"
        lnAchieve1Text4.position = CGPoint(x: 4.2*(self.frame.width / 16), y: 8*(self.frame.height / 12) - 4*(flAchieveTextBorderHeight/5))
        self.addChild(lnAchieve1Text4)
        // Achievement 2 Text line 1
        lnAchieve2Text1 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lnAchieve2Text1.horizontalAlignmentMode = .left;
        lnAchieve2Text1.verticalAlignmentMode = .center
        lnAchieve2Text1.fontSize = 20 * (self.frame.width/667.0)
        lnAchieve2Text1.fontColor = UIColor.white
        lnAchieve2Text1.zPosition = 1.0
        lnAchieve2Text1.text = "Blaster Master"
        lnAchieve2Text1.position = CGPoint(x: 4.2*(self.frame.width / 16), y: 4*(self.frame.height / 12) - 1*(flAchieveTextBorderHeight/5))
        self.addChild(lnAchieve2Text1)
        // Achievement 2 Text line 2
        lnAchieve2Text2 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lnAchieve2Text2.horizontalAlignmentMode = .left;
        lnAchieve2Text2.verticalAlignmentMode = .center
        lnAchieve2Text2.fontSize = 20 * (self.frame.width/667.0)
        lnAchieve2Text2.fontColor = UIColor.lightGray
        lnAchieve2Text2.zPosition = 1.0
        lnAchieve2Text2.text = "Number of destroyed asteroids"
        lnAchieve2Text2.position = CGPoint(x: 4.2*(self.frame.width / 16), y: 4*(self.frame.height / 12) - 2*(flAchieveTextBorderHeight/5))
        self.addChild(lnAchieve2Text2)
        // Achievement 2 Text line 3
        lnAchieve2Text3 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lnAchieve2Text3.horizontalAlignmentMode = .left;
        lnAchieve2Text3.verticalAlignmentMode = .center
        lnAchieve2Text3.fontSize = 20 * (self.frame.width/667.0)
        lnAchieve2Text3.fontColor = UIColor.lightGray
        lnAchieve2Text3.zPosition = 1.0
        lnAchieve2Text3.text = "Bla Bla Text"
        lnAchieve2Text3.position = CGPoint(x: 4.2*(self.frame.width / 16), y: 4*(self.frame.height / 12) - 3*(flAchieveTextBorderHeight/5))
        self.addChild(lnAchieve2Text3)
        // Achievement 2 Text line 4
        lnAchieve2Text4 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lnAchieve2Text4.horizontalAlignmentMode = .left;
        lnAchieve2Text4.verticalAlignmentMode = .center
        lnAchieve2Text4.fontSize = 20 * (self.frame.width/667.0)
        lnAchieve2Text4.fontColor = UIColor.red
        lnAchieve2Text4.zPosition = 1.0
        lnAchieve2Text4.text = "Weapon power +1"
        lnAchieve2Text4.position = CGPoint(x: 4.2*(self.frame.width / 16), y: 4*(self.frame.height / 12) - 4*(flAchieveTextBorderHeight/5))
        self.addChild(lnAchieve2Text4)
        // Slider body
        snAchieveSliderBody = SKSpriteNode(texture: SKTexture(imageNamed: "Media/slider_vertical_body.png"), color: UIColor.clear, size: CGSize(width: flAchieveSliderBodyWidth, height: flAchieveSliderBodyHeight))
        snAchieveSliderBody.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        snAchieveSliderBody.position = CGPoint(x: (15*(self.frame.width / 16)) - (flAchieveSliderKnobWidth / 2), y: 8*(self.frame.height / 12))
        snAchieveSliderBody.zPosition = 1.0
        snAchieveSliderBody.alpha = 1.0
        snAchieveSliderBody.name = "AchieveSliderBody"
        addChild(snAchieveSliderBody)
        // Slider knob
        snAchieveSliderKnob = SKSpriteNode(texture: SKTexture(imageNamed: "Media/slider_vertical_knob.png"), color: UIColor.clear, size: CGSize(width: flAchieveSliderKnobWidth, height: flAchieveSliderKnobHeight))
        snAchieveSliderKnob.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        snAchieveSliderKnob.position = CGPoint(x: 15*(self.frame.width / 16), y: 8*(self.frame.height / 12))
        snAchieveSliderKnob.zPosition = 1.0
        snAchieveSliderKnob.alpha = 1.0
        snAchieveSliderKnob.name = "AchieveSliderKnob"
        addChild(snAchieveSliderKnob)
        // --- 
        iSliderPos = 0
        iSliderSteps = iAchieveCnt / 2
        flSliderDeltaY = CGFloat(flAchieveSliderBodyHeight - flAchieveSliderKnobHeight) / CGFloat(iSliderSteps - 1)
        fctUpdateAchievements()
        fctUpdateSlider()
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
            case "AchieveSliderKnob"?:
                iButtonPressed = 2
                fctPlayClickSound()
            default:
                ()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if iButtonPressed == 2 {
            for touch in touches {
                if (snAchieveSliderKnob.position.y - touch.location(in: self).y) >= (flSliderDeltaY - 5) {
                    if (iSliderPos < iSliderSteps - 1) {
                        iSliderPos = iSliderPos + 1
                        fctUpdateSlider()
                        //iButtonPressed = 0
                    }
                }
                if (snAchieveSliderKnob.position.y - touch.location(in: self).y) <= -1*(flSliderDeltaY - 5) {
                    if (iSliderPos != 0) {
                        iSliderPos = iSliderPos - 1
                        fctUpdateSlider()
                        //iButtonPressed = 0
                    }
                }
            }
        }
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
    
    func fctUpdateSlider() {
        snAchieveSliderKnob.position.y = (8*(self.frame.height / 12)) - (CGFloat(iSliderPos) * flSliderDeltaY)
        
        switch (iSliderPos) {
        case 0:
            snAchieveIcon1.texture = SKTexture(imageNamed: "Media/Achievements/achieve_icon_01.png")
            snAchieveIcon2.texture = SKTexture(imageNamed: "Media/Achievements/achieve_icon_02.png")
            if GameData.iAchieved & (1<<0) == (1<<0) {
                lnAchieve1Text4.fontColor = UIColor.green
            } else {
                lnAchieve1Text4.fontColor = UIColor.red
            }
            if GameData.iAchieved & (1<<1) == (1<<1) {
                lnAchieve2Text4.fontColor = UIColor.green
            } else {
                lnAchieve2Text4.fontColor = UIColor.red
            }
        case 1:
            snAchieveIcon1.texture = SKTexture(imageNamed: "Media/Achievements/achieve_icon_03.png")
            snAchieveIcon2.texture = SKTexture(imageNamed: "Media/Achievements/achieve_icon_04.png")
            if GameData.iAchieved & (1<<2) == (1<<2) {
                lnAchieve1Text4.fontColor = UIColor.green
            } else {
                lnAchieve1Text4.fontColor = UIColor.red
            }
            if GameData.iAchieved & (1<<3) == (1<<3) {
                lnAchieve2Text4.fontColor = UIColor.green
            } else {
                lnAchieve2Text4.fontColor = UIColor.red
            }
        case 2:
            snAchieveIcon1.texture = SKTexture(imageNamed: "Media/Achievements/achieve_icon_05.png")
            snAchieveIcon2.texture = SKTexture(imageNamed: "Media/Achievements/achieve_icon_06.png")
            if GameData.iAchieved & (1<<4) == (1<<4) {
                lnAchieve1Text4.fontColor = UIColor.green
            } else {
                lnAchieve1Text4.fontColor = UIColor.red
            }
            if GameData.iAchieved & (1<<5) == (1<<5) {
                lnAchieve2Text4.fontColor = UIColor.green
            } else {
                lnAchieve2Text4.fontColor = UIColor.red
            }
//        case 3:
//            snAchieveIcon1.texture = SKTexture(imageNamed: "Media/Achievements/achieve_icon_07.png")
//            snAchieveIcon2.texture = SKTexture(imageNamed: "Media/Achievements/achieve_icon_08.png")
//        case 4:
//            snAchieveIcon1.texture = SKTexture(imageNamed: "Media/Achievements/achieve_icon_09.png")
//            snAchieveIcon2.texture = SKTexture(imageNamed: "Media/Achievements/achieve_icon_10.png")
        default:
            ()
        }
        // Text Achievement 1
        lnAchieve1Text1.text = GameData.aStrAchieveName[2 * iSliderPos]
        lnAchieve1Text2.text = GameData.aStrAchieveText1[2 * iSliderPos]
        lnAchieve1Text3.text = GameData.aStrAchieveText2[2 * iSliderPos]
        lnAchieve1Text4.text = GameData.aStrAchieveText3[2 * iSliderPos]
        // Text Achievement 2
        lnAchieve2Text1.text = GameData.aStrAchieveName[(2 * iSliderPos) + 1]
        lnAchieve2Text2.text = GameData.aStrAchieveText1[(2 * iSliderPos) + 1]
        lnAchieve2Text3.text = GameData.aStrAchieveText2[(2 * iSliderPos) + 1]
        lnAchieve2Text4.text = GameData.aStrAchieveText3[(2 * iSliderPos) + 1]
    }
    
    func fctUpdateAchievements() {
        // Achievement 01
        GameData.aStrAchieveText2[0] = String(GameData.iMeteoriteCnt) + " / " + String(iAchieve1)
        GameData.aStrAchieveName[1] = "Wreck-it " + GameData.strPlayerName
    }
}


