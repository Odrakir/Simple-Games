//
//  StoneNode.swift
//  Simple Games
//
//  Created by Ricardo Sánchez Sotres on 23/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import SpriteKit

class StoneNode: SKNode {
    
    var type:StoneType
    
    init(type:StoneType) {
        self.type = type
        
        super.init()
        
        let sprite:SKSpriteNode
        switch type {
        case .Blue:
            sprite = SKSpriteNode(imageNamed: "b_piece")
        case .Green:
            sprite = SKSpriteNode(imageNamed: "g_piece")
        case .Purple:
            sprite = SKSpriteNode(imageNamed: "p_piece")
        case .Red:
            sprite = SKSpriteNode(imageNamed: "r_piece")
        case .Yellow:
            sprite = SKSpriteNode(imageNamed: "y_piece")
        case .Orange:
            sprite = SKSpriteNode(imageNamed: "o_piece")
            
        }
        addChild(sprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var description:String {
        switch type {
        case .Yellow:
            return "Y"
        case .Green:
            return "G"
        case .Blue:
            return "B"
        case .Purple:
            return "P"
        case .Red:
            return "R"
        case .Orange:
            return "O"
        }
    }
}
