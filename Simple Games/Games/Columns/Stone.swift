//
//  Stone.swift
//  Simple Games
//
//  Created by Ricardo Sánchez Sotres on 23/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

enum StoneType:UInt32 {
    case Yellow
    case Green
    case Blue
    case Purple
    case Red
    case Orange
    
    private static let _count: StoneType.RawValue = {
        var maxValue: UInt32 = 0
        while let _ = StoneType(rawValue: ++maxValue) { }
        return maxValue
    }()
    
    static func random() -> StoneType {
        let rand = arc4random_uniform(_count)
        return StoneType(rawValue: rand)!
    }
}

struct Stone:CustomStringConvertible {
    var position:ColumnPosition?
    var type:StoneType = .Red
    
    func move(position:ColumnPosition) -> Stone
    {
        return Stone(position: position, type: self.type)
    }
    
    var description:String {
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
