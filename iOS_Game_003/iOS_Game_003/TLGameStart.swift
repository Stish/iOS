//
//  TLGameStart.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 06.07.16.
//  Copyright © 2016 Alexander Wegner. All rights reserved.
//

import SpriteKit
import AVFoundation

class TLGameStart: SKScene, SKPhysicsContactDelegate {
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        // --- collision setup ---
        physicsWorld.contactDelegate = self
        view.showsPhysics = false // #debug
        
        
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        self.anchorPoint = CGPointMake(0, 0)
        
        let flLogoRatio: CGFloat
        let txLogo = SKTexture(imageNamed: "Media/tinylabs_logo_04.png")
        flLogoRatio = txLogo.size().width / txLogo.size().height
        
        let snlogo = SKSpriteNode(texture: txLogo, color: UIColor.clearColor(), size: CGSizeMake(550 * (self.frame.width/667.0), 550 * (self.frame.height/375.0) / flLogoRatio))
        snlogo.anchorPoint = CGPointMake(0.5, 0.5)
        snlogo.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        snlogo.zPosition = 1.0
        snlogo.alpha = 1.0
        addChild(snlogo)
        // Highscore by score array
        aHighscoresScore.removeAll()
        aHighscoresTime.removeAll()
        for row in 0...aSkHighscoresRows - 1 {
            aHighscoresScore.append(TLHighscoreMember())
            aHighscoresTime.append(TLHighscoreMember())
            aHighscoresTime[row].strName = "N.A."
        }
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            let transition = SKTransition.fadeWithColor(.blackColor(), duration: 2)
            
            let nextScene = TLGameMenu(size: self.scene!.size)
            nextScene.scaleMode = .AspectFill
            
            self.scene?.view?.presentScene(nextScene, transition: transition)
        }
        self.removeFromParent()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
}
