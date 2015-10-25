//
//  PaddleNode.swift
//  Simple Games
//
//  Created by Ricardo Sánchez Sotres on 22/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import SpriteKit

class PaddleNode: SKShapeNode {

    
    override init() {
        
        super.init()
        
        self.path = CGPathCreateWithRoundedRect(CGRect(x: -80, y: -20, width: 160, height: 40), 20, 20, nil)
        self.strokeColor = SKColor.whiteColor()
        self.fillColor = SKColor.blackColor()
        self.lineWidth = 1.0

        
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 160, height: 40))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
