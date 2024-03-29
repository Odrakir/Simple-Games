//
//  LevelManager.swift
//  Simple Games
//
//  Created by Ricardo Sánchez Sotres on 22/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation
import SpriteKit

let levels = [
    [
        "-",
        "-",
        "-",
        "-",
        "bbbbbbbbbbbbbbb",
        ".pppppppppppppppp",
        "rrrrrrrrrrrrrrr",
        ".oooooooooooooooo",
        "yyyyyyyyyyyyyyy",
        ".gggggggggggggggg",
        
    ],
    [
        "-",
        "-",
        "-",
        "0000000b0000000",
        "000000bbb000000",
        "00000bbbbb00000",
        "0000bbbrbbb0000",
        "000bbbrrrbbb000",
        "00bbbrrgrrbbb00",
        "000bbbrrrbbb000",
        "0000bbbrbbb0000",
        "00000bbbbb00000",
        "000000bbb000000",
        "0000000b0000000"
    ],
    [
        "-",
        "-",
        "00rr0rr0rr0rr00",
        "00rr0rr0rr0rr00",
        "00rr0rr0rr0rr00",
        "00rr0rr0rr0rr00",
        "00rr0rr0rr0rr00",
        "00rr0rr0rr0rr00",
        "00rr0rr0rr0rr00",
        "00rr0rr0rr0rr00",
        "00rr0rr0rr0rr00",
        "00rr0rr0rr0rr00",
        "00rr0rr0rr0rr00",
        "00rr0rr0rr0rr00",
        "00rr0rr0rr0rr00",
        "00rr0rr0rr0rr00",
        "00rr0rr0rr0rr00",
        "00rr0rr0rr0rr00"
    ]
]

class LevelManager
{
    static var GRID_HEIGHT:CGFloat = 0
    
    var currentLevel:Int?
    
    func loadNextLevel(blocksNode:SKNode, category:UInt32, delegate:BlockNodeDelegate)
    {
        if let _ =  currentLevel {
            currentLevel! += 1
            if currentLevel >= levels.count {
                currentLevel = 0
            }
        } else {
            currentLevel = 0
        }
        
        let blocks = levels[currentLevel!]
        
        blocksNode.removeAllChildren()
        
        var l = 0
        for line in blocks {
            if line == "-" {
                l++
                continue
            }
            var c = 0
            var offset:CGFloat = 0
            for b in line.characters {
                if String(b) == "." {
                    offset  = -0.5
                    continue
                }
                if String(b) != "0" {
                    let block = BlockNode(type:String(b))
                    block.position = CGPoint(x: CGFloat(c*80) + 40 + offset*80, y: LevelManager.GRID_HEIGHT - CGFloat(l*40) - 20)
                    block.zPosition = 1
                    block.physicsBody!.categoryBitMask = category
                    block.physicsBody!.collisionBitMask = 0
                    block.delegate = delegate
                    blocksNode.addChild(block)
                }
                c++
            }
            l++
        }
        
    }
}