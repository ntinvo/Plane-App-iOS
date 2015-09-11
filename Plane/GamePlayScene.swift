//
//  GamePlayScene.swift
//  Plane
//
//  Created by Tin N Vo on 9/8/15.
//  Copyright © 2015 Tin Vo. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GamePlayScene: SKScene {
    
    enum objectZPos: CGFloat {
        case BACKGROUND = 0
        case PLANE = 1
        case SCORELABEL = 2
        case BULLET = 3
    }
    
    /* Variable */
    var lastTime = NSTimeInterval()
    var lastFire = NSTimeInterval()
    var touch = UITouch()
    var background = SKSpriteNode()
    var plane = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var fireRate = CGFloat()
    var gameON = Bool()
    var touching = Bool()
    var score: Int = 0
    
    
    /* Constant variables */
    let SPEED: CGFloat = 160
    
    override func didMoveToView(view: SKView) {
        initObjects() /* Init objs */
        animateBackground() /* Move bg t the left */
        
        
        gameON = true
        fireRate = 0.7
    }
    
    /* Move the plane */
    func changePlanePos(timeMove: NSTimeInterval, des: CGPoint) {
        
        /* Apply the formular to find distance between to points */
        let distance: CGFloat = sqrt(pow(plane.position.x - des.x, 2) +
                                     pow(plane.position.y - des.y, 2))
        
        if distance > 4 {
            /* Distance and moving angle */
            let totalDistance: CGFloat = CGFloat(timeMove) * SPEED
            let moveAngle: CGFloat = atan2(des.y - plane.position.y,
                                          des.x - plane.position.x);
            /* Offsets */
            let xOff: CGFloat = totalDistance * cos(moveAngle)
            let yOff: CGFloat = totalDistance * sin(moveAngle)
    
            /* Set position for the plane */
            plane.position = CGPointMake(plane.position.x + xOff, plane.position.y + yOff)
        }
    }
    
    /* Initialize the variables and set zPositions for them */
    func initObjects() {
        plane = childNodeWithName("plane") as! SKSpriteNode
        scoreLabel = childNodeWithName("score") as! SKLabelNode
        
        plane.zPosition = objectZPos.PLANE.rawValue;
        scoreLabel.zPosition = objectZPos.SCORELABEL.rawValue;
    }
    
    
    /* This function will move the background to the left */
    func animateBackground() {
        let bg = SKTexture(imageNamed: "background")
        let moveBackground = SKAction.sequence([SKAction.moveByX(-bg.size().width, y: 0, duration: 12),
            SKAction.moveByX(bg.size().width, y: 0, duration: 0)])
        for var i: CGFloat = 0; i < 3; i++ {
            background = SKSpriteNode(texture: bg)
            background.zPosition = objectZPos.BACKGROUND.rawValue
            background.size.height = self.frame.height
            background.position = CGPoint(x: bg.size().width/2 + i * bg.size().width, y: CGRectGetMidY(self.frame))
            background.runAction(SKAction.repeatActionForever(moveBackground))
            self.addChild(background)
        }
    }

    /* Plane shooting */
    func planeShoot() {
        if gameON {
            let bullet = SKSpriteNode(imageNamed: "trail_00")
            bullet.name = "bullet"
            bullet.size = CGSizeMake(30, 30)
            bullet.xScale = 1.5
            bullet.position = CGPointMake(plane.position.x + 50, plane.position.y - 5)
            bullet.zPosition = objectZPos.BULLET.rawValue
            self.addChild(bullet)
            
            let fire = SKAction.sequence([SKAction.moveToX(self.size.width + bullet.size.width, duration: 2),
                                          SKAction.removeFromParent()])
            bullet.runAction(fire)
        }
    }
    
    /* Touches began */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touch = touches.first!
        touching = (gameON) ? true : false
    }
    
    /* Touches ended */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touching = false
    }
    
    /* Updating */
    override func update(currentTime: NSTimeInterval) {
        lastTime = (lastTime == 0) ? currentTime : lastTime
        let timePeriod: NSTimeInterval = currentTime - lastTime
        if touching {
            var touchPos: CGPoint = touch.locationInNode(self)
            touchPos.x += 20
            changePlanePos(timePeriod, des: touchPos)
            if CGFloat(currentTime - lastFire) > fireRate {
                planeShoot()
                lastFire = currentTime
            }
        }
        lastTime = currentTime
    }

    
    
    
}
