//
//  BallNode.swift
//  Simple Games
//
//  Created by Ricardo Sánchez Sotres on 22/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import SpriteKit

class BallNode:SKShapeNode {
    
    let BALL_RADIUS:CGFloat = 10.0
    
    var direction:CGVector = CGVector(dx: 1.0, dy: 1.0)

    override init() {
        super.init()
        
        speed = 10.0
        
        self.path = CGPathCreateWithEllipseInRect(CGRect(x: -BALL_RADIUS, y: -BALL_RADIUS, width: BALL_RADIUS*2, height: BALL_RADIUS*2), nil)

        physicsBody = SKPhysicsBody(circleOfRadius:BALL_RADIUS)
        fillColor = SKColor.whiteColor()
        strokeColor = SKColor.blackColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func update()
    {
        position = CGPoint(x: position.x + speed * direction.dx, y: position.y + speed * direction.dy)
    }
}
