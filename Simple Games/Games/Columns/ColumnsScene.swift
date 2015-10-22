//
//  ColumnsScene.swift
//  Simple Games
//
//  Created by Ricardo Sánchez Sotres on 21/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import SpriteKit

class ColumnsScene: GameScene {

    override func didMoveToView(view: SKView) {
        
        let grid = GridNode(size:CGSize(width: 80*6, height: 80*13))
        addChild(grid)
    }
    
}
