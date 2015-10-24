//
//  ColumnPosition.swift
//  Simple Games
//
//  Created by Ricardo Sánchez Sotres on 23/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation


struct ColumnPosition:Equatable {
    var column:Int = 0
    var row:Double = 0
    
    init(column:Int, row:Double) {
        self.column = column
        self.row = row
    }
    
    init(column:Int, row:Int) {
        self.column = column
        self.row = Double(row)
    }
    
    func offsetColumn(offset:Int) -> ColumnPosition
    {
        return ColumnPosition(column: self.column + offset, row: self.row)
    }
    
    func offsetRow(offset:Double) -> ColumnPosition
    {
        return ColumnPosition(column: self.column, row: self.row + offset)
    }
}

func ==(lhs: ColumnPosition, rhs: ColumnPosition) -> Bool
{
    return lhs.column == rhs.column && lhs.row == rhs.row
}