//
//  TLBackground.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 15.12.15.
//  Copyright © 2015 Alexander Wegner. All rights reserved.
//

import Foundation
import SpriteKit

class TLBackground: SKSpriteNode {
    let flBackgroundRatio_001: CGFloat
    let flBackgroundRatio_002: CGFloat
    
    init(size: CGSize) {
        let txBackground_001 = SKTexture(imageNamed: "background_001.png")
        flBackgroundRatio_001 = txBackground_001.size().width / txBackground_001.size().height
        
        let txBackground_002 = SKTexture(imageNamed: "background_002.png")
        flBackgroundRatio_002 = txBackground_002.size().width / txBackground_002.size().height

        super.init(texture: nil,color: UIColor.blackColor(), size: CGSizeMake(size.height * ((flBackgroundRatio_001 * 2) + flBackgroundRatio_002), size.height))
        self.anchorPoint = CGPointMake(0.0, 0.0)
        // --- Background 001 ---
        let snBackground_001 = SKSpriteNode(texture: txBackground_001,color: UIColor.blackColor(), size: CGSizeMake(size.height * flBackgroundRatio_001, size.height))
        snBackground_001.anchorPoint = CGPointMake(0.0, 0.0)
        snBackground_001.position = CGPoint(x: 0, y: 0)
        addChild(snBackground_001)
        // --- Background 002 ---
        let snBackground_002 = SKSpriteNode(texture: txBackground_002,color: UIColor.blackColor(), size: CGSizeMake(size.height * flBackgroundRatio_002, size.height))
        snBackground_002.anchorPoint = CGPointMake(0.0, 0.0)
        snBackground_002.position = CGPoint(x: size.height * flBackgroundRatio_001, y: 0)
        addChild(snBackground_002)
        // --- Background 003 ---
        let snBackground_003 = SKSpriteNode(texture: txBackground_001,color: UIColor.blackColor(), size: CGSizeMake(size.height * flBackgroundRatio_001, size.height))
        snBackground_003.anchorPoint = CGPointMake(0.0, 0.0)
        snBackground_003.position = CGPoint(x: size.height * (flBackgroundRatio_001 + flBackgroundRatio_002), y: 0)
        addChild(snBackground_003)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fctMoveLeft() {
        let actMoveLeft = SKAction.moveByX(-(size.height * (flBackgroundRatio_001 + flBackgroundRatio_002)), y: 0, duration: 60.0)
        let resetPosition = SKAction.moveToX(0, duration: 0)
        let seqMoveLeft = SKAction.sequence([actMoveLeft, resetPosition])
        runAction(SKAction.repeatActionForever(seqMoveLeft))
    }
    
    func fctResetPos() {
        let resetPosition = SKAction.moveToX(0, duration: 0)
        self.removeAllActions()
        self.runAction(resetPosition)
    }
}