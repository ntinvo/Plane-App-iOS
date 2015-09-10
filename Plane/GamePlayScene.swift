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
        case OBJECTS = 1
    }
    
    var background = SKSpriteNode()
    var plane = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var score: Int = 0
    
    override func didMoveToView(view: SKView) {
    }
    
}
