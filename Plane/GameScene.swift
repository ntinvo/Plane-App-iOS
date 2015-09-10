//
//  GameScene.swift
//  Plane
//
//  Created by Tin N Vo on 9/8/15.
//  Copyright (c) 2015 Tin Vo. All rights reserved.
//

/* TODO: HAVE TO RESET THE numTapToBegin when gameover */
import SpriteKit

class GameScene: SKScene {
    
    enum objectZPos: CGFloat {
        case BACKGROUND = 0
        case OBJECTS = 1
    }
    
    /* Instance variables */
    var backgroundMain = SKSpriteNode()
    var title = SKLabelNode()
    var planeMain = SKSpriteNode()
    var tapLeft = SKSpriteNode()
    var tapRight = SKSpriteNode()
    var tap = SKSpriteNode()
    var getReady = SKSpriteNode()
    var highScoreLabel = SKLabelNode()
    var numTapToBegin = 1;
    
    
    override func didMoveToView(view: SKView) {
        initObjectsZPos() /* Init zposition for objects */
        getHighScore() /* Call helper func to get the highscore */
        tapAnimate() /* Call to animate the tap and taptick */
    }
    
    
    /* Initialize the variables and set zPositions for them */
    func initObjectsZPos() {
        title = childNodeWithName("title") as! SKLabelNode
        highScoreLabel = childNodeWithName("highScore") as! SKLabelNode
        planeMain = childNodeWithName("planeMain") as! SKSpriteNode
        tapLeft = childNodeWithName("tapLeft") as! SKSpriteNode
        tapRight = childNodeWithName("tapRight") as! SKSpriteNode
        tap = childNodeWithName("tap") as! SKSpriteNode
        getReady = childNodeWithName("getReady") as! SKSpriteNode
        backgroundMain = childNodeWithName("backgroundMain") as! SKSpriteNode
        
        backgroundMain.zPosition = objectZPos.BACKGROUND.rawValue
        title.zPosition = objectZPos.OBJECTS.rawValue
        highScoreLabel.zPosition = objectZPos.OBJECTS.rawValue
        planeMain.zPosition = objectZPos.OBJECTS.rawValue
        tapLeft.zPosition = objectZPos.OBJECTS.rawValue
        tapRight.zPosition = objectZPos.OBJECTS.rawValue
        tap.zPosition = objectZPos.OBJECTS.rawValue
        getReady.zPosition = objectZPos.OBJECTS.rawValue
        
    }
    
    /* Animate tap and taptick */
    func tapAnimate() {
        let actionOne = SKAction.waitForDuration(0.2)
        let actionTap = SKAction.performSelector("tapTap", onTarget: self)
        let actionTapTick = SKAction.performSelector("tapTick", onTarget: self)
        let actionSequence = SKAction.sequence([actionOne, actionTap, actionOne, actionTapTick])
        let actionForerver = SKAction.repeatActionForever(actionSequence)
        self.runAction(actionForerver);
    }
    
    /* Change the tap texture */
    func tapTick() {
        tap.texture = SKTexture(imageNamed: "tapTick")
    }
    
    /* Change the taptick texture */
    func tapTap() {
        tap.texture = SKTexture(imageNamed: "tap")
    }

    /* Get highscore from NSUserDefaults if it exists */
    func getHighScore() {
        var highScore: String = ""
        if NSUserDefaults.standardUserDefaults().objectForKey("highScore") == nil {
            highScore = "0"
        } else {
            highScore = NSUserDefaults.standardUserDefaults().valueForKey("highScore") as! String
        }
        highScoreLabel.text = "Highscore : " + highScore
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(numTapToBegin <= 1) {
            let planeTransition = SKAction.moveToX(self.frame.width + planeMain.frame.width/2, duration: 2.0)
            let planeRotation = SKAction.rotateByAngle(-0.1, duration: 0.3)
            let groupPlaneAction = SKAction.group([planeRotation, planeTransition])
            numTapToBegin++
            planeMain.runAction(groupPlaneAction, completion: { () -> Void in
                let newScene = GamePlayScene(fileNamed: "GamePlayScene")
                let transition = SKTransition.doorsCloseHorizontalWithDuration(1.0)
                self.view?.presentScene(newScene!, transition: transition)
            })
        }
        
        /*plane.runAction(groupPlaneAction) { () -> Void in
            let newScene = GamePlay(fileNamed: "GamePlay")
            let transition = SKTransition.doorsCloseHorizontalWithDuration(1.0);
            self.view?.presentScene(newScene!, transition: transition)
        }*/
    }
   
    override func update(currentTime: CFTimeInterval) {
        
    }
}
