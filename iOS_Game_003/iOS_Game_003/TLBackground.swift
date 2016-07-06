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
    let flBackgroundRatio_003: CGFloat
    let flBackgroundRatio_004: CGFloat
    let flBackgroundRatio_005: CGFloat
    let flBackgroundRatio_006: CGFloat
    
    init(size: CGSize) {
        let txBackground_001 = SKTexture(imageNamed: "backgrounds/background_001.png")
        flBackgroundRatio_001 = txBackground_001.size().width / txBackground_001.size().height
        
        let txBackground_002 = SKTexture(imageNamed: "backgrounds/background_002.png")
        flBackgroundRatio_002 = txBackground_002.size().width / txBackground_002.size().height
        
        let txBackground_003 = SKTexture(imageNamed: "backgrounds/background_003.png")
        flBackgroundRatio_003 = txBackground_003.size().width / txBackground_003.size().height
        
        let txBackground_004 = SKTexture(imageNamed: "backgrounds/background_004.png")
        flBackgroundRatio_004 = txBackground_004.size().width / txBackground_004.size().height
        
        let txBackground_005 = SKTexture(imageNamed: "backgrounds/background_005.png")
        flBackgroundRatio_005 = txBackground_005.size().width / txBackground_005.size().height
        
        let txBackground_006 = SKTexture(imageNamed: "backgrounds/background_006.png")
        flBackgroundRatio_006 = txBackground_006.size().width / txBackground_006.size().height

        super.init(texture: nil,color: UIColor.blackColor(), size: CGSizeMake(size.height * ((flBackgroundRatio_001 * 2) + flBackgroundRatio_002), size.height))
        self.anchorPoint = CGPointMake(0.0, 0.0)
        // --- Part 001 ---
        let snBackground_001 = SKSpriteNode(texture: txBackground_001,color: UIColor.blackColor(), size: CGSizeMake(size.height * flBackgroundRatio_001, size.height))
        snBackground_001.anchorPoint = CGPointMake(0.0, 0.0)
        snBackground_001.position = CGPoint(x: 0, y: 0)
        addChild(snBackground_001)
        // --- Part 002 ---
        let snBackground_002 = SKSpriteNode(texture: txBackground_002,color: UIColor.blackColor(), size: CGSizeMake(size.height * flBackgroundRatio_002, size.height))
        snBackground_002.anchorPoint = CGPointMake(0.0, 0.0)
        snBackground_002.position = CGPoint(x: size.height * flBackgroundRatio_001, y: 0)
        addChild(snBackground_002)
        // --- Part 003 ---
        let snBackground_003 = SKSpriteNode(texture: txBackground_001,color: UIColor.blackColor(), size: CGSizeMake(size.height * flBackgroundRatio_001, size.height))
        snBackground_003.anchorPoint = CGPointMake(0.0, 0.0)
        snBackground_003.position = CGPoint(x: size.height * (flBackgroundRatio_001 + flBackgroundRatio_002), y: 0)
        addChild(snBackground_003)
        // --- Part 004 ---
        let snBackground_004 = SKSpriteNode(texture: txBackground_003,color: UIColor.blackColor(), size: CGSizeMake(size.height * flBackgroundRatio_003, size.height))
        snBackground_004.anchorPoint = CGPointMake(0.0, 0.0)
        snBackground_004.position = CGPoint(x: size.height * ((flBackgroundRatio_001) * 2 + flBackgroundRatio_002), y: 0)
        addChild(snBackground_004)
        // --- Part 005 ---
        let snBackground_005 = SKSpriteNode(texture: txBackground_001,color: UIColor.blackColor(), size: CGSizeMake(size.height * flBackgroundRatio_001, size.height))
        snBackground_005.anchorPoint = CGPointMake(0.0, 0.0)
        snBackground_005.position = CGPoint(x: size.height * ((flBackgroundRatio_001) * 2 + flBackgroundRatio_002 + flBackgroundRatio_003), y: 0)
        addChild(snBackground_005)
        // --- Part 006 ---
        let snBackground_006 = SKSpriteNode(texture: txBackground_004,color: UIColor.blackColor(), size: CGSizeMake(size.height * flBackgroundRatio_004, size.height))
        snBackground_006.anchorPoint = CGPointMake(0.0, 0.0)
        snBackground_006.position = CGPoint(x: size.height * ((flBackgroundRatio_001) * 3 + flBackgroundRatio_002 + flBackgroundRatio_003), y: 0)
        addChild(snBackground_006)
        // --- Part 007 ---
        let snBackground_007 = SKSpriteNode(texture: txBackground_001,color: UIColor.blackColor(), size: CGSizeMake(size.height * flBackgroundRatio_001, size.height))
        snBackground_007.anchorPoint = CGPointMake(0.0, 0.0)
        snBackground_007.position = CGPoint(x: size.height * ((flBackgroundRatio_001) * 3 + flBackgroundRatio_002 + flBackgroundRatio_003 + flBackgroundRatio_004), y: 0)
        addChild(snBackground_007)
        // --- Part 008 ---
        let snBackground_008 = SKSpriteNode(texture: txBackground_005,color: UIColor.blackColor(), size: CGSizeMake(size.height * flBackgroundRatio_005, size.height))
        snBackground_008.anchorPoint = CGPointMake(0.0, 0.0)
        snBackground_008.position = CGPoint(x: size.height * ((flBackgroundRatio_001) * 4 + flBackgroundRatio_002 + flBackgroundRatio_003 + flBackgroundRatio_004), y: 0)
        addChild(snBackground_008)
        // --- Part 009 ---
        let snBackground_009 = SKSpriteNode(texture: txBackground_001,color: UIColor.blackColor(), size: CGSizeMake(size.height * flBackgroundRatio_001, size.height))
        snBackground_009.anchorPoint = CGPointMake(0.0, 0.0)
        snBackground_009.position = CGPoint(x: size.height * ((flBackgroundRatio_001) * 4 + flBackgroundRatio_002 + flBackgroundRatio_003 + flBackgroundRatio_004 + flBackgroundRatio_005), y: 0)
        addChild(snBackground_009)
        // --- Part 010 ---
        let snBackground_010 = SKSpriteNode(texture: txBackground_006,color: UIColor.blackColor(), size: CGSizeMake(size.height * flBackgroundRatio_006, size.height))
        snBackground_010.anchorPoint = CGPointMake(0.0, 0.0)
        snBackground_010.position = CGPoint(x: size.height * ((flBackgroundRatio_001) * 5 + flBackgroundRatio_002 + flBackgroundRatio_003 + flBackgroundRatio_004 + flBackgroundRatio_005), y: 0)
        addChild(snBackground_010)
        // --- Part 011 ---
        let snBackground_011 = SKSpriteNode(texture: txBackground_001,color: UIColor.blackColor(), size: CGSizeMake(size.height * flBackgroundRatio_001, size.height))
        snBackground_011.anchorPoint = CGPointMake(0.0, 0.0)
        snBackground_011.position = CGPoint(x: size.height * ((flBackgroundRatio_001) * 5 + flBackgroundRatio_002 + flBackgroundRatio_003 + flBackgroundRatio_004 + flBackgroundRatio_005 + flBackgroundRatio_006), y: 0)
        addChild(snBackground_011)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fctMoveLeft() {
        let actMoveLeft = SKAction.moveByX(-(size.height * ((flBackgroundRatio_001 * 5) + flBackgroundRatio_002 + flBackgroundRatio_003 + flBackgroundRatio_004 + flBackgroundRatio_005 + flBackgroundRatio_006)), y: 0, duration: 250.0)
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