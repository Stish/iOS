//
//  GameScene.swift
//  iOS_Game_003
//
//  Created by Alexander Wegner on 15.12.15.
//  Copyright (c) 2015 Alexander Wegner. All rights reserved.
//

import SpriteKit
import AVFoundation
import Social

// Debugging
var strVersion = "ver 0.36"
var blGameTest = false
var blResetGameData = false
// --- Game positions ---
var flScreenWidth: CGFloat!
var flScreenHeight: CGFloat!
var flShipPosX: CGFloat!
var flShipPosY: CGFloat!
// --- game attributes ---
var SDGameData: TLSaveData!
var GameData: TLGameData!
var blScoreSwitchChecked = true
let strHighscoreDummy = "0"+"\t"+"0"+"\t"+"-"+"\t"+"0"+"\t"+"0"+"\t"+"-"+"\t"+"0"+"\t"+"0"+"\t"+"-"+"\t"+"0"+"\t"+"0"+"\t"+"-"+"\t"+"0"+"\t"+"0"+"\t"+"-"
//let strHighscoreDummy = "1"+"\t"+"11"+"\t"+"111"+"\t"+"2"+"\t"+"22"+"\t"+"222"+"\t"+"3"+"\t"+"33"+"\t"+"333"+"\t"+"4"+"\t"+"44"+"\t"+"444"+"\t"+"5"+"\t"+"55"+"\t"+"555"
var aSkHighscoresColumns = 4
var aSkHighscoresRows = 5
var iGameScore = 0
var blGameOver = false
var blBombFired: Bool!
var iSelectedWeapon: Int! // 0: Laser 1: Laser sphere 2: Laser cone
var blLaserSpherePickedUp = false
var blLaserConePickedUp = false
// --- game speed ---
let flmeteoriteSpeedInit = Double(2.9)
let imeteoriteSpawnTimeInit = 18
var flmeteoriteSpeed: Double!
var imeteoriteSpawnTime: Int!
let iSpeedUpateCycleTimeSec = 18
let iLaserShootInterval = 4
let iLaserConeShootInterval = 4
let iLaserSphereShootInterval = 10
// --- game objects ---
let imeteoriteSkinCnt = 6
var flmeteoriteSizeMax = CGFloat(120)
var flmeteoriteSizeMin = CGFloat(50)
var flShipSizeWidth = CGFloat(70)
var flShipSizeHeight = CGFloat(62)

var myLabel: SKLabelNode!
var lbGameScore: SKLabelNode!
var lbGameOver: SKLabelNode!
var lbGameTime: SKLabelNode!
var lbLifes: SKLabelNode!
var snBackground: TLBackground!
var snShip: TLShip!
var blGameStarted = false
var blLaserFired = false
var blLaserSphereFired = false
var blLaserConeFired = false

// --- game fonts ---
//let fnGameFont = UIFont(name: "HomespunTTBRK", size: 10)
//let fnGameFont = UIFont(name: "KarmaticArcade", size: 10)
//let fnGameFont = UIFont(name: "Menlo", size: 10)
//let fnGameFont = UIFont(name: "Masaaki-Regular", size: 10)
let fnGameFont = UIFont(name: "OrigamiMommy", size: 10)
let fnGameTextFont = UIFont(name: "Minecraft", size: 10)

var aExplosion_01 = Array<SKTexture>()

enum enBodyType: UInt32 {
    case ship = 1
    case laser = 2
    case meteorite = 4
    case powerup = 8
    case bomb = 16
    case bombExplosion = 32
    case laserSphere = 64
    case laserCone = 128
}
// Debug
var debug_LaserCnt = 0

class GameScene: SKScene, SKPhysicsContactDelegate, TLSocial {
    var apBackgroundMusic: AVAudioPlayer!
    var snInterfaceLeft: SKSpriteNode!
    var snInterfaceRight: SKSpriteNode!
    var selectedNodes = [UITouch:SKSpriteNode]()
    var aSnLaser01 = Array<TLLaser>()
    var aSnLaserSphere = Array<TLLaserSphere>()
    var aSnLaserCone = Array<TLLaserCone>()
    var aSnPowerUp = Array<TLPowerUp>()
    var aSnmeteorite = Array<TLMeteorite>()
    var iTimeSec: Int!
    var iGameTimeSec: Int!
    var iTime100ms: Int!
    var iTime10ms: Int!
    var iLaserShootingPause: Int!
    var iLaserSphereShootingPause: Int!
    var iLaserConeShootingPause: Int!
    var iGameRestartCnt: Int!
    var snShieldBar1: SKSpriteNode!
    var snShieldBar2: SKSpriteNode!
    var snShieldBar3: SKSpriteNode!
    var snShieldBar4: SKSpriteNode!
    var snBomb1: SKSpriteNode!
    var snBomb2: SKSpriteNode!
    var snBomb3: SKSpriteNode!
    var snMenuPause: SKSpriteNode!
    var snMenuWeapons: SKSpriteNode!
    var iBombCount: Int!
    var snPowerUpInvFrame: SKSpriteNode!
    var snPowerUpInv: SKSpriteNode!
    var lbPowerUpInv: SKLabelNode!
    var snPause: SKShapeNode!
    var lbPause: SKLabelNode!
    var flTouchMoveDist: CGFloat!
    var snBombFired: TLBomb!
    var snNebula: TLNebula!
    var snInventory: TLInventory!
    var iButtonPressed: Int!
    var apClick: AVAudioPlayer!
    var snMenuBack: SKSpriteNode!
    var snMenuQuit: SKSpriteNode!
    var lbMenuQuit: SKLabelNode!
    var lbHighscoreTextLine1: SKLabelNode!
    var lbHighscoreTextLine2: SKLabelNode!
    var lbShareLine1: SKLabelNode!
    var snShareTwitter: SKSpriteNode!
    var snShareFacebook: SKSpriteNode!
    var snGameOverBack: SKSpriteNode!

    override func didMoveToView(view: SKView) {
        // --- collision setup ---
        physicsWorld.contactDelegate = self
        view.showsPhysics = false // #debug
        view.showsFPS = true
        // --- explosion sprites ---
        //let taExplosion_01 = SKTextureAtlas(named:"explosion.atlas")
        aExplosion_01.removeAll()
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_03_001"))
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_03_002"))
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_03_003"))
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_03_004"))
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_03_005"))
        aExplosion_01.append(SKTexture(imageNamed: "Media/explosion.atlas/explosion_03_006"))
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Could not create audio player: \(error)")
            return
        }

        // Game settings
        flmeteoriteSizeMax = CGFloat(120) * (self.frame.height/375.0)
        flmeteoriteSizeMin = CGFloat(50) * (self.frame.height/375.0)
        flShipSizeWidth = CGFloat(70) * (self.frame.width/667.0)
        flShipSizeHeight = CGFloat(62) * (self.frame.height/375.0)
        //
        iSelectedWeapon = 0
        flmeteoriteSpeed = flmeteoriteSpeedInit
        imeteoriteSpawnTime = imeteoriteSpawnTimeInit
        blBombFired = false
        flTouchMoveDist = 1000
        iGameTimeSec = 0
        iTimeSec = 0
        iTime100ms = 0
        iTime10ms = 0
        iLaserShootingPause = 0
        iLaserSphereShootingPause = 0
        iLaserConeShootingPause = 0
        iGameRestartCnt = 0
        iBombCount = 0
        flScreenWidth = view.frame.size.width
        flScreenHeight = view.frame.size.height
        iButtonPressed = 0
        
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        self.anchorPoint = CGPointMake(0, 0)
        
        snBackground = TLBackground(size: CGSizeMake(view.frame.width, view.frame.height))
        self.anchorPoint = CGPointMake(0.0, 0.0)
        //snGameMap.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        snBackground.position = CGPoint(x: 0, y: 0)
        addChild(snBackground)
        
//        snNebula = TLNebula(size: CGSizeMake(view.frame.width, view.frame.height))
//        snNebula.position = CGPoint(x: 0, y: 0)
//        addChild(snNebula)

        snShip = TLShip(size: CGSizeMake(flShipSizeWidth, flShipSizeHeight))
        snShip.position = CGPoint(x: 120.0 * (self.frame.width/667.0) , y: (view.frame.height/2) - (50 * (self.frame.height/375.0)))
        flShipPosX = snShip.position.x
        flShipPosY = snShip.position.y
        snShip.iHealth = 500
        addChild(snShip)

        myLabel = SKLabelNode(fontNamed: fnGameFont?.fontName)
        myLabel.text = "TOUCH TO START"
        myLabel.fontSize = 40 * (self.frame.width/667.0)
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - (myLabel.frame.size.height/2))
        myLabel.fontColor = UIColor.whiteColor()
        self.addChild(myLabel)
        myLabel.zPosition = 2.0
        
        // --- Interface ---
        // Game score
        lbGameScore = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbGameScore.text = "0"
        lbGameScore.fontSize = 22 * (self.frame.width/667.0)
        lbGameScore.position = CGPoint(x: CGRectGetMidX(self.frame) + (216  * (self.frame.width/667.0)), y: 14 * (self.frame.height/375.0))
        lbGameScore.fontColor = UIColor.orangeColor()
        lbGameScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        lbGameScore.zPosition = 2.0
        self.addChild(lbGameScore)
        // HUD sprites
        let snHud = SKSpriteNode(texture: SKTexture(imageNamed: "Media/hud_003.png"), color: UIColor.clearColor(), size: CGSizeMake(470 * (self.frame.width/667.0), 60 * (self.frame.height/375.0)))
        snHud.anchorPoint = CGPointMake(0.5, 0)
        snHud.position = CGPoint(x: CGRectGetMidX(self.frame), y: 3 * (self.frame.height/375.0))
        snHud.zPosition = 2.0
        snHud.alpha = 0.75
        addChild(snHud)
        // Game time
        lbGameTime = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbGameTime.text = "0"
        lbGameTime.fontSize = 20 * (self.frame.width/667.0)
        lbGameTime.position = CGPoint(x: CGRectGetMidX(self.frame), y: 24 * (self.frame.height/375.0))
        lbGameTime.fontColor = UIColor(red: 102/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        lbGameTime.zPosition = 2.0
        self.addChild(lbGameTime)
        // Shields
        // Menu sprite size
        let flShieldSprite1Width = (SKTexture(imageNamed: "Media/shield_point_001.png").size().width) * (self.frame.width/667.0)
        let flShieldSprite1Height = (SKTexture(imageNamed: "Media/shield_point_001.png").size().height) * (self.frame.height/375.0)
        let flShieldSprite2Width = (SKTexture(imageNamed: "Media/shield_point_002.png").size().width) * (self.frame.width/667.0)
        let flShieldSprite2Height = (SKTexture(imageNamed: "Media/shield_point_002.png").size().height) * (self.frame.height/375.0)
        // Shield bar 1
        snShieldBar1 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/shield_point_001.png"), color: UIColor.clearColor(), size: CGSizeMake(flShieldSprite1Width, flShieldSprite1Height))
        snShieldBar1.anchorPoint = CGPointMake(0.0, 0.5)
        snShieldBar1.position = CGPoint(x: CGRectGetMidX(self.frame) - (225 * (self.frame.width/667.0)), y: 23 * (self.frame.height/375.0))
        snShieldBar1.zPosition = 2.0
        snShieldBar1.alpha = 1.0
        self.addChild(snShieldBar1)
        // Shield bar 2
        snShieldBar2 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/shield_point_002.png"), color: UIColor.clearColor(), size: CGSizeMake(flShieldSprite2Width, flShieldSprite2Height))
        snShieldBar2.anchorPoint = CGPointMake(0.0, 0.5)
        snShieldBar2.position = CGPoint(x: CGRectGetMidX(self.frame) - (180 * (self.frame.width/667.0)), y: 23 * (self.frame.height/375.0))
        snShieldBar2.zPosition = 2.0
        snShieldBar2.alpha = 1.0
        self.addChild(snShieldBar2)
        // Shield bar 3
        snShieldBar3 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/shield_point_002.png"), color: UIColor.clearColor(), size: CGSizeMake(flShieldSprite2Width, flShieldSprite2Height))
        snShieldBar3.anchorPoint = CGPointMake(0.0, 0.5)
        snShieldBar3.position = CGPoint(x: CGRectGetMidX(self.frame) - (136 * (self.frame.width/667.0)), y: 23 * (self.frame.height/375.0))
        snShieldBar3.zPosition = 2.0
        snShieldBar3.alpha = 1.0
        self.addChild(snShieldBar3)
        // Shield bar 4
        snShieldBar4 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/shield_point_002.png"), color: UIColor.clearColor(), size: CGSizeMake(flShieldSprite2Width, flShieldSprite2Height))
        snShieldBar4.anchorPoint = CGPointMake(0.0, 0.5)
        snShieldBar4.position = CGPoint(x: CGRectGetMidX(self.frame) - (92 * (self.frame.width/667.0)), y: 23 * (self.frame.height/375.0))
        snShieldBar4.zPosition = 2.0
        snShieldBar4.alpha = 1.0
        self.addChild(snShieldBar4)
        fctUpdateShields()
        // Bombs
        let flBombWidth = (SKTexture(imageNamed: "Media/pu_bomb_001_empty.png").size().width) * (self.frame.width/667.0)
        let flBombHeight = (SKTexture(imageNamed: "Media/pu_bomb_001_empty.png").size().height) * (self.frame.height/375.0)
        // Bomb 1
        snBomb1 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/pu_bomb_001_empty.png"), color: UIColor.clearColor(), size: CGSizeMake(flBombWidth, flBombHeight))
        snBomb1.anchorPoint = CGPointMake(0.5, 0.5)
        snBomb1.position = CGPoint(x: CGRectGetMidX(self.frame) - (180 * (self.frame.width/667.0)), y: 60 * (self.frame.height/375.0))
        snBomb1.zPosition = 2.0
        snBomb1.alpha = 1.0
        self.addChild(snBomb1)
        // Bomb 2
        snBomb2 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/pu_bomb_001_empty.png"), color: UIColor.clearColor(), size: CGSizeMake(flBombWidth, flBombHeight))
        snBomb2.anchorPoint = CGPointMake(0.5, 0.5)
        snBomb2.position = CGPoint(x: CGRectGetMidX(self.frame) - (145 * (self.frame.width/667.0)), y: 60 * (self.frame.height/375.0))
        snBomb2.zPosition = 2.0
        snBomb2.alpha = 1.0
        self.addChild(snBomb2)
        // Bomb 3
        snBomb3 = SKSpriteNode(texture: SKTexture(imageNamed: "Media/pu_bomb_001_empty.png"), color: UIColor.clearColor(), size: CGSizeMake(flBombWidth, flBombHeight))
        snBomb3.anchorPoint = CGPointMake(0.5, 0.5)
        snBomb3.position = CGPoint(x: CGRectGetMidX(self.frame) - (110 * (self.frame.width/667.0)), y: 60 * (self.frame.height/375.0))
        snBomb3.zPosition = 2.0
        snBomb3.alpha = 1.0
        self.addChild(snBomb3)
        // Menus
        let flMenuWidth = (SKTexture(imageNamed: "Media/hud_pause.png").size().width) * (self.frame.width/667.0) * 0.85
        let flMenuHeight = (SKTexture(imageNamed: "Media/hud_pause.png").size().height) * (self.frame.height/375.0) * 0.85
        // Pause menu
        snMenuPause = SKSpriteNode(texture: SKTexture(imageNamed: "Media/hud_pause.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuWidth, flMenuHeight))
        snMenuPause.anchorPoint = CGPointMake(1.0, 1.0)
        snMenuPause.position = CGPoint(x: CGRectGetMidX(self.frame) - (2 * (self.frame.width/667.0)), y: self.frame.height - (3 * (self.frame.height/375.0)))
        snMenuPause.zPosition = 2.0
        snMenuPause.alpha = 0.75
        snMenuPause.name = "MenuPause"
        self.addChild(snMenuPause)
        // Weapons menu
        snMenuWeapons = SKSpriteNode(texture: SKTexture(imageNamed: "Media/hud_weapons.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuWidth, flMenuHeight))
        snMenuWeapons.anchorPoint = CGPointMake(0.0, 1.0)
        snMenuWeapons.position = CGPoint(x: CGRectGetMidX(self.frame) + (2 * (self.frame.width/667.0)), y: self.frame.height - (3 * (self.frame.height/375.0)))
        snMenuWeapons.zPosition = 2.0
        snMenuWeapons.alpha = 0.75
        snMenuWeapons.name = "MenuWeapons"
        self.addChild(snMenuWeapons)
        // "Power up to inventory" frame sprite
        let flOptCheckboxWidth = (SKTexture(imageNamed: "Media/checkbox_checked.png").size().width) * (self.frame.width/667.0)
        let flOptCheckboxHeight = (SKTexture(imageNamed: "Media/checkbox_checked.png").size().height) * (self.frame.height/375.0)
        snPowerUpInvFrame = SKSpriteNode(texture: SKTexture(imageNamed: "Media/checkbox_unchecked.png"), color: UIColor.clearColor(), size: CGSizeMake(flOptCheckboxWidth, flOptCheckboxHeight))
        snPowerUpInvFrame.anchorPoint = CGPointMake(0.5, 0.5)
        snPowerUpInvFrame.position = CGPoint(x: self.frame.width - (flOptCheckboxWidth/2) - (5 * (self.frame.width/667.0)), y: self.frame.height - (flOptCheckboxHeight/2) - (5 * (self.frame.height/375.0)))
        snPowerUpInvFrame.zPosition = 2.0
        snPowerUpInvFrame.alpha = 0.0
        self.addChild(snPowerUpInvFrame)
        // "Power up to inventory" item sprite
        let flPowerUpWidth = (SKTexture(imageNamed: "Media/pu_bomb_001.png").size().width) * (self.frame.width/667.0)
        let flPowerUpHeight = (SKTexture(imageNamed: "Media/pu_bomb_001.png").size().height) * (self.frame.height/375.0)
        snPowerUpInv = SKSpriteNode(texture: SKTexture(imageNamed: "Media/pu_bomb_001.png"), color: UIColor.clearColor(), size: CGSizeMake(flPowerUpWidth, flPowerUpHeight))
        snPowerUpInv.anchorPoint = CGPointMake(0.5, 0.5)
        snPowerUpInv.position = snPowerUpInvFrame.position
        snPowerUpInv.zPosition = 2.0
        snPowerUpInv.alpha = 0.0
        self.addChild(snPowerUpInv)
        // "Power up to inventory" text
        lbPowerUpInv = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lbPowerUpInv.text = ""
        lbPowerUpInv.horizontalAlignmentMode = .Right
        lbPowerUpInv.verticalAlignmentMode = .Center
        lbPowerUpInv.fontSize = 17 * (self.frame.width/667.0)
        lbPowerUpInv.position = snPowerUpInvFrame.position
        lbPowerUpInv.position.x = lbPowerUpInv.position.x - (flOptCheckboxWidth/2) - (5 * (self.frame.width/667.0))
        lbPowerUpInv.fontColor = UIColor.whiteColor()
        lbPowerUpInv.zPosition = 2.0
        lbPowerUpInv.alpha = 0.0
        self.addChild(lbPowerUpInv)
        // Highscore text line 1
        lbHighscoreTextLine1 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lbHighscoreTextLine1.text = ""
        lbHighscoreTextLine1.horizontalAlignmentMode = .Center
        lbHighscoreTextLine1.verticalAlignmentMode = .Center
        lbHighscoreTextLine1.fontSize = 20 * (self.frame.width/667.0)
        lbHighscoreTextLine1.position = CGPoint(x: CGRectGetMidX(self.frame), y: 9*(self.frame.height / 12))
        lbHighscoreTextLine1.fontColor = UIColor.whiteColor()
        lbHighscoreTextLine1.zPosition = 2.2
        lbHighscoreTextLine1.alpha = 0.0
        self.addChild(lbHighscoreTextLine1)
        // Highscore text line 2
        lbHighscoreTextLine2 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lbHighscoreTextLine2.text = ""
        lbHighscoreTextLine2.horizontalAlignmentMode = .Center
        lbHighscoreTextLine2.verticalAlignmentMode = .Center
        lbHighscoreTextLine2.fontSize = 20 * (self.frame.width/667.0)
        lbHighscoreTextLine2.position = CGPoint(x: CGRectGetMidX(self.frame), y: 8*(self.frame.height / 12))
        lbHighscoreTextLine2.fontColor = UIColor.whiteColor()
        lbHighscoreTextLine2.zPosition = 2.2
        lbHighscoreTextLine2.alpha = 0.0
        self.addChild(lbHighscoreTextLine2)
        // Share line 1
        lbShareLine1 = SKLabelNode(fontNamed: fnGameTextFont?.fontName)
        lbShareLine1.text = "Share your score: "
        lbShareLine1.horizontalAlignmentMode = .Right
        lbShareLine1.verticalAlignmentMode = .Center
        lbShareLine1.fontSize = 20 * (self.frame.width/667.0)
        lbShareLine1.position = CGPoint(x: CGRectGetMidX(self.frame) - 10, y: 3.5*(self.frame.height / 12))
        lbShareLine1.fontColor = UIColor.whiteColor()
        lbShareLine1.zPosition = 2.2
        lbShareLine1.alpha = 0.0
        self.addChild(lbShareLine1)
        // Share "Twitter" Sprite
        let flShareTwitterWidth = (SKTexture(imageNamed: "Media/about_icon_twitter.png").size().width) * (self.frame.width/667.0) / 2.5
        let flShareTwitterHeight = (SKTexture(imageNamed: "Media/about_icon_twitter.png").size().height) * (self.frame.height/375.0) / 2.5
        snShareTwitter = SKSpriteNode(texture: SKTexture(imageNamed: "Media/about_icon_twitter.png"), color: UIColor.clearColor(), size: CGSizeMake(flShareTwitterWidth, flShareTwitterHeight))
        snShareTwitter.anchorPoint = CGPointMake(0.0, 0.5)
        snShareTwitter.position = CGPoint(x: CGRectGetMidX(self.frame) + 10, y: 3.5*(self.frame.height / 12))
        snShareTwitter.zPosition = 2.2
        snShareTwitter.alpha = 0.0
        snShareTwitter.name = "ShareTwitter"
        self.addChild(snShareTwitter)
        // Share "Facebook" Sprite
        let flShareFacebookWidth = (SKTexture(imageNamed: "Media/about_icon_facebook.png").size().width) * (self.frame.width/667.0) / 2.5
        let flShareFacebookHeight = (SKTexture(imageNamed: "Media/about_icon_facebook.png").size().height) * (self.frame.height/375.0) / 2.5
        snShareFacebook = SKSpriteNode(texture: SKTexture(imageNamed: "Media/about_icon_facebook.png"), color: UIColor.clearColor(), size: CGSizeMake(flShareFacebookWidth, flShareFacebookHeight))
        snShareFacebook.anchorPoint = CGPointMake(0.0, 0.5)
        snShareFacebook.position = CGPoint(x: CGRectGetMidX(self.frame) + 70, y: 3.5*(self.frame.height / 12))
        snShareFacebook.zPosition = 2.2
        snShareFacebook.alpha = 0.0
        snShareFacebook.name = "ShareFacebook"
        self.addChild(snShareFacebook)
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
        // Home button settings
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "applicationWillResignActive:",
            name: UIApplicationWillResignActiveNotification,
            object: nil)
        
        fctNewGame()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if self.speed > 0.0 {
            if (blGameStarted == false) && (blGameOver == false) {
                self.fctPlayBackgroundMusic()
                myLabel.hidden = true
                blGameStarted = true
                blGameOver = false
                snBackground.fctMoveLeft()
            } else if blGameOver == false {
                
                if let location = touches.first?.locationInNode(self) {
                    let touchedNode = nodeAtPoint(location)
                    
                    switch (touchedNode.name) {
                    case "MenuPause"?:
                        iButtonPressed = 1
                        fctPlayClickSound()
                    case "MenuWeapons"?:
                        iButtonPressed = 2
                        fctPlayClickSound()
                    default:
                        for touch:AnyObject in touches {
                            if touch.locationInView(view).x <= (200.0 * (self.frame.height/375.0)) {
                                let deltaY = (view!.frame.height - touch.locationInView(view).y) - snShip.position.y
                                snShip.fctMoveShipByY(deltaY)
                                //print("left")
                            } else {
                                flTouchMoveDist = touch.locationInView(view).x
                                switch (iSelectedWeapon) {
                                case 0:
                                    if blLaserFired == false {
                                        blLaserFired = true
                                        iLaserShootingPause = 0
                                        self.fctShootLaser01()
                                    }
                                case 1:
                                    if blLaserSphereFired == false {
                                        blLaserSphereFired = true
                                        iLaserSphereShootingPause = 0
                                        self.fctShootLaserSphere()
                                        print("Laser spheres: " + String(aSnLaserSphere.count)) // #debug
                                    }
                                case 2:
                                    if blLaserConeFired == false {
                                        blLaserConeFired = true
                                        iLaserConeShootingPause = 0
                                        self.fctShootLaserCone()
                                        print("Laser cones: " + String(aSnLaserCone.count)) // #debug
                                    }
                                default:
                                    ()
                                }
                            }
                        }
                    }
                }
                
            }
            if (blGameOver == true) {
                if let location = touches.first?.locationInNode(self) {
                    let touchedNode = nodeAtPoint(location)
                    
                    switch (touchedNode.name) {
                    case "ShareTwitter"?:
                        iButtonPressed = 8
                        fctPlayClickSound()
                    case "ShareFacebook"?:
                        iButtonPressed = 9
                        fctPlayClickSound()
                    case "GameOverBack"?:
                        iButtonPressed = 10
                        snGameOverBack.texture = SKTexture(imageNamed: "Media/menu_back_pressed.png")
                        fctPlayClickSound()
                    default:
                        ()
                    }
                }
            }
        } else {
            if let location = touches.first?.locationInNode(self) {
                let touchedNode = nodeAtPoint(location)
                
                switch (touchedNode.name) {
                case "MenuBack"?:
                    iButtonPressed = 3
                    if snMenuBack != nil {
                        snMenuBack.texture = SKTexture(imageNamed: "Media/menu_back_pressed.png")
                    }
                    if snInventory != nil {
                        snInventory.snMenuBack.texture = SKTexture(imageNamed: "Media/menu_back_pressed.png")
                    }
                    fctPlayClickSound()
                case "MenuQuit"?:
                    iButtonPressed = 4
                    snMenuQuit.texture = SKTexture(imageNamed: "Media/menu_bottom_pressed.png")
                    lbMenuQuit.fontColor = UIColor.blackColor()
                    fctPlayClickSound()
                case "MenuWpnLaserCone"?:
                    if blLaserConePickedUp == true {
                        iButtonPressed = 5
                        fctPlayClickSound()
                    }
                case "MenuWpnLaser"?:
                    iButtonPressed = 6
                    fctPlayClickSound()
                case "MenuWpnLaserSphere"?:
                    if blLaserSpherePickedUp == true {
                        iButtonPressed = 7
                        fctPlayClickSound()
                    }
                default:
                    ()
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (blGameOver == false) && (blGameStarted == true) && (self.speed > 0.0) {
            for touch in touches {
                if touch.locationInView(view).x <= (200.0 * (self.frame.height/375.0)) {
                    let deltaY = (view!.frame.height - touch.locationInView(view).y) - snShip.position.y
                    if (deltaY >= (3 * (self.frame.height/375.0)) && deltaY <= (50 * (self.frame.height/375.0))) {
                        snShip.fctStartFlyAnimationLeft()
                        snShip.position.y = snShip.position.y + deltaY
                    } else if (deltaY <= (-3 * (self.frame.height/375.0)) && deltaY >= (-50 * (self.frame.height/375.0))) {
                        snShip.fctStartFlyAnimationRight()
                        snShip.position.y = snShip.position.y + deltaY
                    } else if (deltaY < (3 * (self.frame.height/375.0)) && deltaY > (-3 * (self.frame.height/375.0))) {
                        //snShip.fctStartFlyAnimationFront()
                    } else {
                        snShip.fctMoveShipByY(deltaY)
                    }
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Reset pressed sprites
        if snMenuBack != nil {
            snMenuBack.texture = SKTexture(imageNamed: "Media/menu_back.png")
        }
        if snMenuQuit != nil {
            snMenuQuit.texture = SKTexture(imageNamed: "Media/menu_bottom.png")
        }
        if lbMenuQuit != nil {
            lbMenuQuit.fontColor = UIColor.whiteColor()
        }
        if snGameOverBack != nil {
            snGameOverBack.texture = SKTexture(imageNamed: "Media/menu_back.png")
        }
        if snInventory != nil {
            snInventory.snMenuBack.texture = SKTexture(imageNamed: "Media/menu_back.png")
        }
        // Screen elements
        if (blGameOver == false)  && (blGameStarted == true) {
            snShip.fctStartFlyAnimationFront()
        }
        if (blGameOver == true) {
            if let location = touches.first?.locationInNode(self) {
                let touchedNode = nodeAtPoint(location)
                
                switch (touchedNode.name) {
                case "ShareTwitter"?:
                    if (iButtonPressed == 8) {
                        shareToTwitter()
                    }
                case "ShareFacebook"?:
                    if (iButtonPressed == 9) {
                        shareToFacebook()
                    }
                case "GameOverBack"?:
                    if (iButtonPressed == 10) {
                        snShip.removeFromParent()
                        //fctNewGame()
                        let transition = SKTransition.fadeWithColor(.blackColor(), duration: 0.3)
                        
                        let nextScene = TLGameMenu(size: self.scene!.size)
                        nextScene.scaleMode = .AspectFill
                        
                        self.scene?.view?.presentScene(nextScene, transition: transition)
                        //fctNewGame()
                        //self.delete(self)
                        fctNewGame()
                    }
                default:
                    ()
                }
            }
        }
        if (blGameOver == false)  && (blGameStarted == true) {
            if self.speed > 0.0 {
                for touch in touches {
                    if touch.locationInView(view).x <= (200.0 * (self.frame.height/375.0)) {
                        let deltaY = (view!.frame.height - touch.locationInView(view).y) - snShip.position.y
                        snShip.fctMoveShipByY(deltaY)
                    }
                }
            }
            if let location = touches.first?.locationInNode(self) {
                let touchedNode = nodeAtPoint(location)
                
                switch (touchedNode.name) {
                case "MenuPause"?:
                    if (iButtonPressed == 1) && (self.speed > 0.0) {
                        //snInventory.zPosition = 2.2
                        self.speed = 0.0
                        //self.view!.paused = true
                        print("Paused!")
                        // Pause screen sprite
                        snPause = SKShapeNode(rectOfSize: CGSize(width: self.frame.width, height: self.frame.height))
                        snPause.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
                        snPause.strokeColor = SKColor.blackColor()
                        snPause.glowWidth = 0.0
                        snPause.lineWidth = 0.0
                        snPause.fillColor = SKColor.blackColor()
                        snPause.zPosition = 2.1
                        snPause.alpha = 0.8
                        self.addChild(snPause)
                        // Pause screen text
                        lbPause = SKLabelNode(fontNamed: fnGameFont?.fontName)
                        lbPause.text = "PAUSED"
                        lbPause.horizontalAlignmentMode = .Center
                        lbPause.verticalAlignmentMode = .Center
                        lbPause.fontSize = 60 * (self.frame.width/667.0)
                        lbPause.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
                        lbPause.fontColor = UIColor.whiteColor()
                        lbPause.zPosition = 2.1
                        lbPause.alpha = 1.0
                        self.addChild(lbPause)
                        // Menu "Back" Sprite
                        let flMenuBackSpriteWidth = (SKTexture(imageNamed: "Media/menu_back.png").size().width) * (self.frame.width/667.0)
                        let flMenuBackSpriteHeight = (SKTexture(imageNamed: "Media/menu_back.png").size().height) * (self.frame.height/375.0)
                        snMenuBack = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_back.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuBackSpriteWidth, flMenuBackSpriteHeight))
                        snMenuBack.anchorPoint = CGPointMake(0.0, 0.5)
                        snMenuBack.position = CGPoint(x: 1*(self.frame.width / 16), y: 10*(self.frame.height / 12))
                        snMenuBack.zPosition = 2.2
                        snMenuBack.alpha = 1.0
                        snMenuBack.name = "MenuBack"
                        self.addChild(snMenuBack)
                        // Menu "About" Sprite
                        let flMenuSpriteWidth = (SKTexture(imageNamed: "Media/menu_top.png").size().width) * (self.frame.width/667.0)
                        let flMenuSpriteHeight = (SKTexture(imageNamed: "Media/menu_top.png").size().height) * (self.frame.height/375.0)
                        snMenuQuit = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_bottom.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuSpriteWidth, flMenuSpriteHeight))
                        snMenuQuit.anchorPoint = CGPointMake(0.5, 0.5)
                        snMenuQuit.position = CGPoint(x: CGRectGetMidX(self.frame), y: 2*(self.frame.height / 12))
                        snMenuQuit.zPosition = 2.2
                        snMenuQuit.alpha = 1.0
                        snMenuQuit.name = "MenuQuit"
                        addChild(snMenuQuit)
                        // Menu "About" Text
                        lbMenuQuit = SKLabelNode(fontNamed: fnGameFont?.fontName)
                        lbMenuQuit.horizontalAlignmentMode = .Center;
                        lbMenuQuit.verticalAlignmentMode = .Center
                        lbMenuQuit.text = "QUIT"
                        lbMenuQuit.fontSize = 30 * (self.frame.width/667.0)
                        lbMenuQuit.position = CGPoint(x: CGRectGetMidX(self.frame), y: 2*(self.frame.height / 12))
                        lbMenuQuit.fontColor = UIColor.whiteColor()
                        lbMenuQuit.zPosition = 2.2
                        lbMenuQuit.name = "MenuQuit"
                        self.addChild(lbMenuQuit)
                    }
                case "MenuWeapons"?:
                    if (iButtonPressed == 2) && (self.speed > 0.0) {
                        //snInventory.zPosition = 2.2
                        self.speed = 0.0
                        //self.view!.paused = true
                        print("Paused!")
                        // Inventory
                        snInventory = TLInventory(size: CGSize(width: self.frame.width, height: self.frame.height))
                        snInventory.zPosition = 2.2
                        self.addChild(snInventory)
                    }
                case "MenuBack"?:
                    if (iButtonPressed == 3) && (self.speed == 0.0) {
                        self.speed = 1.0
                        if snPause != nil {
                            snPause.removeFromParent()
                        }
                        if lbPause != nil {
                            lbPause.removeFromParent()
                        }
                        if snMenuBack != nil {
                            snMenuBack.removeFromParent()
                        }
                        if snMenuQuit != nil {
                            snMenuQuit.removeFromParent()
                        }
                        if lbMenuQuit != nil {
                            lbMenuQuit.removeFromParent()
                        }
                        if snInventory != nil {
                            snInventory.removeFromParent()
                        }
                    }
                case "MenuQuit"?:
                    if (iButtonPressed == 4) && (self.speed == 0.0) {
                        fctGameOver()
                        let transition = SKTransition.fadeWithColor(.blackColor(), duration: 0.2)
                        let nextScene = TLGameMenu(size: scene!.size)
                        nextScene.scaleMode = .AspectFill
                        scene?.view?.presentScene(nextScene, transition: transition)
                        snMenuQuit.removeFromParent()
                        lbMenuQuit.removeFromParent()
                        self.removeFromParent()
                    }
                case "MenuWpnLaserCone"?:
                    if (iButtonPressed == 5) && (self.speed == 0.0) {
                        if blLaserConePickedUp == true {
                            iSelectedWeapon = 2
                            snInventory.fctUpdateWpns()
                        }
                    }
                case "MenuWpnLaser"?:
                    if (iButtonPressed == 6) && (self.speed == 0.0) {
                        iSelectedWeapon = 0
                        snInventory.fctUpdateWpns()
                    }
                case "MenuWpnLaserSphere"?:
                    if (iButtonPressed == 7) && (self.speed == 0.0) {
                        if blLaserSpherePickedUp == true {
                            iSelectedWeapon = 1
                            snInventory.fctUpdateWpns()
                        }
                    }
                default:
                    ()
                }
            }
            
            iButtonPressed = 0
            
            for touch in touches {
                if touch.locationInView(view).x >= (200.0 * (self.frame.height/375.0)) {
                    if touch.locationInView(view).x - flTouchMoveDist >= 100 {
                        // Finger moved detected
                        if (blBombFired == false) && (iBombCount > 0) {
                            iBombCount = iBombCount - 1
                            fctUpdateBombs()
                            fctShootBomb()
                        }
                    }
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if self.speed > 0.0 {
            /* Called before each frame is rendered */
            flShipPosX = snShip.position.x
            flShipPosY = snShip.position.y
            // --- every 10ms ---
            if iTime10ms != Int(currentTime * 10) {
                iTime10ms = Int(currentTime * 10)
                if blLaserFired == true {
                    //print(iLaserShootingPause) // #debug
                    iLaserShootingPause = iLaserShootingPause + 1
                    if iLaserShootingPause >= iLaserShootInterval {
                        iLaserShootingPause = 0
                        blLaserFired = false
                    }
                }
                if blLaserSphereFired == true {
                    iLaserSphereShootingPause = iLaserSphereShootingPause + 1
                    if iLaserSphereShootingPause >= iLaserSphereShootInterval {
                        iLaserSphereShootingPause = 0
                        blLaserSphereFired = false
                    }
                }
                if blLaserConeFired == true {
                    iLaserConeShootingPause = iLaserConeShootingPause + 1
                    if iLaserConeShootingPause >= iLaserConeShootInterval {
                        iLaserConeShootingPause = 0
                        blLaserConeFired = false
                    }
                }
            }
            // --- every 100ms ---
            if iTime100ms != Int(currentTime * 10) {
                iTime100ms = Int(currentTime * 10)
                if blGameOver == true {
                    iGameRestartCnt = iGameRestartCnt + 1
                }
                if (iTime100ms % imeteoriteSpawnTime == 0) && (blGameOver == false) && (blGameStarted == true) {
                    let flMetSize = CGFloat(arc4random_uniform(UInt32(flmeteoriteSizeMax - flmeteoriteSizeMin)) + 1 + UInt32(flmeteoriteSizeMin))
                    let flRotSpeed = CGFloat(arc4random_uniform(5) + 1 + 5)
                    var iRotDirec = Int(arc4random_uniform(2))
                    if iRotDirec == 0 {
                        iRotDirec = -1
                    }
                    if aSnmeteorite.count == 0
                    {
                        aSnmeteorite.append(TLMeteorite(size: CGSizeMake(flMetSize, flMetSize), rotSpeed: flRotSpeed, rotDirec: iRotDirec))
                        aSnmeteorite[0].blActive = false
                    }
                    allElements: for i in 0 ..< aSnmeteorite.count {
                        if aSnmeteorite[i].blActive == false {
                            aSnmeteorite[i] = TLMeteorite(size: CGSizeMake(flMetSize, flMetSize), rotSpeed: flRotSpeed, rotDirec: iRotDirec)
                            aSnmeteorite[i].blActive = true
                            addChild(aSnmeteorite[i])
                            aSnmeteorite[i].fctMoveLeft()
                            break allElements
                        }
                        if i == (aSnmeteorite.count - 1) {
                            aSnmeteorite.append(TLMeteorite(size: CGSizeMake(flMetSize, flMetSize), rotSpeed: flRotSpeed, rotDirec: iRotDirec))
                            aSnmeteorite[i+1].blActive = true
                            addChild(aSnmeteorite[i+1])
                            aSnmeteorite[i+1].fctMoveLeft()
                            break allElements
                        }
                    }
                }
                
                // --- every 1s
                if (iTime100ms % 10 == 0) && (blGameOver == false) && (blGameStarted == true) {
                    iGameTimeSec = iGameTimeSec + 1
                    lbGameTime.text = String(iGameTimeSec)
                    if iGameTimeSec % iSpeedUpateCycleTimeSec == 0 {
                        if flmeteoriteSpeed > 0.1 {
                            flmeteoriteSpeed = flmeteoriteSpeed - 0.1
                        }
                        if imeteoriteSpawnTime > 4 {
                            imeteoriteSpawnTime = imeteoriteSpawnTime - 1
                        }
                    }
                }
            }
        }
    }
    
    func fctPlayBackgroundMusic() {
        if GameData.blMusicEnabled == true {
            let path = NSBundle.mainBundle().pathForResource("Media/sounds/music_001", ofType:"mp3")
            let fileURL = NSURL(fileURLWithPath: path!)
            do {
                try apBackgroundMusic = AVAudioPlayer(contentsOfURL: fileURL, fileTypeHint: nil)
            } catch {
                print("Could not create audio player: \(error)")
                return
            }
            apBackgroundMusic.numberOfLoops = -1
            apBackgroundMusic.volume = GameData.flMusicVolume
            apBackgroundMusic.prepareToPlay()
            apBackgroundMusic.play()
        }
    }
    
    func fctShootLaser01() {
        //snLaser.removeAllActions()
        if aSnLaser01.count == 0
        {
            aSnLaser01.append(TLLaser(size: CGSizeMake(60 * (self.frame.width/667.0), 5 * (self.frame.height/375.0))))
            aSnLaser01[0].blActive = false
        }
        allElements: for i in 0 ..< aSnLaser01.count {
            if aSnLaser01[i].blActive == false {
                aSnLaser01[i] = TLLaser(size: CGSizeMake(60 * (self.frame.width/667.0), 5 * (self.frame.height/375.0)))
                aSnLaser01[i].blActive = true
                addChild(aSnLaser01[i])
                aSnLaser01[i].fctMoveRight()
                aSnLaser01[i].fctPlayShootingSound()
                break allElements
            }
            if i == (aSnLaser01.count - 1) {
                aSnLaser01.append(TLLaser(size: CGSizeMake(60 * (self.frame.width/667.0), 5 * (self.frame.height/375.0))))
                aSnLaser01[i+1].blActive = true
                addChild(aSnLaser01[i+1])
                aSnLaser01[i+1].fctMoveRight()
                aSnLaser01[i+1].fctPlayShootingSound()
                break allElements
            }
        }
    }
    
    func fctShootLaserSphere() {
        //snLaser.removeAllActions()
        if aSnLaserSphere.count == 0
        {
            aSnLaserSphere.append(TLLaserSphere(size: CGSizeMake(41 * (self.frame.width/667.0), 41 * (self.frame.height/375.0))))
            aSnLaserSphere[0].blActive = false
        }
        allElements: for i in 0 ..< aSnLaserSphere.count {
            if aSnLaserSphere[i].blActive == false {
                aSnLaserSphere[i] = TLLaserSphere(size: CGSizeMake(41 * (self.frame.width/667.0), 41 * (self.frame.height/375.0)))
                aSnLaserSphere[i].blActive = true
                addChild(aSnLaserSphere[i])
                aSnLaserSphere[i].fctMoveRight()
                aSnLaserSphere[i].fctPlayShootingSound()
                break allElements
            }
            if i == (aSnLaserSphere.count - 1) {
                aSnLaserSphere.append(TLLaserSphere(size: CGSizeMake(41 * (self.frame.width/667.0), 41 * (self.frame.height/375.0))))
                aSnLaserSphere[i+1].blActive = true
                addChild(aSnLaserSphere[i+1])
                aSnLaserSphere[i+1].fctMoveRight()
                aSnLaserSphere[i+1].fctPlayShootingSound()
                break allElements
            }
        }
    }
    
    func fctShootLaserCone() {
        for iAngle in 0 ..< 3 {
            if aSnLaserCone.count == 0
            {
                aSnLaserCone.append(TLLaserCone(size: CGSizeMake(40 * (self.frame.width/667.0), 5 * (self.frame.height/375.0)), angle: iAngle))
                aSnLaserCone[0].blActive = false
            }
            allElements: for i in 0 ..< aSnLaserCone.count {
                if aSnLaserCone[i].blActive == false {
                    aSnLaserCone[i] = TLLaserCone(size: CGSizeMake(40 * (self.frame.width/667.0), 5 * (self.frame.height/375.0)), angle: iAngle)
                    aSnLaserCone[i].blActive = true
                    addChild(aSnLaserCone[i])
                    aSnLaserCone[i].fctMove(iAngle)
                    aSnLaserCone[i].fctPlayShootingSound()
                    break allElements
                }
                if i == (aSnLaserCone.count - 1) {
                    aSnLaserCone.append(TLLaserCone(size: CGSizeMake(40 * (self.frame.width/667.0), 5 * (self.frame.height/375.0)), angle: iAngle))
                    aSnLaserCone[i+1].blActive = true
                    addChild(aSnLaserCone[i+1])
                    aSnLaserCone[i+1].fctMove(iAngle)
                    aSnLaserCone[i+1].fctPlayShootingSound()
                    break allElements
                }
            }
        }
    }
    
    func fctShootBomb() {
        blBombFired = true
        snBombFired = TLBomb(size: CGSizeMake(25 * (self.frame.width/667.0), 25 * (self.frame.height/375.0)))
        self.addChild(snBombFired)
        print("Bomb fired") // #debug
        snBombFired.fctMoveRight()
        snBombFired.fctPlayShootingSound()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if blGameOver == false {
            switch(contactMask) {
            // Laser hits meteorite
            case enBodyType.laser.rawValue | enBodyType.meteorite.rawValue:
                let secondNode = contact.bodyB.node
                let firstNode = contact.bodyA.node
                for i in 0 ..< aSnmeteorite.count {
                    if (secondNode == aSnmeteorite[i] || firstNode == aSnmeteorite[i]) && (aSnmeteorite[i].blDestroyed == false) {
                        aSnmeteorite[i].iHealth -= 100
                        if aSnmeteorite[i].iHealth <= 0 {
                            if aSnmeteorite[i].iPowerUp > 0 {
                                if aSnPowerUp.count == 0 {
                                    aSnPowerUp.append(TLPowerUp(size: CGSizeMake(30 * (self.frame.width/667.0), 30 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp))
                                    aSnPowerUp[0].blActive = false
                                }
                                allElements: for j in 0 ..< aSnPowerUp.count {
                                    if aSnPowerUp[j].blActive == false {
                                        aSnPowerUp[j] = TLPowerUp(size: CGSizeMake(30 * (self.frame.width/667.0), 30 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp)
                                        aSnPowerUp[j].blActive = true
                                        addChild(aSnPowerUp[j])
                                        aSnPowerUp[j].fctMoveLeft()
                                        break allElements
                                    }
                                    if j == (aSnPowerUp.count - 1) {
                                        aSnPowerUp.append(TLPowerUp(size: CGSizeMake(30 * (self.frame.width/667.0), 30 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp))
                                        aSnPowerUp[j+1].blActive = true
                                        addChild(aSnPowerUp[j+1])
                                        aSnPowerUp[j+1].fctMoveLeft()
                                        break allElements
                                    }
                                }
                            }
                            aSnmeteorite[i].fctExplode()
                        } else {
                            // ToDo
                            //aSnmeteorite[i].fctHit()
                        }
                    }
                }
                for i in 0 ..< aSnLaser01.count {
                    if (secondNode == aSnLaser01[i] || firstNode == aSnLaser01[i]) && (aSnLaser01[i].blDestroyed == false)  {
                        aSnLaser01[i].physicsBody?.categoryBitMask = 0
                        aSnLaser01[i].physicsBody?.contactTestBitMask = 0
                        aSnLaser01[i].fctExplode()
                    }
                }
            // Ship hits meteorite
            case (enBodyType.ship.rawValue | enBodyType.meteorite.rawValue):
                if blGameTest == false {
                    let secondNode = contact.bodyB.node
                    let firstNode = contact.bodyA.node
                    for i in 0 ..< aSnmeteorite.count {
                        if secondNode == aSnmeteorite[i] || firstNode == aSnmeteorite[i] {
                            if aSnmeteorite[i].blDestroyed == false {
                                if snShip.iHealth > 100 {
                                    fctFadeInOutSKSpriteNode(snShip.snShipShield, time: 0.5, alpha: 0.75, pause: 0.1)
                                }
                                snShip.iHealth = snShip.iHealth - aSnmeteorite[i].iDamage
                                aSnmeteorite[i].iHealth = 0
                                aSnmeteorite[i].physicsBody?.categoryBitMask = 0
                                aSnmeteorite[i].physicsBody?.contactTestBitMask = 0
                                fctUpdateShields()
                                if aSnmeteorite[i].iPowerUp == 1 {
                                    iGameScore = iGameScore + 300
                                    if iBombCount < 3 {
                                        self.iBombCount = iBombCount + 1
                                        fctUpdateBombs()
                                        lbPowerUpInv.text = "Bombs +1"
                                    } else {
                                        lbPowerUpInv.text = "Bomb inventory full"
                                    }
                                    snPowerUpInv.texture = SKTexture(imageNamed: "Media/pu_bomb_001.png")
                                    fctFadeInOutSKSpriteNode(snPowerUpInvFrame, time: 1, alpha: 0.75, pause: 2)
                                    fctFadeInOutSKSpriteNode(snPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                    fctFadeInOutSKLabelNode(lbPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                }
                                if aSnmeteorite[i].iPowerUp == 2 {
                                    iGameScore = iGameScore + 300
                                    if snShip.iHealth < 500 {
                                        snShip.iHealth = snShip.iHealth + 100
                                        fctUpdateShields()
                                        lbPowerUpInv.text = "Shields +25%"
                                    } else {
                                        lbPowerUpInv.text = "Shields at 100%"
                                    }
                                    snPowerUpInv.texture = SKTexture(imageNamed: "Media/pu_shield_001.png")
                                    fctFadeInOutSKSpriteNode(snPowerUpInvFrame, time: 1, alpha: 0.75, pause: 2)
                                    fctFadeInOutSKSpriteNode(snPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                    fctFadeInOutSKLabelNode(lbPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                }
                                if aSnmeteorite[i].iPowerUp == 3 {
                                    iGameScore = iGameScore + 1000
                                    if blLaserSpherePickedUp == false {
                                        blLaserSpherePickedUp = true
                                        //iSelectedWeapon = 1
                                        lbPowerUpInv.text = "Weapon: Laser sphere"
                                    } else {
                                        lbPowerUpInv.text = "Weapon is already known"
                                    }
                                    snPowerUpInv.texture = SKTexture(imageNamed: "Media/pu_wpn_laser_sphere.png")
                                    fctFadeInOutSKSpriteNode(snPowerUpInvFrame, time: 1, alpha: 0.75, pause: 2)
                                    fctFadeInOutSKSpriteNode(snPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                    fctFadeInOutSKLabelNode(lbPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                }
                                if aSnmeteorite[i].iPowerUp == 4 {
                                    iGameScore = iGameScore + 1000
                                    if blLaserConePickedUp == false {
                                        blLaserConePickedUp = true
                                        //iSelectedWeapon = 2
                                        lbPowerUpInv.text = "Weapon: Laser cone"
                                    } else {
                                        lbPowerUpInv.text = "Weapon is already known"
                                    }
                                    snPowerUpInv.texture = SKTexture(imageNamed: "Media/pu_wpn_laser_cone.png")
                                    fctFadeInOutSKSpriteNode(snPowerUpInvFrame, time: 1, alpha: 0.75, pause: 2)
                                    fctFadeInOutSKSpriteNode(snPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                    fctFadeInOutSKLabelNode(lbPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                }
                                aSnmeteorite[i].fctExplode()
                            }
                        }
                    }
                    fctUpdateShields()
                    //print("ship health: " + String(snShip.iHealth)) // #debug
                    //snShip.removeFromParent()
                    if snShip.iHealth <= 0 {
                        self.fctGameOver()
                        self.fctCheckForNewHighscore()
                        self.fctSaveHighscoreData()
                        snShip.physicsBody?.categoryBitMask = 0
                        snShip.fctExplode()
                        blGameOver = true
                        iGameRestartCnt = 0
                    }
                }
            // Ship hits powerup
            case (enBodyType.ship.rawValue | enBodyType.powerup.rawValue):
                let secondNode = contact.bodyB.node
                let firstNode = contact.bodyA.node
                for i in 0 ..< aSnPowerUp.count {
                    if secondNode == aSnPowerUp[i] || firstNode == aSnPowerUp[i] {
                        if aSnPowerUp[i].blDestroyed == false {
                            aSnPowerUp[i].physicsBody?.categoryBitMask = 0
                            aSnPowerUp[i].physicsBody?.contactTestBitMask = 0
                            if aSnPowerUp[i].iPowerUp == 1 {
                                if iBombCount < 3 {
                                    self.iBombCount = iBombCount + 1
                                    fctUpdateBombs()
                                    lbPowerUpInv.text = "Bombs +1"
                                } else {
                                    lbPowerUpInv.text = "Bomb inventory full"
                                }
                                snPowerUpInv.texture = SKTexture(imageNamed: "Media/pu_bomb_001.png")
                                fctFadeInOutSKSpriteNode(snPowerUpInvFrame, time: 1, alpha: 0.75, pause: 2)
                                fctFadeInOutSKSpriteNode(snPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                fctFadeInOutSKLabelNode(lbPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                            }
                            if aSnPowerUp[i].iPowerUp == 2 {
                                if snShip.iHealth < 500 {
                                    snShip.iHealth = snShip.iHealth + 100
                                    fctUpdateShields()
                                    lbPowerUpInv.text = "Shields +25%"
                                } else {
                                    lbPowerUpInv.text = "Shields at 100%"
                                }
                                snPowerUpInv.texture = SKTexture(imageNamed: "Media/pu_shield_001.png")
                                fctFadeInOutSKSpriteNode(snPowerUpInvFrame, time: 1, alpha: 0.75, pause: 2)
                                fctFadeInOutSKSpriteNode(snPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                fctFadeInOutSKLabelNode(lbPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                            }
                            if aSnPowerUp[i].iPowerUp == 3 {
                                if blLaserSpherePickedUp == false {
                                    blLaserSpherePickedUp = true
                                    //iSelectedWeapon = 1
                                    lbPowerUpInv.text = "Weapon: Laser sphere"
                                } else {
                                    lbPowerUpInv.text = "Weapon is already known"
                                }
                                snPowerUpInv.texture = SKTexture(imageNamed: "Media/pu_wpn_laser_sphere.png")
                                fctFadeInOutSKSpriteNode(snPowerUpInvFrame, time: 1, alpha: 0.75, pause: 2)
                                fctFadeInOutSKSpriteNode(snPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                fctFadeInOutSKLabelNode(lbPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                            }
                            if aSnPowerUp[i].iPowerUp == 4 {
                                if blLaserConePickedUp == false {
                                    blLaserConePickedUp = true
                                    //iSelectedWeapon = 2
                                    lbPowerUpInv.text = "Weapon: Laser cone"
                                } else {
                                    lbPowerUpInv.text = "Weapon is already known"
                                }
                                snPowerUpInv.texture = SKTexture(imageNamed: "Media/pu_wpn_laser_cone.png")
                                fctFadeInOutSKSpriteNode(snPowerUpInvFrame, time: 1, alpha: 0.75, pause: 2)
                                fctFadeInOutSKSpriteNode(snPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                                fctFadeInOutSKLabelNode(lbPowerUpInv, time: 1, alpha: 0.75, pause: 2)
                            }
                            aSnPowerUp[i].fctExplode()
                            fctUpdateShields()
                        }
                    }
                }
            // meteorite hits meteorite
            case (enBodyType.meteorite.rawValue):
                let secondNode = contact.bodyB.node
                let firstNode = contact.bodyA.node
                for i in 0 ..< aSnmeteorite.count {
                    if (secondNode == aSnmeteorite[i] || firstNode == aSnmeteorite[i]) && (aSnmeteorite[i].blDestroyed == false) {
                        aSnmeteorite[i].physicsBody?.categoryBitMask = 0
                        aSnmeteorite[i].physicsBody?.contactTestBitMask = 0
                        aSnmeteorite[i].fctExplode()
                    }
                }
            // Bomb hits meteorite
            case enBodyType.bomb.rawValue | enBodyType.meteorite.rawValue:
                let secondNode = contact.bodyB.node
                let firstNode = contact.bodyA.node
                for i in 0 ..< aSnmeteorite.count {
                    if (secondNode == aSnmeteorite[i] || firstNode == aSnmeteorite[i]) && (aSnmeteorite[i].blDestroyed == false) {
                        aSnmeteorite[i].iHealth = 0
                        if aSnmeteorite[i].iHealth <= 0 {
                            if aSnmeteorite[i].iPowerUp > 0 {
                                if aSnPowerUp.count == 0 {
                                    aSnPowerUp.append(TLPowerUp(size: CGSizeMake(30 * (self.frame.width/667.0), 30 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp))
                                    aSnPowerUp[0].blActive = false
                                }
                                allElements: for j in 0 ..< aSnPowerUp.count {
                                    if aSnPowerUp[j].blActive == false {
                                        aSnPowerUp[j] = TLPowerUp(size: CGSizeMake(30 * (self.frame.width/667.0), 30 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp)
                                        aSnPowerUp[j].blActive = true
                                        addChild(aSnPowerUp[j])
                                        aSnPowerUp[j].fctMoveLeft()
                                        break allElements
                                    }
                                    if j == (aSnPowerUp.count - 1) {
                                        aSnPowerUp.append(TLPowerUp(size: CGSizeMake(30 * (self.frame.width/667.0), 30 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp))
                                        aSnPowerUp[j+1].blActive = true
                                        addChild(aSnPowerUp[j+1])
                                        aSnPowerUp[j+1].fctMoveLeft()
                                        break allElements
                                    }
                                }
                            }
                            aSnmeteorite[i].fctExplode()
                            snBombFired.fctExplode()
                            snBombFired.blExploded = true
                        } else {
                            // ToDo
                            //aSnmeteorite[i].fctHit()
                        }
                    }
                }
            // Bomb explosion hits meteorite
            case enBodyType.bombExplosion.rawValue | enBodyType.meteorite.rawValue:
                if snBombFired.blExploded == true {
                    let secondNode = contact.bodyB.node
                    let firstNode = contact.bodyA.node
                    for i in 0 ..< aSnmeteorite.count {
                        if (secondNode == aSnmeteorite[i] || firstNode == aSnmeteorite[i]) && (aSnmeteorite[i].blDestroyed == false){
                            aSnmeteorite[i].iHealth = 0
                            if aSnmeteorite[i].iHealth <= 0 {
                                if aSnmeteorite[i].iPowerUp > 0 {
                                    if aSnPowerUp.count == 0 {
                                        aSnPowerUp.append(TLPowerUp(size: CGSizeMake(30 * (self.frame.width/667.0), 30 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp))
                                        aSnPowerUp[0].blActive = false
                                    }
                                    allElements: for j in 0 ..< aSnPowerUp.count {
                                        if aSnPowerUp[j].blActive == false {
                                            aSnPowerUp[j] = TLPowerUp(size: CGSizeMake(30 * (self.frame.width/667.0), 30 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp)
                                            aSnPowerUp[j].blActive = true
                                            addChild(aSnPowerUp[j])
                                            aSnPowerUp[j].fctMoveLeft()
                                            break allElements
                                        }
                                        if j == (aSnPowerUp.count - 1) {
                                            aSnPowerUp.append(TLPowerUp(size: CGSizeMake(30 * (self.frame.width/667.0), 30 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp))
                                            aSnPowerUp[j+1].blActive = true
                                            addChild(aSnPowerUp[j+1])
                                            aSnPowerUp[j+1].fctMoveLeft()
                                            break allElements
                                        }
                                    }
                                }
                                aSnmeteorite[i].fctExplode()
                                snBombFired.fctExplode()
                                snBombFired.blExploded = true
                            } else {
                                // ToDo
                                //aSnmeteorite[i].fctHit()
                            }
                        }
                    }
                }
            // Bomb explosion hits ship
            case enBodyType.bombExplosion.rawValue | enBodyType.ship.rawValue:
                if snBombFired.blExploded == true {
                    let secondNode = contact.bodyB.node
                    let firstNode = contact.bodyA.node
                    if (secondNode == snShip || firstNode == snShip){
                        if snShip.iHealth > 100 {
                            fctFadeInOutSKSpriteNode(snShip.snShipShield, time: 0.5, alpha: 0.75, pause: 0.1)
                        }
                        snShip.iHealth = snShip.iHealth - 100
                        if snShip.iHealth <= 0 {
                            self.fctGameOver()
                            self.fctCheckForNewHighscore()
                            self.fctSaveHighscoreData()
                            snShip.physicsBody?.categoryBitMask = 0
                            snShip.fctExplode()
                            blGameOver = true
                            iGameRestartCnt = 0
                        }
                        fctUpdateShields()
                    }
                }
            // Laser sphere hits meteorite
            case enBodyType.laserSphere.rawValue | enBodyType.meteorite.rawValue:
                let secondNode = contact.bodyB.node
                let firstNode = contact.bodyA.node
                for i in 0 ..< aSnmeteorite.count {
                    if (secondNode == aSnmeteorite[i] || firstNode == aSnmeteorite[i]) && (aSnmeteorite[i].blDestroyed == false) {
                        aSnmeteorite[i].iHealth -= 200
                        if aSnmeteorite[i].iHealth <= 0 {
                            if aSnmeteorite[i].iPowerUp > 0 {
                                if aSnPowerUp.count == 0 {
                                    aSnPowerUp.append(TLPowerUp(size: CGSizeMake(30 * (self.frame.width/667.0), 30 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp))
                                    aSnPowerUp[0].blActive = false
                                }
                                allElements: for j in 0 ..< aSnPowerUp.count {
                                    if aSnPowerUp[j].blActive == false {
                                        aSnPowerUp[j] = TLPowerUp(size: CGSizeMake(30 * (self.frame.width/667.0), 30 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp)
                                        aSnPowerUp[j].blActive = true
                                        addChild(aSnPowerUp[j])
                                        aSnPowerUp[j].fctMoveLeft()
                                        break allElements
                                    }
                                    if j == (aSnPowerUp.count - 1) {
                                        aSnPowerUp.append(TLPowerUp(size: CGSizeMake(30 * (self.frame.width/667.0), 30 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp))
                                        aSnPowerUp[j+1].blActive = true
                                        addChild(aSnPowerUp[j+1])
                                        aSnPowerUp[j+1].fctMoveLeft()
                                        break allElements
                                    }
                                }
                            }
                            aSnmeteorite[i].fctExplode()
                        } else {
                            // ToDo
                            //aSnmeteorite[i].fctHit()
                        }
                    }
                }
            // Laser cone hits meteorite
            case enBodyType.laserCone.rawValue | enBodyType.meteorite.rawValue:
                let secondNode = contact.bodyB.node
                let firstNode = contact.bodyA.node
                for i in 0 ..< aSnmeteorite.count {
                    if (secondNode == aSnmeteorite[i] || firstNode == aSnmeteorite[i]) && (aSnmeteorite[i].blDestroyed == false) {
                        aSnmeteorite[i].iHealth -= 80
                        if aSnmeteorite[i].iHealth <= 0 {
                            if aSnmeteorite[i].iPowerUp > 0 {
                                if aSnPowerUp.count == 0 {
                                    aSnPowerUp.append(TLPowerUp(size: CGSizeMake(30 * (self.frame.width/667.0), 30 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp))
                                    aSnPowerUp[0].blActive = false
                                }
                                allElements: for j in 0 ..< aSnPowerUp.count {
                                    if aSnPowerUp[j].blActive == false {
                                        aSnPowerUp[j] = TLPowerUp(size: CGSizeMake(30 * (self.frame.width/667.0), 30 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp)
                                        aSnPowerUp[j].blActive = true
                                        addChild(aSnPowerUp[j])
                                        aSnPowerUp[j].fctMoveLeft()
                                        break allElements
                                    }
                                    if j == (aSnPowerUp.count - 1) {
                                        aSnPowerUp.append(TLPowerUp(size: CGSizeMake(30 * (self.frame.width/667.0), 30 * (self.frame.height/375.0)), pos: aSnmeteorite[i].position, type: aSnmeteorite[i].iPowerUp))
                                        aSnPowerUp[j+1].blActive = true
                                        addChild(aSnPowerUp[j+1])
                                        aSnPowerUp[j+1].fctMoveLeft()
                                        break allElements
                                    }
                                }
                            }
                            aSnmeteorite[i].fctExplode()
                        } else {
                            // ToDo
                            //aSnmeteorite[i].fctHit()
                        }
                    }
                }
                for i in 0 ..< aSnLaserCone.count {
                    if (secondNode == aSnLaserCone[i] || firstNode == aSnLaserCone[i]) && (aSnLaserCone[i].blDestroyed == false)  {
                        aSnLaserCone[i].physicsBody?.categoryBitMask = 0
                        aSnLaserCone[i].physicsBody?.contactTestBitMask = 0
                        aSnLaserCone[i].fctExplode()
                    }
                }
            default:
                ()
            }
        }
    }
    
//    func didEndContact(contact: SKPhysicsContact) {
//        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
//        if blGameOver == false {
//            switch(contactMask) {
//                // Laser hits meteorite
//            // Bomb explosion hits meteorite
//            case enBodyType.bombExplosion.rawValue | enBodyType.meteorite.rawValue:
//                let secondNode = contact.bodyB.node
//                let firstNode = contact.bodyA.node
//                for i in 0 ..< aSnmeteorite.count {
//                    if (secondNode == aSnmeteorite[i] || firstNode == aSnmeteorite[i]) && (aSnmeteorite[i].blDestroyed == false) && (snBombFired.blExploded == false){
//                        aSnmeteorite[i].blInBombRadius = false
//                    }
//                }
//            default:
//                ()
//            }
//        }
//    }
    
    func fctGameOver() {
        blGameStarted = false
        iGameRestartCnt = 0
        lbGameOver = SKLabelNode(fontNamed: fnGameFont?.fontName)
        lbGameOver.text = "GAME OVER"
        lbGameOver.fontSize = 70 * (self.frame.width/667.0)
        lbGameOver.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - (lbGameOver.frame.size.height/2))
        lbGameOver.fontColor = UIColor.whiteColor()
        lbGameOver.zPosition = 2.2
        self.addChild(lbGameOver)
        // Pause screen sprite
        snPause = SKShapeNode(rectOfSize: CGSize(width: self.frame.width, height: self.frame.height))
        snPause.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        snPause.strokeColor = SKColor.blackColor()
        snPause.glowWidth = 0.0
        snPause.lineWidth = 0.0
        snPause.fillColor = SKColor.blackColor()
        snPause.zPosition = 2.1
        snPause.alpha = 0.7
        self.addChild(snPause)
        // Menu "Back" Sprite
        let flMenuBackSpriteWidth = (SKTexture(imageNamed: "Media/menu_back.png").size().width) * (self.frame.width/667.0)
        let flMenuBackSpriteHeight = (SKTexture(imageNamed: "Media/menu_back.png").size().height) * (self.frame.height/375.0)
        snGameOverBack = SKSpriteNode(texture: SKTexture(imageNamed: "Media/menu_back.png"), color: UIColor.clearColor(), size: CGSizeMake(flMenuBackSpriteWidth, flMenuBackSpriteHeight))
        snGameOverBack.anchorPoint = CGPointMake(0.0, 0.5)
        snGameOverBack.position = CGPoint(x: 1*(self.frame.width / 16), y: 10*(self.frame.height / 12))
        snGameOverBack.zPosition = 2.2
        snGameOverBack.alpha = 1.0
        snGameOverBack.name = "GameOverBack"
        self.addChild(snGameOverBack)
        
        for i in 0 ..< aSnmeteorite.count {
            aSnmeteorite[i].physicsBody?.categoryBitMask = 0
            aSnmeteorite[i].blActive = false
            aSnmeteorite[i].removeFromParent()
        }
        aSnmeteorite.removeAll()
        
        for i in 0 ..< aSnLaser01.count {
            aSnLaser01[i].physicsBody?.categoryBitMask = 0
            aSnLaser01[i].blActive = false
            aSnLaser01[i].removeFromParent()
        }
        aSnLaser01.removeAll()
        
        for i in 0 ..< aSnPowerUp.count {
            aSnPowerUp[i].physicsBody?.categoryBitMask = 0
            aSnPowerUp[i].blActive = false
            aSnPowerUp[i].removeFromParent()
        }
        aSnPowerUp.removeAll()

        for i in 0 ..< aSnLaserSphere.count {
            aSnLaserSphere[i].physicsBody?.categoryBitMask = 0
            aSnLaserSphere[i].blActive = false
            aSnLaserSphere[i].removeFromParent()
        }
        aSnLaserSphere.removeAll()
        
        for i in 0 ..< aSnLaserCone.count {
            aSnLaserCone[i].physicsBody?.categoryBitMask = 0
            aSnLaserCone[i].blActive = false
            aSnLaserCone[i].removeFromParent()
        }
        aSnLaserCone.removeAll()
    }
    
    func fctNewGame() {
        iButtonPressed = 0
        blLaserSpherePickedUp = false
        blLaserConePickedUp = false
        blLaserFired = false
        blLaserSphereFired = false
        blLaserConeFired = false
        iSelectedWeapon = 0
        blBombFired = false
        flTouchMoveDist = 1000
        flmeteoriteSpeed = flmeteoriteSpeedInit
        imeteoriteSpawnTime = imeteoriteSpawnTimeInit
        iGameTimeSec = 0
        lbGameTime.text = "0"
        blGameOver = false
        if lbGameOver != nil {
            lbGameOver.removeFromParent()
        }
        snBackground.removeAllActions()
        snBackground.fctResetPos()
        //sleep(2)
        //myLabel.hidden = false
        blGameStarted = false
        iGameScore = 0
        lbGameScore.text = "0"
        snShip.iHealth = 500
        iBombCount = 0
        fctUpdateShields()
    }
    
    func fctUpdateShields() {
        if snShip.iHealth > 100 {
            snShieldBar1.alpha = 1.0
        } else {
            snShieldBar1.alpha = 0.0
        }
        if snShip.iHealth > 200 {
            snShieldBar2.alpha = 1.0
        } else {
            snShieldBar2.alpha = 0.0
        }
        if snShip.iHealth > 300 {
            snShieldBar3.alpha = 1.0
        } else {
            snShieldBar3.alpha = 0.0
        }
        if snShip.iHealth > 400 {
            snShieldBar4.alpha = 1.0
        } else {
            snShieldBar4.alpha = 0.0
        }
        print("Health: " + String(snShip.iHealth)) // #debug
    }
    
    func fctUpdateBombs() {
        if iBombCount > 0 {
            snBomb1.texture = SKTexture(imageNamed: "Media/pu_bomb_001.png")
        } else {
            snBomb1.texture = SKTexture(imageNamed: "Media/pu_bomb_001_empty.png")
        }
        if iBombCount > 1 {
            snBomb2.texture = SKTexture(imageNamed: "Media/pu_bomb_001.png")
        } else {
            snBomb2.texture = SKTexture(imageNamed: "Media/pu_bomb_001_empty.png")
        }
        if iBombCount > 2 {
            snBomb3.texture = SKTexture(imageNamed: "Media/pu_bomb_001.png")
        } else {
            snBomb3.texture = SKTexture(imageNamed: "Media/pu_bomb_001_empty.png")
        }
    }
    
    func fctPlayClickSound() {
        if GameData.blSoundEffectsEnabled == true {
            apClick.volume = GameData.flSoundsVolume
            apClick.prepareToPlay()
            apClick.play()
        }
    }
    
    func fctCheckForNewHighscore () {
        var blNewHighscoreScore = false
        var blNewHighscoreTime = false
        
        lbShareLine1.alpha = 1.0
        snShareTwitter.alpha = 1.0
        snShareFacebook.alpha = 1.0
        // Check for new highscores based on score
        for row in 0...aSkHighscoresRows - 1 {
            if GameData.aHighscoresScore[row].iScore < iGameScore {
                print("New Highscore: " + String(iGameScore) + " Score @ Rank: " + String(row + 1))
                if row < (aSkHighscoresRows - 1) {
                    for backrow in ((row + 1)...(aSkHighscoresRows - 1)).reverse() {
                        GameData.aHighscoresScore[backrow].iScore = GameData.aHighscoresScore[backrow - 1].iScore
                        GameData.aHighscoresScore[backrow].iTime = GameData.aHighscoresScore[backrow - 1].iTime
                        GameData.aHighscoresScore[backrow].strName = GameData.aHighscoresScore[backrow - 1].strName
                    }
                }
                GameData.aHighscoresScore[row].iScore = iGameScore
                GameData.aHighscoresScore[row].iTime = iGameTimeSec
                GameData.aHighscoresScore[row].strName = GameData.strPlayerName
                blNewHighscoreScore = true
                lbHighscoreTextLine1.text = "New Highscore: " + String(iGameScore) + " Score @ Rank: " + String(row + 1)
                break
            }
        }
        // Check for new highscores based on time
        for row in 0...aSkHighscoresRows - 1 {
            if GameData.aHighscoresTime[row].iTime < iGameTimeSec {
                print("New Highscore: " + String(iGameTimeSec) + " Time @ Rank: " + String(row + 1))
                if row < (aSkHighscoresRows - 1) {
                    for backrow in ((row + 1)...(aSkHighscoresRows - 1)).reverse() {
                        GameData.aHighscoresTime[backrow].iScore = GameData.aHighscoresTime[backrow - 1].iScore
                        GameData.aHighscoresTime[backrow].iTime = GameData.aHighscoresTime[backrow - 1].iTime
                        GameData.aHighscoresTime[backrow].strName = GameData.aHighscoresTime[backrow - 1].strName
                    }
                }
                GameData.aHighscoresTime[row].iScore = iGameScore
                GameData.aHighscoresTime[row].iTime = iGameTimeSec
                GameData.aHighscoresTime[row].strName = GameData.strPlayerName
                blNewHighscoreTime = true
                lbHighscoreTextLine2.text = "New Highscore: " + String(iGameTimeSec) + " Time @ Rank: " + String(row + 1)
                break
            }
        }
        if (blNewHighscoreScore == true) && (blNewHighscoreTime == true) {
            fctFadeInOutSKLabelNode(lbHighscoreTextLine1, time: 1, alpha: 1.0, pause: 7)
            fctFadeInOutSKLabelNode(lbHighscoreTextLine2, time: 1, alpha: 1.0, pause: 7)
        }
        if (blNewHighscoreScore == true) && (blNewHighscoreTime == false) {
            fctFadeInOutSKLabelNode(lbHighscoreTextLine1, time: 1, alpha: 1.0, pause: 7)
        }
        if (blNewHighscoreScore == false) && (blNewHighscoreTime == true) {
            lbHighscoreTextLine1.text = lbHighscoreTextLine2.text
            fctFadeInOutSKLabelNode(lbHighscoreTextLine1, time: 1, alpha: 1.0, pause: 7)
        }
    }
    
    func fctSaveHighscoreData() {
        // Build strHighscoreTime string out of highscores
        var strBuffer = ""
        for row in 0...aSkHighscoresRows - 1 {
            strBuffer = strBuffer + String(GameData.aHighscoresTime[row].iScore) + "\t"
            strBuffer = strBuffer + String(GameData.aHighscoresTime[row].iTime) + "\t"
            strBuffer = strBuffer + GameData.aHighscoresTime[row].strName
            if row != aSkHighscoresRows - 1 {
                strBuffer = strBuffer + "\t"
            }
        }
        SDGameData.strHighscoreTime = strBuffer
        // Build strHighscoreScore string out of highscores
        strBuffer = ""
        for row in 0...aSkHighscoresRows - 1 {
            strBuffer = strBuffer + String(GameData.aHighscoresScore[row].iScore) + "\t"
            strBuffer = strBuffer + String(GameData.aHighscoresScore[row].iTime) + "\t"
            strBuffer = strBuffer + GameData.aHighscoresScore[row].strName
            if row != aSkHighscoresRows - 1 {
                strBuffer = strBuffer + "\t"
            }
        }
        SDGameData.strHighscoreScore = strBuffer
        // Save data
        NSKeyedArchiver.archiveRootObject(SDGameData, toFile: TLSaveData.ArchiveURL.path!)
    }
    
    func fctTweetScore() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            // 2
            var tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            // 3
            tweetSheet.setInitialText("Test Tweet")
            self.view?.window?.rootViewController?.presentViewController(tweetSheet, animated: true, completion: nil)
        } else {
            // 5
            print("error")
        }
    }
    
    func applicationWillResignActive(notification: NSNotification) {
        //print("I'm out of focus!")
        if snPause != nil {
            snPause.zPosition = 2.1
        }
        if lbPause != nil {
            lbPause.zPosition = 2.1
        }
        //snInventory.zPosition = 2.2
        self.speed = 0.0
        //self.view!.paused = true
        print("Paused!")
        
    }
    
    deinit {
        
        // code here...
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func fctFadeInOutSKSpriteNode (node: SKSpriteNode, time: NSTimeInterval, alpha: CGFloat, pause: NSTimeInterval) {
        node.alpha = 0.0
        let deltaAlpha = alpha/5
        let deltaTime = time/10
        node.removeAllActions()
        node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
            node.alpha = node.alpha + deltaAlpha
            node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                node.alpha = node.alpha + deltaAlpha
                node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                    node.alpha = node.alpha + deltaAlpha
                    node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                        node.alpha = node.alpha + deltaAlpha
                        node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                            node.alpha = node.alpha + deltaAlpha
                            node.runAction(SKAction.rotateToAngle(0, duration: pause), completion: {() in
                                // Pause
                                node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                    // Fade out
                                    node.alpha = node.alpha - deltaAlpha
                                    node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                        node.alpha = node.alpha - deltaAlpha
                                        node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                            node.alpha = node.alpha - deltaAlpha
                                            node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                                node.alpha = node.alpha - deltaAlpha
                                                node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                                    node.alpha = node.alpha - deltaAlpha
                                                    node.removeAllActions()
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
    
    func fctFadeInOutSKLabelNode (node: SKLabelNode, time: NSTimeInterval, alpha: CGFloat, pause: NSTimeInterval) {
        node.alpha = 0.0
        let deltaAlpha = alpha/5
        let deltaTime = time/10
        node.removeAllActions()
        node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
            node.alpha = node.alpha + deltaAlpha
            node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                node.alpha = node.alpha + deltaAlpha
                node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                    node.alpha = node.alpha + deltaAlpha
                    node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                        node.alpha = node.alpha + deltaAlpha
                        node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                            node.alpha = node.alpha + deltaAlpha
                            node.runAction(SKAction.rotateToAngle(0, duration: pause), completion: {() in
                                // Pause
                                node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                    // Fade out
                                    node.alpha = node.alpha - deltaAlpha
                                    node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                        node.alpha = node.alpha - deltaAlpha
                                        node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                            node.alpha = node.alpha - deltaAlpha
                                            node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                                node.alpha = node.alpha - deltaAlpha
                                                node.runAction(SKAction.rotateToAngle(0, duration: deltaTime), completion: {() in
                                                    node.alpha = node.alpha - deltaAlpha
                                                    node.removeAllActions()
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
