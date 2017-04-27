//
//  GameScene.swift
//  iOS_Game_004
//
//  Created by Alexander Wegner on 26.04.17.
//  Copyright © 2017 Alexander Wegner. All rights reserved.
//

import SpriteKit
import GameplayKit

var flScreenWidth: CGFloat!
var flScreenHeight: CGFloat!
var flScreenWidthRatio: CGFloat!
var flScreenHeightRatio: CGFloat!

var iDotsCntX = Int(7)
var iDotsCntY = Int(12)

var snDot: SKSpriteNode!
var aSnDots = Array<Array<SKShapeNode>>()

// Game attributes
var blSoundEffectsEnabled = Bool(true)
// Gane colors
var uiCol1 = UIColor(red: 93/255.0, green: 80/255.0, blue: 176/255.0, alpha: 1.0)
// var uiCol2 = UIColor(red: 93/255.0, green: 80/255.0, blue: 176/255.0, alpha: 1.0)
// var uiCol3 = UIColor(red: 93/255.0, green: 80/255.0, blue: 176/255.0, alpha: 1.0)
var uiCol4 = UIColor(red: 2/255.0, green: 176/255.0, blue: 195/255.0, alpha: 1.0)
var uiCol5 = UIColor(red: 0/255.0, green: 130/255.0, blue: 54/255.0, alpha: 1.0)
// var uiCol6 = UIColor(red: 93/255.0, green: 80/255.0, blue: 176/255.0, alpha: 1.0)
// var uiCol7 = UIColor(red: 93/255.0, green: 80/255.0, blue: 176/255.0, alpha: 1.0)
var uiCol8 = UIColor(red: 224/255.0, green: 68/255.0, blue: 81/255.0, alpha: 1.0)

class GameScene: SKScene {
    
    //private var label : SKLabelNode?
    //private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        // Screen size
        flScreenWidth = view.frame.size.width
        flScreenHeight = view.frame.size.height
        flScreenWidthRatio = flScreenWidth / 375.0
        flScreenHeightRatio = flScreenHeight / 667.0
        
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        
        //iDotsCntX = 7
        
        // Dots array
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
                dot.position = CGPoint(x: CGFloat((x * 2) + 1) * (flScreenWidth / 14), y: CGFloat((y * 2) + 1) * (flScreenWidth / 14))
                dot.zPosition = 1.0
                dot.alpha = 1.0
                dot.name = "Dot"
                self.addChild(dot)
                dotCol.append(dot)
            }
            aSnDots.append(dotCol)
        }
        
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
        for x in 0 ..< iDotsCntX {
            for y in 0 ..< iDotsCntY {
                aSnDots[x][y].fillColor = UIColor(red: fctRandColor(), green: fctRandColor(), blue: fctRandColor(), alpha: 1.0)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.fade(with: .black, duration: 0.2)
        //gzGame = GameScene(size: scene!.size)
        //gzGame.scaleMode = .aspectFill
        //scene?.view?.presentScene(gzGame, transition: transition)
        let nextScene = TLGame4Dots(size: scene!.size)
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene, transition: transition)
        self.removeFromParent()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func fctRandColor() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
