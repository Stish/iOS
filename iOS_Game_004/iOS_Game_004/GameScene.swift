//
//  GameScene.swift
//  iOS_Game_004
//
//  Created by Alexander Wegner on 26.04.17.
//  Copyright © 2017 Alexander Wegner. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

// ### Debugging
var blVideoMode = Bool(false)

// ### Screen ratios
var flScreenWidth: CGFloat!
var flScreenHeight: CGFloat!
var flScreenWidthRatio: CGFloat!
var flScreenHeightRatio: CGFloat!
// ### Dot counts
var iDotsCntX = Int(7)
var iDotsCntY = Int(12)
// ### Shapes
var snDot: SKSpriteNode!
var snDotClick: SKShapeNode!
var aSnDots = Array<Array<SKShapeNode>>()
// ### Game attributes
var blSoundEffectsEnabled = Bool(true)
// ### Game colors
let uiCol1 = UIColor(red: 93/255.0, green: 80/255.0, blue: 176/255.0, alpha: 1.0)
let uiCol2 = UIColor(red: 235/255.0, green: 128/255.0, blue: 177/255.0, alpha: 1.0)
let uiCol3 = UIColor(red: 0/255.0, green: 109/255.0, blue: 196/255.0, alpha: 1.0)
let uiCol4 = UIColor(red: 2/255.0, green: 176/255.0, blue: 195/255.0, alpha: 1.0)
let uiCol5 = UIColor(red: 0/255.0, green: 130/255.0, blue: 54/255.0, alpha: 1.0)
let uiCol6 = UIColor(red: 217/255.0, green: 222/255.0, blue: 1/255.0, alpha: 1.0)
let uiCol7 = UIColor(red: 239/255.0, green: 109/255.0, blue: 7/255.0, alpha: 1.0)
let uiCol8 = UIColor(red: 224/255.0, green: 68/255.0, blue: 81/255.0, alpha: 1.0)
// ### Fonts
let fnGameFont = UIFont(name: "OrigamiMommy", size: 10)
let fnGameTextFont = UIFont(name: "Minecraft", size: 10)

class GameScene: SKScene {
    
    //private var label : SKLabelNode?
    //private var spinnyNode : SKShapeNode?
    var apClick: AVAudioPlayer!
    // ### Game menu
    var snGameMenu1: SKShapeNode!
    var slGameMenu1: SKLabelNode!
    var snGameMenu2: SKShapeNode!
    var slGameMenu2: SKLabelNode!
    var snGameMenu3: SKShapeNode!
    var slGameMenu3: SKLabelNode!
    var snGameMenu4: SKShapeNode!
    var slGameMenu4: SKLabelNode!
    var snButtonSoundPic: SKSpriteNode!
    // ### Auxiliary var
    var strButtonPressedName = ""
    
    override func didMove(to view: SKView) {
        // Screen size
        flScreenWidth = view.frame.size.width
        flScreenHeight = view.frame.size.height
        flScreenWidthRatio = flScreenWidth / 375.0
        flScreenHeightRatio = flScreenHeight / 667.0
        
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        
        //iDotsCntX = 7
        
        // Dots array
        aSnDots.removeAll()
        for x in 0 ..< iDotsCntX {
            var dotCol:[SKShapeNode] = []
            for y in 0 ..< iDotsCntY {
                let dot = SKShapeNode(rectOf: CGSize(width: 48 * flScreenWidthRatio, height: 48 * flScreenHeightRatio), cornerRadius: 5)
                //let dot = SKSpriteNode(texture: SKTexture(imageNamed: "Media/dot_001.png"), color: UIColor.clear, size: CGSize(width: 51 * flScreenWidthRatio, height: 51 * flScreenHeightRatio))
                //dot.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                dot.strokeColor = SKColor.blue
                dot.glowWidth = 0.0
                dot.lineWidth = 0.0
                dot.fillColor = UIColor(red:   CGFloat(arc4random()) / CGFloat(UInt32.max),
                                        green: CGFloat(arc4random()) / CGFloat(UInt32.max),
                                        blue:  CGFloat(arc4random()) / CGFloat(UInt32.max),
                                        alpha: 1.0)
                dot.position = CGPoint(x: CGFloat((x * 2) + 1) * (flScreenWidth / 14), y: CGFloat((y * 2) + 1) * (flScreenHeight / 24))
                dot.zPosition = 1.0
                dot.alpha = 0.5
                dot.name = "Dot"
                self.addChild(dot)
                dotCol.append(dot)
            }
            aSnDots.append(dotCol)
        }
        // ### Menu: Game menu 1
        snGameMenu1 = SKShapeNode(rectOf: CGSize(width: (48 * flScreenWidthRatio) + (6 * (flScreenWidth / 14)), height: 48 * flScreenHeightRatio), cornerRadius: 5)
        snGameMenu1.strokeColor = uiCol1
        snGameMenu1.glowWidth = 0.0
        snGameMenu1.lineWidth = 2.0
        snGameMenu1.fillColor = UIColor.withAlphaComponent(uiCol1)(0.25)
        snGameMenu1.position = CGPoint(x: 8 * (flScreenWidth / 14), y: 15 * (flScreenHeight / 24))
        snGameMenu1.zPosition = 1.0
        snGameMenu1.alpha = 1.0
        snGameMenu1.name = "Game4Dots"
        self.addChild(snGameMenu1)
        slGameMenu1 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        slGameMenu1.text = "4 Dots"
        slGameMenu1.fontSize = 22 * flScreenWidthRatio
        slGameMenu1.position = CGPoint(x: 8 * (flScreenWidth / 14), y: 15 * (flScreenHeight / 24))
        slGameMenu1.fontColor = uiCol1
        slGameMenu1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        slGameMenu1.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        slGameMenu1.zPosition = 1.0
        slGameMenu1.name = "Game4Dots"
        self.addChild(slGameMenu1)
        // ### Menu: Game menu 2
        snGameMenu2 = SKShapeNode(rectOf: CGSize(width: (48 * flScreenWidthRatio) + (6 * (flScreenWidth / 14)), height: 48 * flScreenHeightRatio), cornerRadius: 5)
        snGameMenu2.strokeColor = uiCol4
        snGameMenu2.glowWidth = 0.0
        snGameMenu2.lineWidth = 2.0
        snGameMenu2.fillColor = UIColor.withAlphaComponent(uiCol4)(0.25)
        snGameMenu2.position = CGPoint(x: 8 * (flScreenWidth / 14), y: 13 * (flScreenHeight / 24))
        snGameMenu2.zPosition = 1.0
        snGameMenu2.alpha = 1.0
        snGameMenu2.name = "Game8Dots"
        self.addChild(snGameMenu2)
        slGameMenu2 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        slGameMenu2.text = "8 Dots"
        slGameMenu2.fontSize = 22 * flScreenWidthRatio
        slGameMenu2.position = CGPoint(x: 8 * (flScreenWidth / 14), y: 13 * (flScreenHeight / 24))
        slGameMenu2.fontColor = uiCol4
        slGameMenu2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        slGameMenu2.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        slGameMenu2.zPosition = 1.0
        slGameMenu2.name = "Game8Dots"
        self.addChild(slGameMenu2)
        // ### Menu: Game menu 3
        snGameMenu3 = SKShapeNode(rectOf: CGSize(width: (48 * flScreenWidthRatio) + (6 * (flScreenWidth / 14)), height: 48 * flScreenHeightRatio), cornerRadius: 5)
        snGameMenu3.strokeColor = uiCol5
        snGameMenu3.glowWidth = 0.0
        snGameMenu3.lineWidth = 2.0
        snGameMenu3.fillColor = UIColor.withAlphaComponent(uiCol5)(0.25)
        snGameMenu3.position = CGPoint(x: 8 * (flScreenWidth / 14), y: 11 * (flScreenHeight / 24))
        snGameMenu3.zPosition = 1.0
        snGameMenu3.alpha = 1.0
        snGameMenu3.name = "GamePattern"
        self.addChild(snGameMenu3)
        slGameMenu3 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        slGameMenu3.text = "Pattern"
        slGameMenu3.fontSize = 22 * flScreenWidthRatio
        slGameMenu3.position = CGPoint(x: 8 * (flScreenWidth / 14), y: 11 * (flScreenHeight / 24))
        slGameMenu3.fontColor = uiCol5
        slGameMenu3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        slGameMenu3.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        slGameMenu3.zPosition = 1.0
        slGameMenu3.name = "GamePattern"
        self.addChild(slGameMenu3)
        // ### Menu: Game menu 4
        snGameMenu4 = SKShapeNode(rectOf: CGSize(width: (48 * flScreenWidthRatio) + (6 * (flScreenWidth / 14)), height: 48 * flScreenHeightRatio), cornerRadius: 5)
        snGameMenu4.strokeColor = uiCol8
        snGameMenu4.glowWidth = 0.0
        snGameMenu4.lineWidth = 2.0
        snGameMenu4.fillColor = UIColor.withAlphaComponent(uiCol8)(0.25)
        snGameMenu4.position = CGPoint(x: 8 * (flScreenWidth / 14), y: 9 * (flScreenHeight / 24))
        snGameMenu4.zPosition = 1.0
        snGameMenu4.alpha = 1.0
        snGameMenu4.name = "GameRandPattern"
        self.addChild(snGameMenu4)
        slGameMenu4 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        slGameMenu4.text = "Pattern *"
        slGameMenu4.fontSize = 22 * flScreenWidthRatio
        slGameMenu4.position = CGPoint(x: 8 * (flScreenWidth / 14), y: 9 * (flScreenHeight / 24))
        slGameMenu4.fontColor = uiCol8
        slGameMenu4.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        slGameMenu4.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        slGameMenu4.zPosition = 1.0
        slGameMenu4.name = "GameRandPattern"
        self.addChild(slGameMenu4)
        // ### Sound button
        snButtonSoundPic = SKSpriteNode(texture: SKTexture(imageNamed: "Media/button_sound_off_001.png"), color: UIColor.clear, size: CGSize(width: 48 * flScreenWidthRatio, height: 48 * flScreenHeightRatio))
        snButtonSoundPic.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snButtonSoundPic.position = CGPoint(x: 13 * (flScreenWidth / 14), y: 23 * (flScreenHeight / 24))
        snButtonSoundPic.zPosition = 1.0
        snButtonSoundPic.alpha = 1.0
        snButtonSoundPic.name = "ButtonSound"
        self.addChild(snButtonSoundPic)

        // ### Menu
        fctDisplayMenu()
        // ### Video mode
        if blVideoMode == true {
            snDotClick = SKShapeNode(circleOfRadius: 20)
            snDotClick.strokeColor = SKColor.white
            snDotClick.glowWidth = 0.0
            snDotClick.lineWidth = 0.0
            snDotClick.fillColor = UIColor.withAlphaComponent(SKColor.white)(0.0)
            //snDotClick.position = CGPoint(x: 1 * (flScreenWidth / 14), y: 23 * (flScreenHeight / 24))
            snDotClick.zPosition = 1.0
            snDotClick.alpha = 1.0
            self.addChild(snDotClick)
        }
        // --- Sounds: Click ---
        var path = Bundle.main.path(forResource: "Media/sounds/click_003", ofType:"wav")
        var fileURL = URL(fileURLWithPath: path!)
        do {
            try apClick = AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }
        apClick.numberOfLoops = 0
        
//        for r in 0.._numRows {
//            var tileRow:[SKSpriteNode] = []
//            for c in 0.._numCols {
//                let tile = SKSpriteNode(imageNamed: "bubble.png")
//                tile.size = CGSize(width: tileSize.width, height: tileSize.height)
//                tile.anchorPoint = CGPoint(x: 0, y: 0)
//                tile.position = getTilePosition(row: r, column: c)
//                self.addChild(tile)
//                tileRow.append(tile)
//            }
//            _tiles.append(tileRow)
//        }
        
        // Dot
//        snDot = SKSpriteNode(texture: SKTexture(imageNamed: "Media/dot_001.png"), color: UIColor.clear, size: CGSize(width: 51 * flScreenWidthRatio, height: 51 * flScreenHeightRatio))
//        snDot.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        snDot.position = CGPoint(x: 1 * (flScreenWidth / 14), y: 3 * (flScreenHeight / 24))
//        snDot.zPosition = 1.0
//        snDot.alpha = 1.0
//        snDot.name = "Dot"
//        self.addChild(snDot)
        
        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
        
        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//        
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//            
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {


    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            if blVideoMode == true {
                snDotClick.position = location
                //snDotClick.position.y = flScreenHeight - snDotClick.position.y
                fctFadeInOutSKShapeNode(snDotClick, time: 0.15, alpha: 1.0, pause: 0.05)
            }
            strButtonPressedName = ""
            switch (touchedNode.name) {
            case "Game4Dots"?:
                aSnDots[1][7].fillColor = uiCol1
                strButtonPressedName = "Game4Dots"
            case "Game8Dots"?:
                aSnDots[1][6].fillColor = uiCol4
                strButtonPressedName = "Game8Dots"
            case "GamePattern"?:
                aSnDots[1][5].fillColor = uiCol5
                strButtonPressedName = "GamePattern"
            case "GameRandPattern"?:
                aSnDots[1][4].fillColor = uiCol8
                strButtonPressedName = "GameRandPattern"
            case "ButtonSound"?:
                aSnDots[6][11].fillColor = UIColor.withAlphaComponent(UIColor.gray)(0.7)
                strButtonPressedName = "ButtonSound"
                //fctUpdateInterface()
            default:
                for x in 0 ..< iDotsCntX {
                    for y in 0 ..< iDotsCntY {
                        aSnDots[x][y].fillColor = UIColor(red: fctRandColor(), green: fctRandColor(), blue: fctRandColor(), alpha: 1.0)
                    }
                }
                aSnDots[1][7].fillColor = UIColor.withAlphaComponent(uiCol1)(0.25)
                aSnDots[1][6].fillColor = UIColor.withAlphaComponent(uiCol4)(0.25)
                aSnDots[1][5].fillColor = UIColor.withAlphaComponent(uiCol5)(0.25)
                aSnDots[1][4].fillColor = UIColor.withAlphaComponent(uiCol8)(0.25)
                aSnDots[6][11].fillColor = UIColor.withAlphaComponent(UIColor.gray)(0.25)
            }
            //fctDisplayMenu()
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*let transition = SKTransition.fade(with: .black, duration: 0.3)
        //gzGame = GameScene(size: scene!.size)
        //gzGame.scaleMode = .aspectFill
        //scene?.view?.presentScene(gzGame, transition: transition)
        fctPlayClick()
        let nextScene = TLGame4Dots(size: scene!.size)
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene, transition: transition)
        self.removeFromParent()*/
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            if blVideoMode == true {
                snDotClick.position = location
                //snDotClick.position.y = flScreenHeight - snDotClick.position.y
                fctFadeInOutSKShapeNode(snDotClick, time: 0.15, alpha: 1.0, pause: 0.05)
            }
            
            aSnDots[1][7].fillColor = UIColor.withAlphaComponent(uiCol1)(0.25)
            aSnDots[1][6].fillColor = UIColor.withAlphaComponent(uiCol4)(0.25)
            aSnDots[1][5].fillColor = UIColor.withAlphaComponent(uiCol5)(0.25)
            aSnDots[1][4].fillColor = UIColor.withAlphaComponent(uiCol8)(0.25)
            aSnDots[6][11].fillColor = UIColor.withAlphaComponent(UIColor.gray)(0.25)
            
            switch (touchedNode.name) {
            case "Game4Dots"?:
                if strButtonPressedName == "Game4Dots" {
                    let transition = SKTransition.fade(with: .black, duration: 0.3)
                    fctPlayClick()
                    let nextScene = TLGame4Dots(size: scene!.size)
                    nextScene.scaleMode = .aspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
                    self.removeFromParent()
                }
            case "Game8Dots"?:
                if strButtonPressedName == "Game8Dots" {
                    print("### Game: 8 Dots")
                }
            case "GamePattern"?:
                if strButtonPressedName == "GamePattern" {
                    print("### Game: Pattern")
                }
            case "GameRandPattern"?:
                if strButtonPressedName == "GameRandPattern" {
                    print("### Game: Random Pattern")
                }
            case "ButtonSound"?:
                if strButtonPressedName == "ButtonSound" {
                    if blSoundEffectsEnabled == true {
                        blSoundEffectsEnabled = false
                    } else {
                        blSoundEffectsEnabled = true
                    }
                }
            //fctUpdateInterface()
            default:
                aSnDots[1][7].fillColor = UIColor.withAlphaComponent(uiCol1)(0.25)
                aSnDots[1][6].fillColor = UIColor.withAlphaComponent(uiCol4)(0.25)
                aSnDots[1][5].fillColor = UIColor.withAlphaComponent(uiCol5)(0.25)
                aSnDots[1][4].fillColor = UIColor.withAlphaComponent(uiCol8)(0.25)
                aSnDots[6][11].fillColor = UIColor.withAlphaComponent(UIColor.gray)(0.25)
            }
            fctDisplayMenu()
        }

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func fctRandColor() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    func fctPlayClick() {
        if blSoundEffectsEnabled == true {
            apClick.volume = 1
            apClick.currentTime = 0
            apClick.prepareToPlay()
            apClick.play()
        }
    }
    
    func fctDisplayMenu() {
        // ### Game "4 Dots"
        aSnDots[1][7].alpha = 1.0
        aSnDots[1][7].fillColor = UIColor.withAlphaComponent(uiCol1)(0.25)
        aSnDots[1][7].name = "Game4Dots"
        aSnDots[1][7].strokeColor = uiCol1
        aSnDots[1][7].lineWidth = 2.0
        // ### Game "6 Dots"
        aSnDots[1][6].alpha = 1.0
        aSnDots[1][6].fillColor = UIColor.withAlphaComponent(uiCol4)(0.25)
        aSnDots[1][6].name = "Game6Dots"
        aSnDots[1][6].strokeColor = uiCol4
        aSnDots[1][6].lineWidth = 2.0
        // ### Game "Pattern"
        aSnDots[1][5].alpha = 1.0
        aSnDots[1][5].fillColor = UIColor.withAlphaComponent(uiCol5)(0.25)
        aSnDots[1][5].name = "GamePattern"
        aSnDots[1][5].strokeColor = uiCol5
        aSnDots[1][5].lineWidth = 2.0
        // ### Game "Random Pattern"
        aSnDots[1][4].alpha = 1.0
        aSnDots[1][4].fillColor = UIColor.withAlphaComponent(uiCol8)(0.25)
        aSnDots[1][4].name = "GameRandPattern"
        aSnDots[1][4].strokeColor = uiCol8
        aSnDots[1][4].lineWidth = 2.0
        // ### Hide dots
        for x in 2 ..< 6 {
            for y in 4 ..< 8 {
                aSnDots[x][y].alpha = 0.0
            }
        }
        // ### Sound Button
        aSnDots[6][11].strokeColor = SKColor.gray
        aSnDots[6][11].glowWidth = 0.0
        aSnDots[6][11].lineWidth = 2.0
        aSnDots[6][11].fillColor = UIColor.withAlphaComponent(SKColor.gray)(0.25)
        aSnDots[6][11].position = CGPoint(x: 13 * (flScreenWidth / 14), y: 23 * (flScreenHeight / 24))
        aSnDots[6][11].zPosition = 1.0
        aSnDots[6][11].alpha = 1.0
        aSnDots[6][11].name = "ButtonSound"
        if blSoundEffectsEnabled == true {
            snButtonSoundPic.texture = SKTexture(imageNamed: "Media/button_sound_on_001.png")
        } else {
            snButtonSoundPic.texture = SKTexture(imageNamed: "Media/button_sound_off_001.png")
        }
        //aSnDots[6][11].alpha = 0.0
    }
    
    func fctFadeInOutSKShapeNode (_ node: SKShapeNode, time: TimeInterval, alpha: CGFloat, pause: TimeInterval) {
        //node.alpha = 0.0
        
        let deltaAlpha = alpha/5
        let deltaTime = time/10
        var sumAlpha = CGFloat(0.0)
        
        node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
        
        node.removeAllActions()
        node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
            sumAlpha = sumAlpha + deltaAlpha
            node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
            node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                sumAlpha = sumAlpha + deltaAlpha
                node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                    sumAlpha = sumAlpha + deltaAlpha
                    node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                    node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                        sumAlpha = sumAlpha + deltaAlpha
                        node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                        node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                            sumAlpha = sumAlpha + deltaAlpha
                            node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                            node.run(SKAction.rotate(toAngle: 0, duration: pause), completion: {() in
                                // Pause
                                node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                                    // Fade out
                                    sumAlpha = sumAlpha - deltaAlpha
                                    node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                                    node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                                        sumAlpha = sumAlpha - deltaAlpha
                                        node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                                        node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                                            sumAlpha = sumAlpha - deltaAlpha
                                            node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                                            node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                                                sumAlpha = sumAlpha - deltaAlpha
                                                node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                                                node.run(SKAction.rotate(toAngle: 0, duration: deltaTime), completion: {() in
                                                    sumAlpha = sumAlpha - deltaAlpha
                                                    node.fillColor = UIColor.withAlphaComponent(node.fillColor)(sumAlpha)
                                                    node.removeAllActions()
                                                    //print("finish!!") // #debug
                                                })
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        })
    }

}
