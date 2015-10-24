//
//  ColumnsEngine.swift
//  Simple Games
//
//  Created by Ricardo Sánchez Sotres on 23/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

protocol ColumnsEngineProtocol
{
    var activeColumn:Column? { get }
    
    func start(scene:ColumnsSceneProtocol)
    func update(currentTime: NSTimeInterval)
    func moveActiveColumn(newPositionX:Int)
    func swipeDown()
    func flipColumn()
}


enum GridError:ErrorType
{
    case OutOfBounds
}

let GRID_WIDTH = 6
let GRID_HEIGHT = 13

class ColumnsEngine:ColumnsEngineProtocol
{
    var scene:ColumnsSceneProtocol?
    
    var activeColumn:Column?
    
    var timePerMove = 0.5;
    var timeOfLastMove = 0.0;
    
    var grid = [Stone?](count: 13*6, repeatedValue: nil)
    
    func start(scene:ColumnsSceneProtocol)
    {
        self.scene = scene
        spawnColumn()
    }
    
    func spawnColumn()
    {
        activeColumn = Column()
        self.scene!.newActiveColumn()
    }
    
    func update(currentTime: NSTimeInterval)
    {
        guard let activeColumn = activeColumn else {
            return
        }
        
        if (currentTime - timeOfLastMove < timePerMove) {
            return
        }
        
        timeOfLastMove = currentTime
        
        do {
            if let _ = try cellAtPosition(activeColumn.position.offsetRow(-0.5)) {
                fixColumn()
            } else {
                self.activeColumn!.position = activeColumn.position.offsetRow(-0.5)
            }
        } catch {
            //out of bounds
            fixColumn()
        }
    }
    
    func moveActiveColumn(newPositionX: Int)
    {
        guard let activePosition = activeColumn?.position else { return }
        
        let newActivePosition = ColumnPosition(column: newPositionX, row: activePosition.row)
        var shouldMove = true
        let _min = min(activePosition.column, newActivePosition.column)
        let _max = max(activePosition.column, newActivePosition.column)
        for i in Int(_min)...Int(_max) {
            do {
                if let _ = try cellAtPosition(ColumnPosition(column: i, row: newActivePosition.row)) {
                    shouldMove = false
                }
            } catch {
                //out of bounds
            }
        }
        if(shouldMove) {
            self.activeColumn?.position = newActivePosition
        }
        
    }
    
    func fixColumn()
    {
        guard let activeColumn = activeColumn else { return }
        
        self.scene!.fixColumn()
        
        putStone(activeColumn.bottom, atPosition: activeColumn.position)
        putStone(activeColumn.middle, atPosition: activeColumn.position.offsetRow(1))
        putStone(activeColumn.top, atPosition: activeColumn.position.offsetRow(2))
        
        self.activeColumn = nil
        
        checkMatches() {
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.spawnColumn()
            }
        }
    }
    
    
    func searchMatch(type:StoneType, c:Int, r:Int, offsetC:Int, offsetR:Int) -> [Stone]
    {
        do {
            if let stone = try cellAtPosition(ColumnPosition(column: c, row: 12-r)) where stone.type == type {
                var array = searchMatch(type, c: c+offsetC, r: r+offsetR, offsetC:offsetC, offsetR:offsetR)
                array.append(stone)
                return array
            } else {
                return []
            }
        } catch {
            //out of bounds
            return []
        }
    }
    
    func checkMatches(completion:()->())
    {
        var matches = [Stone]()
        for c in 0..<6 {
            for r in 0..<13 {
                do {
                    if let stone = try cellAtPosition(ColumnPosition(column: c, row: 12-r)) {
                        let matchUp = searchMatch(stone.type, c: c, r: r, offsetC:0, offsetR: 1)
                        if matchUp.count >= 3 {
                            matches += matchUp
                        }
                        let matchRight = searchMatch(stone.type, c: c, r: r, offsetC:1, offsetR: 0)
                        if matchRight.count >= 3 {
                            matches += matchRight
                        }
                        
                        let matchDiagD = searchMatch(stone.type, c: c, r: r, offsetC:1, offsetR: 1)
                        if matchDiagD.count >= 3 {
                            matches += matchDiagD
                        }
                        
                        
                        let matchDiagI = searchMatch(stone.type, c: c, r: r, offsetC:-1, offsetR: 1)
                        if matchDiagI.count >= 3 {
                            matches += matchDiagI
                        }
                    }
                } catch {
                    //out of bounds
                }
            }
        }
        
        if matches.count > 0 {
            
            
            for stone in matches {
                if let position = stone.position {
                    removeCellAtPosition(position)
                }
            }
            
            self.removeGaps()
            scene?.removeSprites(matches.map { $0.position! } )
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.checkMatches(completion)
            }
        } else {
            completion()
        }
    }
    
    func swipeDown() {
        if let currentPosition = activeColumn?.position {
            
            for r in 0..<Int(currentPosition.row) {
                //TODO This is ugly
                do {
                    if let _ = try cellAtPosition(ColumnPosition(column:currentPosition.column, row:r)) {
                        
                    } else {
                        let destination = ColumnPosition(column:currentPosition.column, row:r)
                        activeColumn?.position = destination
                        fixColumn()
                    }
                } catch {
                    let destination = ColumnPosition(column:currentPosition.column, row:r)
                    activeColumn?.position = destination
                    fixColumn()
                    break
                }
            }
            
        }
    }
    
    func flipColumn() {
        if let _ = activeColumn
        {
            self.activeColumn!.shuffle()
            scene?.shuffleColumn()
        }
    }
    
    func cellAtPosition(position:ColumnPosition) throws -> Stone?
    {
        if (position.column<0 || position.column >= 6 || position.row<0 || position.row >= 13) {
            throw GridError.OutOfBounds
        }
        
        return grid[position.column+Int(position.row)*6]
    }
    
    func putStone(stone:Stone, atPosition position:ColumnPosition)
    {
        if (position.column<0 || position.column >= 6 || position.row<0 || position.row >= 13) {
            return
        }
        
        grid[position.column+Int(position.row)*6] = stone.move(position)
    }
    
    func removeCellAtPosition(position:ColumnPosition)
    {
        if (position.column<0 || position.column >= 6 || position.row<0 || position.row >= 13) {
            return
        }
        
        grid[position.column+Int(position.row)*6] = nil
    }
    
    func removeGaps()
    {
        
        printGrid()
        for c in 0..<6 {
            var count = 0
            for r in 0..<13 {
                let position = ColumnPosition(column:c, row:r)
                if let stone = try! cellAtPosition(position) {
                    if count > 0 {
                        putStone(stone, atPosition: position.offsetRow(Double(-count)))
                        removeCellAtPosition(position)
                    }
                } else {
                    count += 1
                }
            }
        }
        printGrid()
    }
    
    func printGrid()
    {
        print("GRID:")
        for r in 0..<13 {
            var rowString = ""
            for c in 0..<6 {
                if let cell = try! cellAtPosition(ColumnPosition(column:c, row:12-r)) {
                    rowString += " \(cell)"
                } else {
                    rowString += " -"
                }
            }
            
            print(rowString)
        }
    }
}