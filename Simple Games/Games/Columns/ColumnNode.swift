//
//  ColumnNode.swift
//  Simple Games
//
//  Created by Ricardo Sánchez Sotres on 23/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import SpriteKit

class ColumnNode: SKNode {
    
    
    var bottom:StoneNode
    var middle:StoneNode
    var top:StoneNode
    
    init(column:Column) {
        
        self.bottom = StoneNode(type: column.bottom.type)
        self.middle = StoneNode(type: column.middle.type)
        self.top = StoneNode(type: column.top.type)
        
        super.init()
        
        bottom.position = CGPoint(x: 0, y: 0)
        middle.position = CGPoint(x: 0, y: 80)
        top.position = CGPoint(x: 0, y: 80*2)
        
        addChild(bottom)
        addChild(middle)
        addChild(top)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shuffle()
    {
        let oldBottom = bottom
        let oldMiddle = middle
        let oldTop = top
        
        self.bottom = oldMiddle
        self.middle = oldTop
        self.top = oldBottom
        
        oldBottom.zPosition = 2
        oldMiddle.zPosition = 1
        oldTop.zPosition = 1
        
        let scaleUpAction = SKAction.scaleBy(1.5, duration: 0.15)
        let moveAction = SKAction.runBlock { () -> Void in
            let downAction = SKAction.moveByX(0, y: -80, duration: 0.15)
            let upAction = SKAction.moveByX(0, y: 80*2, duration: 0.15)
            oldBottom.runAction(upAction)
            oldMiddle.runAction(downAction)
            oldTop.runAction(downAction)
        }
        let scaleDownAction = SKAction.scaleTo(1, duration: 0.15)
        let sequence = SKAction.sequence([scaleUpAction, moveAction, scaleDownAction])
        oldBottom.runAction(sequence)
        
    }
    
}
