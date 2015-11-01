//
//  ColumnsScene.swift
//  Simple Games
//
//  Created by Ricardo Sánchez Sotres on 21/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import SpriteKit

protocol ColumnsSceneProtocol
{
    func newActiveColumn()
    func fixColumn()
    func shuffleColumn()
    func removeSprites(positionsToRemove:[ColumnPosition])
}

class ColumnsScene: GameScene {
    
    let CELL_SIDE:CGFloat = 80
    let GRID_COLUMNS:CGFloat = 6
    let GRID_ROWS:CGFloat = 13
    var GRID_WIDTH:CGFloat {
        get {
            return 80*GRID_COLUMNS
        }
    }
    var GRID_HEIGHT:CGFloat {
        get {
            return 80*GRID_ROWS
        }
    }
    
    var engine:ColumnsEngineProtocol = ColumnsEngine()
    
    var activeColumnSprite:ColumnNode?
    var nextColumnSprite:ColumnNode?
    var sprites = [[SKNode]](count: 6, repeatedValue: [])
    
    let gameNode = SKNode()
    let spritesNode = SKCropNode()
    var nextColumnNode = SKNode()
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.backgroundColor = SKColor(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1.0)
        
        gameNode.position = CGPoint(x: 720, y: 20)
        addChild(gameNode)
        
        gameNode.addChild(spritesNode)
        
        let maskNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: GRID_WIDTH, height: GRID_HEIGHT))
        maskNode.fillColor = UIColor.redColor()
        spritesNode.maskNode = maskNode
        spritesNode.zPosition = 2
        
        let grid = GridNode(size:CGSize(width: GRID_WIDTH, height: GRID_HEIGHT))
        grid.zPosition = -1
        gameNode.addChild(grid)
        
        let nextColumnGrid = GridNode(size: CGSize(width: CELL_SIDE, height: CELL_SIDE*3))
        nextColumnGrid.position = CGPoint(x: -100, y: GRID_HEIGHT - CELL_SIDE*3)
        gameNode.addChild(nextColumnGrid)
        
        nextColumnNode.position = CGPoint(x: 40, y: 40)
        nextColumnNode.zPosition = 2
        nextColumnGrid.addChild(nextColumnNode)
        
        
        let pan = UIPanGestureRecognizer(target: self, action: Selector("pan:"))
        pan.delegate = self
        self.view?.addGestureRecognizer(pan)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: Selector("swipe:"))
        swipe.delegate = self
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view?.addGestureRecognizer(swipe)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("tap:"))
        tap.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]
        self.view!.superview?.addGestureRecognizer(tap)
        
        engine.start(self)
        
        nextColumnSprite = ColumnNode(column: engine.nextColumn)
        nextColumnNode.addChild(nextColumnSprite!)
    }
    
    override func update(currentTime: NSTimeInterval) {
        engine.update(currentTime)
        
        if let activeColumn = engine.activeColumn, let activeColumnSprite = activeColumnSprite {
            activeColumnSprite.position = CGPoint(x: CGFloat(activeColumn.position.column) * CELL_SIDE + CELL_SIDE/2.0, y: CGFloat(activeColumn.position.row) * CELL_SIDE + CELL_SIDE/2.0)
        }
    }
    
    
    var initiaLocation:CGFloat = 0
    
    func pan(recognizer:UIPanGestureRecognizer) {
        guard let activeColumnSprite = activeColumnSprite else { return }
        
        let translation = recognizer.locationInView(self.view).x / 4.0
        
        switch recognizer.state {
        case UIGestureRecognizerState.Began:
            initiaLocation = translation - activeColumnSprite.position.x
            break
        case UIGestureRecognizerState.Changed:
            var rectPos:CGFloat = 0
            rectPos = translation - initiaLocation
            rectPos = rectPos < CELL_SIDE/2.0 ? CELL_SIDE/2.0 : (rectPos > GRID_WIDTH - CELL_SIDE/2.0 ? GRID_WIDTH - CELL_SIDE/2.0 : rectPos)
            let offsetX = Int(floor(rectPos/CELL_SIDE))
            
            engine.moveActiveColumn(offsetX)
        default:
            break
        }
    }
    
    
    func swipe(recognizer:UISwipeGestureRecognizer)
    {
        engine.swipeDown()
        
    }
    
    func tap(recognizer:UITapGestureRecognizer) {
        engine.tap()
    }
}

extension ColumnsScene:ColumnsSceneProtocol
{
    func newActiveColumn() {
        guard let activeColumn = engine.activeColumn else {
            return
        }
        
        activeColumnSprite = ColumnNode(column: activeColumn)
        activeColumnSprite!.position = CGPoint(x: CGFloat(activeColumn.position.column) * CELL_SIDE + CELL_SIDE/2.0, y: CGFloat(activeColumn.position.row) * CELL_SIDE + CELL_SIDE/2.0)
        spritesNode.addChild(activeColumnSprite!)
        
        nextColumnSprite = ColumnNode(column: engine.nextColumn)
        nextColumnNode.removeAllChildren()
        nextColumnNode.addChild(nextColumnSprite!)
    }
    
    func fixColumn() {
        guard let activeColumnSprite = activeColumnSprite else { return }
        guard let activeColumn = engine.activeColumn else { return }
        
        let newPosition = CGPoint(x: CGFloat(activeColumn.position.column) * CELL_SIDE + CELL_SIDE/2.0, y: CGFloat(activeColumn.position.row) * CELL_SIDE + CELL_SIDE/2.0)
        let duration = (abs(newPosition.y - activeColumnSprite.position.y) / 80) * 0.1
        let moveAction = SKAction.moveTo(newPosition, duration: Double(duration))
        
        let removeColumnAction = SKAction.runBlock { () -> Void in
            for child in activeColumnSprite.children
            {
                let newPosition = activeColumnSprite.convertPoint(child.position, toNode: self.spritesNode)
                child.removeFromParent()
                child.position = newPosition
                self.spritesNode.addChild(child)
            }
            
            self.sprites[Int(activeColumn.position.column)] += [activeColumnSprite.bottom, activeColumnSprite.middle, activeColumnSprite.top]
            
            activeColumnSprite.removeFromParent()
            self.activeColumnSprite = nil
            self.engine.checkMatches()
        }
        
        let sequence = SKAction.sequence([moveAction, removeColumnAction])
        activeColumnSprite.runAction(sequence)
    }
    
    func shuffleColumn() {
        if let activeColumnSprite = activeColumnSprite
        {
            activeColumnSprite.shuffle()
        }
    }
    
    func removeSprites(positionsToRemove:[ColumnPosition])
    {
        var removeArray = [SKNode]()
        var actions = [(SKNode,SKAction)]()

        for c in 0..<6 {
            
            let column_sprites = sprites[c]
            var count = 0
            var toRemove = Set<SKNode>()
            
            for r in 0..<column_sprites.count {
                
                let sprite = column_sprites[r]
                
                if let _ = positionsToRemove.indexOf(ColumnPosition(column:c, row:r)) {
                    toRemove.insert(sprite)
                    let fade = SKAction.fadeOutWithDuration(0.25)
                    let remove = SKAction.removeFromParent()
                    sprite.runAction(SKAction.sequence([fade, remove]))
                    count += 1
                } else {
                    if count > 0 {
                        let wait = SKAction.waitForDuration(0.5)
                        let action = SKAction.moveBy(CGVector(dx: 0, dy: -CGFloat(count)*CELL_SIDE), duration: 0.1*Double(count))
                        actions.append((sprite, SKAction.sequence([wait, action])))
                    }
                }
            }
            
            removeArray += Array(toRemove)
            sprites[c] = column_sprites.filter { !toRemove.contains($0) }
        }
        
        actions.forEach {
            (sprite, action) -> () in
            sprite.runAction(action)
        }
        let wait = SKAction.waitForDuration(1.5)
        let continueAction = SKAction.runBlock { () -> Void in
            //self.spritesNode.removeChildrenInArray(removeArray)
            self.engine.checkMatches()
        }
        
        self.runAction(SKAction.sequence([wait, continueAction]))
    }
}

extension ColumnsScene:UIGestureRecognizerDelegate
{
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        
        let translation = panRecognizer.translationInView(self.view)
        return abs(translation.y) < abs(translation.x)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
