//
//  BlockNode.swift
//  Simple Games
//
//  Created by Ricardo Sánchez Sotres on 21/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import SpriteKit

protocol BlockNodeDelegate:class
{
    func blockExploded(block:BlockNode)
}

class BlockNode:SKShapeNode {

    let type:String
    var strength:Int
    
    weak var delegate:BlockNodeDelegate?
    
    init(type:String) {
        
        if type != type.lowercaseString {
            strength = 2
        } else {
            strength = 1
        }
        
        self.type = type.lowercaseString
        
        if self.type == "x" {
            strength = Int.max
        }
        

        super.init()
        
        self.path = CGPathCreateWithRect(CGRect(x:-40, y:-20, width: 80, height: 40), nil)
        self.strokeColor = SKColor.blackColor()
        self.lineWidth = 1.0
        switch self.type {
        case "b":
            self.fillColor = SKColor(red: 0/255.0, green: 135/255.0, blue: 172/255.0, alpha: 1.0)
        case "r":
            self.fillColor = SKColor(red: 239/255.0, green: 0, blue: 0, alpha: 1.0)
        case "o":
            self.fillColor = SKColor(red: 222/255.0, green: 144/255.0, blue: 25/255.0, alpha: 1.0)
        case "g":
            self.fillColor = SKColor(red: 132/255.0, green: 194/255.0, blue: 83/255.0, alpha: 1.0)
        case "y":
            self.fillColor = SKColor(red: 237/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1.0)
        case "p":
            self.fillColor = SKColor(red: 165/255.0, green: 61/255.0, blue: 167/255.0, alpha: 1.0)
        case "p":
            self.fillColor = SKColor(red: 165/255.0, green: 61/255.0, blue: 167/255.0, alpha: 1.0)
        case "x":
            self.fillColor = SKColor(red: 190/255.0, green: 190/255.0, blue: 190/255.0, alpha: 1.0)
        default:
            self.fillColor = UIColor.whiteColor()
        }
        
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 80, height: 40))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hit()
    {
        strength -= 1
        if strength == 0 {
            /*
            let particleColor = (secondBody.node as! SKSpriteNode).color
            let emitter = SKEmitterNode(fileNamed: "blockBreak.sks")
            emitter?.position = secondBody.node!.position
            emitter?.particleColorBlendFactor = 1.0
            emitter?.particleColorSequence = SKKeyframeSequence(keyframeValues: [particleColor, particleColor], times: [1.9, 2.0])
            addChild(emitter!)
            
            let seconds = CGFloat(emitter!.numParticlesToEmit) / emitter!.particleBirthRate + emitter!.particleLifetime + emitter!.particleLifetimeRange / 2.0
            let sequence = SKAction.sequence([SKAction.waitForDuration(Double(seconds)), SKAction.removeFromParent()])
            emitter?.runAction(sequence)
            */
            
            if let delegate = delegate {
                delegate.blockExploded(self)
            }
        }
    }
    
}
