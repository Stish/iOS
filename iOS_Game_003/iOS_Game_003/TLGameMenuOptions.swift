//
//  TLGameMenuOptions.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 07.07.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import SpriteKit
import AVFoundation

class TLGameMenuOptions: SKScene, SKPhysicsContactDelegate {
    var lbMenuOptions: SKLabelNode!
    var lbOptMusic: SKLabelNode!
    var lbOptSounds: SKLabelNode!
    var snMenuOptions: SKSpriteNode!
    var snMenuBack: SKSpriteNode!
    var snOptMusicCheckbox: SKSpriteNode!
    var snOptMusicSliderBody: SKSpriteNode!
    var snOptMusicSliderKnob: SKSpriteNode!
    var snOptSoundsCheckbox: SKSpriteNode!
    var snOptSoundsSliderBody: SKSpriteNode!
    var snOptSoundsSliderKnob: SKSpriteNode!
    var iButtonPressed: Int!
    var apClick: AVAudioPlayer!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        self.anchorPoint = CGPointMake(0, 0)
        let txGameMenuBackgrd = SKTexture(imageNamed: "Media/gamemenu_003.png")
        
        let snGameMenuBackgrd = SKSpriteNode(texture: txGameMenuBackgrd, color: UIColor.clearColor(), size: CGSizeMake(self.frame.width, self.frame.height))
        snGameMenuBackgrd.anchorPoint = CGPointMake(0.5, 0.5)
        snGameMenuBackgrd.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        snGameMenuBackgrd.zPosition = 1.0
        snGameMenuBackgrd.alpha = 1.0
        addChild(snGameMenuBackgrd)
        // Setup
        iButtonPressed = 0
        
        // Menu sprite size
        let flMenuSpriteWidth = (SKTexture(imageNamed: "Media/menu_headline.png").size().width) * (self.frame.width/667.0)
        let flMenuSpriteHeight = (SKTexture(imageNamed: "Media/menu_headline.png").size().height) * (self.frame.height/375.0)
        let flMenuBackSpriteWidth = (SKTexture(imageNamed: "Media/menu_back.png").size().width) * (self.frame.width/667.0)
        let flMenuBackSpriteHeight = (SKTexture(imageNamed: "Media/menu_back.png").size().height) * (self.frame.height/375.0)
        let flOptCheckboxWidth = (SKTexture(imageNamed: "Media/checkbox_checked.png").size().width) * (self.frame.width/667.0)
        let flOptCheckboxHeight = (SKTexture(imageNamed: "Media/checkbox_checked.png").size().height) * (self.frame.height/375.0)
        let flOptSliderBodyWidth = (SKTexture(imageNamed: "Media/slider_body.png").size().width) * (self.frame.width/667.0)
        let flOptSliderBodyHeight = (SKTexture(imageNamed: "Media/slider_body.png").size().height) * (self.frame.height/375.0)
        let flOptSliderKnobWidth = (SKTexture(imageNamed: "Media/slider_knob.png").size().width) * (self.frame.width/667.0)
        let flOptSliderKnobHeight = (SKTexture(imageNamed: "Media/slider_knob.png").size().height) * (self.frame.height/375.0)
        // Menu "Options" Sprite
        snMenuOptions = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_headline.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuSpriteWidth, flMenuSpriteHeight))
        snMenuOptions.anchorPoint = CGPointMake(1.0, 0.5)
        snMenuOptions.position = CGPoint(x: 15*(self.frame.width / 16), y: 5*(self.frame.height / 6))
        snMenuOptions.zPosition = 1.0
        snMenuOptions.alpha = 1.0
        snMenuOptions.name = "MenuOptions"
        addChild(snMenuOptions)
        // Menu "Options" Text
        lbMenuOptions = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbMenuOptions.horizontalAlignmentMode = .Center
        lbMenuOptions.verticalAlignmentMode = .Center
        lbMenuOptions.text = "OPTIONS"
        lbMenuOptions.fontSize = 30 * (self.frame.width/667.0)
        lbMenuOptions.position = CGPoint(x: CGRectGetMidX(snMenuOptions.frame), y: 5*(self.frame.height / 6))
        lbMenuOptions.fontColor = UIColor.whiteColor()
        lbMenuOptions.zPosition = 1.0
        lbMenuOptions.name = "MenuOptions"
        self.addChild(lbMenuOptions)
        // Menu "Back" Sprite
        snMenuBack = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_back.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuBackSpriteWidth, flMenuBackSpriteHeight))
        snMenuBack.anchorPoint = CGPointMake(0.0, 0.5)
        snMenuBack.position = CGPoint(x: 1*(self.frame.width / 16), y: 5*(self.frame.height / 6))
        snMenuBack.zPosition = 1.0
        snMenuBack.alpha = 1.0
        snMenuBack.name = "MenuBack"
        self.addChild(snMenuBack)
        // --- Sounds: Click ---
        let path = NSBundle.mainBundle().pathForResource("Media/sounds/click_001", ofType:"wav")
        let fileURL = NSURL(fileURLWithPath: path!)
        do {
            try apClick = AVAudioPlayer(contentsOfURL: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apClick.numberOfLoops = 0
        // --- Music ---
        // "Music" Text
        lbOptMusic = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbOptMusic.horizontalAlignmentMode = .Left
        lbOptMusic.verticalAlignmentMode = .Center
        lbOptMusic.text = "Music"
        lbOptMusic.fontSize = 35 * (self.frame.width/667.0)
        lbOptMusic.position = CGPoint(x: 1*(self.frame.width / 16), y: 3*(self.frame.height / 6))
        lbOptMusic.fontColor = UIColor.whiteColor()
        lbOptMusic.zPosition = 1.0
        lbOptMusic.name = "OptMusic"
        self.addChild(lbOptMusic)
        // "Music" Checkbox
        snOptMusicCheckbox = SKSpriteNode(texture: SKTexture(imageNamed: "Media/checkbox_checked.png"), color: UIColor.clearColor(), size: CGSizeMake(flOptCheckboxWidth, flOptCheckboxHeight))
        snOptMusicCheckbox.anchorPoint = CGPointMake(0.0, 0.5)
        snOptMusicCheckbox.position = CGPoint(x: 6*(self.frame.width / 16), y: 3*(self.frame.height / 6))
        snOptMusicCheckbox.zPosition = 1.0
        snOptMusicCheckbox.alpha = 1.0
        snOptMusicCheckbox.name = "OptMusicCheckbox"
        self.addChild(snOptMusicCheckbox)
        if blMusicEnabled == true {
            snOptMusicCheckbox.texture = SKTexture(imageNamed: "Media/checkbox_checked.png")
        } else {
            snOptMusicCheckbox.texture = SKTexture(imageNamed: "Media/checkbox_unchecked.png")
        }
        // "Music" Slider body
        snOptMusicSliderBody = SKSpriteNode(texture: SKTexture(imageNamed: "Media/slider_body.png"), color: UIColor.clearColor(), size: CGSizeMake(flOptSliderBodyWidth, flOptSliderBodyHeight))
        snOptMusicSliderBody.anchorPoint = CGPointMake(1.0, 0.5)
        snOptMusicSliderBody.position = CGPoint(x: 15*(self.frame.width / 16), y: 3*(self.frame.height / 6))
        snOptMusicSliderBody.zPosition = 1.0
        snOptMusicSliderBody.alpha = 1.0
        snOptMusicSliderBody.name = "OptMusicSliderBody"
        self.addChild(snOptMusicSliderBody)
        // "Music" Slider knob
        snOptMusicSliderKnob = SKSpriteNode(texture: SKTexture(imageNamed: "Media/slider_knob.png"), color: UIColor.clearColor(), size: CGSizeMake(flOptSliderKnobWidth, flOptSliderKnobHeight))
        snOptMusicSliderKnob.anchorPoint = CGPointMake(0.5, 0.5)
        snOptMusicSliderKnob.position = CGPoint(x: (15*(self.frame.width / 16)  - snOptMusicSliderBody.frame.size.width), y: (3*(self.frame.height / 6)))
        snOptMusicSliderKnob.zPosition = 1.0
        snOptMusicSliderKnob.alpha = 1.0
        snOptMusicSliderKnob.name = "OptMusicSliderKnob"
        self.addChild(snOptMusicSliderKnob)
        let flOptMusicSliderKnobPos = (((snOptMusicSliderBody.frame.size.width - snOptMusicSliderKnob.frame.size.width) / 100.0) * CGFloat(flMusicVolume * 100.0)) + (snOptMusicSliderKnob.frame.size.width / 2)
        snOptMusicSliderKnob.position = CGPoint(x: (15*(self.frame.width / 16) - snOptMusicSliderBody.frame.size.width + flOptMusicSliderKnobPos), y: (3 * (self.frame.height / 6)))
        // +------------+
        // |   Sounds   |
        // +------------+
        // "Sounds" Text
        lbOptSounds = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbOptSounds.horizontalAlignmentMode = .Left
        lbOptSounds.verticalAlignmentMode = .Center
        lbOptSounds.text = "SOUNDS"
        lbOptSounds.fontSize = 35 * (self.frame.width/667.0)
        lbOptSounds.position = CGPoint(x: 1*(self.frame.width / 16), y: 1*(self.frame.height / 6))
        lbOptSounds.fontColor = UIColor.whiteColor()
        lbOptSounds.zPosition = 1.0
        lbOptSounds.name = "OptSounds"
        self.addChild(lbOptSounds)
        // "Sounds" Checkbox
        snOptSoundsCheckbox = SKSpriteNode(texture: SKTexture(imageNamed: "Media/checkbox_checked.png"), color: UIColor.clearColor(), size: CGSizeMake(flOptCheckboxWidth, flOptCheckboxHeight))
        snOptSoundsCheckbox.anchorPoint = CGPointMake(0.0, 0.5)
        snOptSoundsCheckbox.position = CGPoint(x: 6*(self.frame.width / 16), y: 1*(self.frame.height / 6))
        snOptSoundsCheckbox.zPosition = 1.0
        snOptSoundsCheckbox.alpha = 1.0
        snOptSoundsCheckbox.name = "OptSoundsCheckbox"
        self.addChild(snOptSoundsCheckbox)
        if blSoundEffectsEnabled == true {
            snOptSoundsCheckbox.texture = SKTexture(imageNamed: "Media/checkbox_checked.png")
        } else {
            snOptSoundsCheckbox.texture = SKTexture(imageNamed: "Media/checkbox_unchecked.png")
        }
        // "Sounds" Slider body
        snOptSoundsSliderBody = SKSpriteNode(texture: SKTexture(imageNamed: "Media/slider_body.png"), color: UIColor.clearColor(), size: CGSizeMake(flOptSliderBodyWidth, flOptSliderBodyHeight))
        snOptSoundsSliderBody.anchorPoint = CGPointMake(1.0, 0.5)
        snOptSoundsSliderBody.position = CGPoint(x: 15*(self.frame.width / 16), y: 1*(self.frame.height / 6))
        snOptSoundsSliderBody.zPosition = 1.0
        snOptSoundsSliderBody.alpha = 1.0
        snOptSoundsSliderBody.name = "OptSoundsSliderBody"
        self.addChild(snOptSoundsSliderBody)
        // "Sounds" Slider knob
        snOptSoundsSliderKnob = SKSpriteNode(texture: SKTexture(imageNamed: "Media/slider_knob.png"), color: UIColor.clearColor(), size: CGSizeMake(flOptSliderKnobWidth, flOptSliderKnobHeight))
        snOptSoundsSliderKnob.anchorPoint = CGPointMake(0.5, 0.5)
        snOptSoundsSliderKnob.position = CGPoint(x: (15*(self.frame.width / 16)  - snOptSoundsSliderBody.frame.size.width), y: (1*(self.frame.height / 6)))
        snOptSoundsSliderKnob.zPosition = 1.0
        snOptSoundsSliderKnob.alpha = 1.0
        snOptSoundsSliderKnob.name = "OptSoundsSliderKnob"
        self.addChild(snOptSoundsSliderKnob)
        let flOptSoundsSliderKnobPos = (((snOptSoundsSliderBody.frame.size.width - snOptSoundsSliderKnob.frame.size.width) / 100.0) * CGFloat(flSoundsVolume * 100.0))
        snOptSoundsSliderKnob.position = CGPoint(x: (15*(self.frame.width / 16) - snOptSoundsSliderBody.frame.size.width + flOptSoundsSliderKnobPos + (snOptSoundsSliderKnob.frame.size.width / 2)), y: (1*(self.frame.height / 6)))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            switch (touchedNode.name) {
            case "MenuBack"?:
                snMenuBack.texture = SKTexture(imageNamed: "Media/menu_back_pressed.png")
                iButtonPressed = 1
                fctPlayClickSound()
            case "OptMusicCheckbox"?:
                iButtonPressed = 2
                fctPlayClickSound()
            case "OptSoundsCheckbox"?:
                iButtonPressed = 3
                fctPlayClickSound()
            case "OptMusicSliderKnob"?:
                iButtonPressed = 4
            case "OptSoundsSliderKnob"?:
                iButtonPressed = 5
            default:
                ()
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if iButtonPressed == 4 {
            for touch in touches {
                let flOptMusicSliderKnobMin = 15*(self.frame.width / 16) - snOptMusicSliderBody.frame.size.width + (snOptMusicSliderKnob.frame.size.width / 2)
                let flOptMusicSliderKnobMax = 15*(self.frame.width / 16) - (snOptMusicSliderKnob.frame.size.width / 2)
                
                if (touch.locationInView(view).x >= flOptMusicSliderKnobMin) && (touch.locationInView(view).x <= flOptMusicSliderKnobMax) {
                    snOptMusicSliderKnob.position = CGPoint(x: touch.locationInView(view).x, y: snOptMusicSliderKnob.position.y)
                    flMusicVolume = Float(snOptMusicSliderKnob.position.x - (snOptMusicSliderBody.position.x - snOptMusicSliderBody.frame.size.width))
                    flMusicVolume = flMusicVolume - Float(snOptMusicSliderKnob.frame.size.width / 2.0)
                    flMusicVolume = flMusicVolume / Float(snOptMusicSliderBody.frame.size.width - snOptMusicSliderKnob.frame.size.width)
                    print(flMusicVolume)
                }
                if touch.locationInView(view).x < flOptMusicSliderKnobMin {
                    snOptMusicSliderKnob.position = CGPoint(x: flOptMusicSliderKnobMin, y: snOptMusicSliderKnob.position.y)
                    flMusicVolume = 0.0
                    print(flMusicVolume)
                }
                if touch.locationInView(view).x > flOptMusicSliderKnobMax {
                    snOptMusicSliderKnob.position = CGPoint(x: flOptMusicSliderKnobMax, y: snOptMusicSliderKnob.position.y)
                    flMusicVolume = 1.0
                    print(flMusicVolume)
                }
            }
        }
        if iButtonPressed == 5 {
            for touch in touches {
                let flOptSoundsSliderKnobMin = 15*(self.frame.width / 16) - snOptSoundsSliderBody.frame.size.width + (snOptSoundsSliderKnob.frame.size.width / 2)
                let flOptSoundsSliderKnobMax = 15*(self.frame.width / 16) - (snOptSoundsSliderKnob.frame.size.width / 2)
                
                if (touch.locationInView(view).x >= flOptSoundsSliderKnobMin) && (touch.locationInView(view).x <= flOptSoundsSliderKnobMax) {
                    snOptSoundsSliderKnob.position = CGPoint(x: touch.locationInView(view).x, y: snOptSoundsSliderKnob.position.y)
                    flSoundsVolume = Float(snOptSoundsSliderKnob.position.x - (snOptSoundsSliderBody.position.x - snOptSoundsSliderBody.frame.size.width))
                    flSoundsVolume = flSoundsVolume - Float(snOptSoundsSliderKnob.frame.size.width / 2.0)
                    flSoundsVolume = flSoundsVolume / Float(snOptSoundsSliderBody.frame.size.width - snOptSoundsSliderKnob.frame.size.width)
                    print(flSoundsVolume)
                }
                if touch.locationInView(view).x < flOptSoundsSliderKnobMin {
                    snOptSoundsSliderKnob.position = CGPoint(x: flOptSoundsSliderKnobMin, y: snOptSoundsSliderKnob.position.y)
                    flSoundsVolume = 0.0
                    print(flSoundsVolume)
                }
                if touch.locationInView(view).x > flOptSoundsSliderKnobMax {
                    snOptSoundsSliderKnob.position = CGPoint(x: flOptSoundsSliderKnobMax, y: snOptSoundsSliderKnob.position.y)
                    flSoundsVolume = 1.0
                    print(flSoundsVolume)
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            switch (touchedNode.name) {
            case "MenuBack"?:
                if iButtonPressed == 1 {
                    let transition = SKTransition.fadeWithColor(.blackColor(), duration: 0.2)
                    let nextScene = TLGameMenu(size: scene!.size)
                    nextScene.scaleMode = .AspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
                    self.removeFromParent()
                }
            case "OptMusicCheckbox"?:
                if iButtonPressed == 2 {
                    if blMusicEnabled == true {
                        blMusicEnabled = false
                        snOptMusicCheckbox.texture = SKTexture(imageNamed: "Media/checkbox_unchecked.png")
                    } else {
                        blMusicEnabled = true
                        snOptMusicCheckbox.texture = SKTexture(imageNamed: "Media/checkbox_checked.png")
                    }
                }
            case "OptSoundsCheckbox"?:
                if iButtonPressed == 3 {
                    if blSoundEffectsEnabled == true {
                        blSoundEffectsEnabled = false
                        snOptSoundsCheckbox.texture = SKTexture(imageNamed: "Media/checkbox_unchecked.png")
                    } else {
                        blSoundEffectsEnabled = true
                        snOptSoundsCheckbox.texture = SKTexture(imageNamed: "Media/checkbox_checked.png")
                    }
                }
            default:
                ()
            }
        }
        snMenuBack.texture = SKTexture(imageNamed: "Media/menu_back.png")
        iButtonPressed = 0
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    func fctPlayClickSound() {
        apClick.prepareToPlay()
        apClick.play()
    }
}

