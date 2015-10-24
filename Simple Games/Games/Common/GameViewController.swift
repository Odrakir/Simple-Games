//
//  GameViewController.swift
//  TheWall
//
//  Created by Ricardo Sánchez Sotres on 8/10/15.
//  Copyright (c) 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import SpriteKit

enum Game {
    case TheWall
    case Columns
}

class GameViewController: UIViewController {
    
    let game:Game
    var scene:GameScene?
    
    init(game:Game)
    {
        self.game = game
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Configure the view.
        let skView = SKView(frame: self.view.bounds)
        self.view.addSubview(skView)
        
        skView.showsFPS = true
        skView.showsNodeCount = true
//        skView.showsPhysics = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        switch game {
        case .TheWall:
            scene = TheWallScene(size:skView.bounds.size)
        case .Columns:
            scene = ColumnsScene(size:skView.bounds.size)            
        }

        if let scene = scene {
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }

    }

}
