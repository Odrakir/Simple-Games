//
//  GridNode.swift
//  Simple Games
//
//  Created by Ricardo Sánchez Sotres on 21/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import SpriteKit

class GridNode: SKShapeNode {
    
    var backgroundNode:SKSpriteNode?
    
    init(size: CGSize) {
        super.init()
        
        self.strokeColor = SKColor.blackColor()
        self.lineWidth = 2.0
        self.path = CGPathCreateWithRect(CGRect(x: 0, y: 0, width: size.width, height: size.height), nil)
        
        let backgroundTexture = SKTexture(image: patternBackgroundWithSize(size))
        
        backgroundNode = SKSpriteNode(texture: backgroundTexture)
        backgroundNode!.size = size
        backgroundNode!.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        addChild(backgroundNode!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func patternBackgroundWithSize(size:CGSize) -> UIImage
{
    let bkg = UIImage(named: "background_pattern.png")
    let backgroundCGImage = bkg!.CGImage //change the string to your image name
    let coverageSize = size
    let textureSize = CGRectMake(0, 0, bkg!.size.width, bkg!.size.height); //the size of the tile.
    
    UIGraphicsBeginImageContextWithOptions(coverageSize, false, UIScreen.mainScreen().scale);
    
    let context = UIGraphicsGetCurrentContext()
    
    CGContextDrawTiledImage(context, textureSize, backgroundCGImage)
    let tiledBackground = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return tiledBackground
}