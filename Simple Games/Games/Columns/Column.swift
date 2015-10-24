//
//  Column.swift
//  Simple Games
//
//  Created by Ricardo Sánchez Sotres on 23/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

struct Column {
    var top:Stone
    var middle:Stone
    var bottom:Stone
    
    var position:ColumnPosition
    
    init ()
    {
        bottom = Stone()
        bottom.type = StoneType.random()
        
        middle = Stone()
        middle.type = StoneType.random()
        
        top = Stone()
        top.type = StoneType.random()
        
        position = ColumnPosition(column: 3, row: 12)
    }
    
    mutating func shuffle()
    {
        let oldBottom = bottom
        bottom = middle
        middle = top
        top = oldBottom
    }
}
