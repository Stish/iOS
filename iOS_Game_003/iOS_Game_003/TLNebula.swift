//
//  TLNebula.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 15.12.15.
//  Copyright © 2015 Alexander Wegner. All rights reserved.
//

import Foundation
import SpriteKit

class TLNebula: SKSpriteNode {
    let flBackgroundRatio_001: CGFloat
    let flBackgroundRatio_002: CGFloat
    
    init(size: CGSize) {
        let txBackground_001 = SKTexture(imageNamed: "Media/objects/nebula_001.png")
        flBackgroundRatio_001 = txBackground_001.size().width / txBackground_001.size().height
        
        let txBackground_002 = SKTexture(imageNamed: "Media/objects/nebula_001.png")
        flBackgroundRatio_002 = txBackground_002.size().width / txBackground_002.size().height
        
        super.init(texture: nil,color: UIColor.black, size: CGSize(width: size.height * ((flBackgroundRatio_001 * 2) + flBackgroundRatio_002), height: size.height))
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        // --- Part 001 ---
        let snBackground_001 = SKSpriteNode(texture: txBackground_001,color: UIColor.clear, size: CGSize(width: size.height * flBackgroundRatio_001, height: size.height))
        snBackground_001.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        snBackground_001.position = CGPoint(x: 0, y: 0)
        snBackground_001.alpha = 0.5
        snBackground_001.zPosition = 1.2
        addChild(snBackground_001)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fctMoveLeft() {
        let actMoveLeft = SKAction.moveBy(x: 1000,y: 0 , duration: 400.0)
        run(SKAction.repeatForever(actMoveLeft))
    }
}
