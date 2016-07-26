//
//  TLInventory.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 15.12.15.
//  Copyright © 2015 Alexander Wegner. All rights reserved.
//

import Foundation
import SpriteKit

class TLInventory: SKSpriteNode {
    
    init(size: CGSize) {
        let txBackground_001 = SKTexture(imageNamed: "Media/reactor_001.png")
        
        super.init(texture: nil,color: UIColor.blackColor(), size: CGSizeMake(size.height, size.height))
        self.anchorPoint = CGPointMake(0.5, 0.5)
        // --- Part 001 ---
        let snBackground_001 = SKSpriteNode(texture: txBackground_001,color: UIColor.clearColor(), size: CGSizeMake(size.height, size.height))
        snBackground_001.anchorPoint = CGPointMake(0.5, 0.5)
        snBackground_001.position = CGPoint(x: flScreenWidth / 2, y: flScreenHeight / 2)
        snBackground_001.alpha = 1.0
        //snBackground_001.zPosition = 2.5
        addChild(snBackground_001)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fctMoveLeft() {
        let actMoveLeft = SKAction.moveByX(1000,y: 0 , duration: 400.0)
        runAction(SKAction.repeatActionForever(actMoveLeft))
    }
}