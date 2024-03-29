//
//  TheWallScene.swift
//  Simple Games
//
//  Created by Ricardo Sánchez Sotres on 21/10/15.
//  Copyright © 2015 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import SpriteKit

class TheWallScene: GameScene {
        
    let BallCategory   : UInt32 = 0x1 << 0
    let BlockCategory  : UInt32 = 0x1 << 1
    let PaddleCategory : UInt32 = 0x1 << 2
    let TopWallCategory    : UInt32 = 0x1 << 3
    let RightWallCategory  : UInt32 = 0x1 << 4
    let LeftWallCategory   : UInt32 = 0x1 << 5
    let BottomWallCategory : UInt32 = 0x1 << 6

    let GRID_WIDTH:CGFloat = 1200
    let GRID_HEIGHT:CGFloat = 1000
    
    let levelManager = LevelManager()
    
    let gameNode = SKNode()
    let blocksNode = SKCropNode()
    
    var pingSounds = [SKAction.playSoundFileNamed("ping1.mp3", waitForCompletion: false),
        SKAction.playSoundFileNamed("ping2.mp3", waitForCompletion: false)]
    var puckSound = SKAction.playSoundFileNamed("puck.mp3", waitForCompletion: false)

    
    var grid:GridNode {
        get {
            return GridNode(size: CGSize(width: GRID_WIDTH, height: GRID_HEIGHT))
        }
    }
    let ball = BallNode()
    let paddle = PaddleNode()
    
    var ballInPlay = false
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let background = SKSpriteNode(imageNamed: "thewall_background")
        background.zPosition = -3
        background.position = CGPoint(x: view.bounds.size.width/2.0, y: view.bounds.size.height/2.0)
        addChild(background)
        
        LevelManager.GRID_HEIGHT = GRID_HEIGHT
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        
        gameNode.position = CGPoint(x: 40, y: 40)
        addChild(gameNode)
        
        gameNode.addChild(blocksNode)
        
        let maskNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: GRID_WIDTH, height: GRID_HEIGHT))
        maskNode.fillColor = UIColor.redColor()
        blocksNode.maskNode = maskNode
        blocksNode.zPosition = 2

        
        grid.zPosition = -1
        gameNode.addChild(grid)
        
        let top = SKShapeNode(rectOfSize: CGSize(width: GRID_WIDTH, height: 10))
        top.position = CGPoint(x: GRID_WIDTH/2, y: GRID_HEIGHT+5)
        top.fillColor = UIColor.clearColor()
        top.strokeColor = UIColor.clearColor()
        top.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: GRID_WIDTH, height: 10))
        top.physicsBody!.categoryBitMask = TopWallCategory
        top.physicsBody!.collisionBitMask = 0
        gameNode.addChild(top)
        
        ball.zPosition = 2
        ball.physicsBody!.categoryBitMask = BallCategory
        ball.physicsBody!.collisionBitMask = 0
        ball.physicsBody!.contactTestBitMask = BlockCategory|TopWallCategory|RightWallCategory|LeftWallCategory|BottomWallCategory|PaddleCategory
        gameNode.addChild(ball)
       
        paddle.zPosition = 2
        paddle.position = CGPoint(x: GRID_WIDTH/2.0, y: 80 - 20)
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        paddle.physicsBody!.collisionBitMask = 0
        gameNode.addChild(paddle)
        
        setupLimits()
        nextLevel()
        
        let pan = UIPanGestureRecognizer(target: self, action: Selector("pan:"))
        self.view?.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("tap:"))
        tap.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]
        self.view!.superview?.addGestureRecognizer(tap)

        let tapNext = UITapGestureRecognizer(target: self, action: Selector("nextLevel"))
        tapNext.allowedPressTypes = [NSNumber(integer: UIPressType.RightArrow.rawValue)]
        self.view!.superview?.addGestureRecognizer(tapNext)
        
    }
    
    func nextLevel()
    {
        levelManager.loadNextLevel(blocksNode, category:BlockCategory, delegate:self)
    }
    
    func setupLimits()
    {
        let bottom = SKShapeNode(rectOfSize: CGSize(width: GRID_WIDTH, height: 10))
        bottom.position = CGPoint(x: GRID_WIDTH/2, y: -5)
        bottom.fillColor = UIColor.clearColor()
        bottom.strokeColor = UIColor.clearColor()
        bottom.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: GRID_WIDTH, height: 10))
        bottom.physicsBody!.categoryBitMask = BottomWallCategory
        bottom.physicsBody!.collisionBitMask = 0
        gameNode.addChild(bottom)
        
        let right = SKShapeNode(rectOfSize: CGSize(width: 10, height: GRID_HEIGHT))
        right.position = CGPoint(x: GRID_WIDTH+5, y: GRID_HEIGHT/2)
        right.fillColor = UIColor.clearColor()
        right.strokeColor = UIColor.clearColor()
        right.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 10, height: GRID_HEIGHT))
        right.physicsBody!.categoryBitMask = RightWallCategory
        right.physicsBody!.collisionBitMask = 0
        gameNode.addChild(right)
        
        
        let left = SKShapeNode(rectOfSize: CGSize(width: 10, height: GRID_HEIGHT))
        left.position = CGPoint(x: -5, y: GRID_HEIGHT/2)
        left.fillColor = UIColor.clearColor()
        left.strokeColor = UIColor.clearColor()
        left.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 10, height: GRID_HEIGHT))
        left.physicsBody!.categoryBitMask = LeftWallCategory
        left.physicsBody!.collisionBitMask = 0
        gameNode.addChild(left)
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        
        if ballInPlay {
            ball.update()
        } else {
            ball.position = CGPoint(x: paddle.position.x + 20, y: paddle.position.y + 20 + 10)
        }
        
        if(!dragging && paddleVelocity != 0) {
            paddle.position = CGPoint(x: paddle.position.x + paddleVelocity*0.01, y: paddle.position.y)
            if paddle.position.x < paddle.frame.size.width/2.0 {
                paddle.position.x = paddle.frame.size.width/2.0
                paddleVelocity *= -0.8
            }
            
            if paddle.position.x > GRID_WIDTH - paddle.frame.size.width/2.0 {
                paddle.position.x = GRID_WIDTH - paddle.frame.size.width/2.0
                paddleVelocity *= -0.8
            }
            
            paddleVelocity *= 0.8
            if(abs(paddleVelocity) < 0.0001) {
                paddleVelocity = 0.0
            }
        }
    }
    
    var dragging = false
    var paddleVelocity:CGFloat = 0.0
    
    func pan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view).x
        paddleVelocity = recognizer.velocityInView(self.view).x
        
        var paddlePos:CGFloat = 0
        
        switch recognizer.state {
        case UIGestureRecognizerState.Began:
            dragging = true
            break
        case UIGestureRecognizerState.Changed:
            print("velocity \(paddleVelocity)")
            print("translation \(translation)")
            paddlePos = paddle.position.x + pow(paddleVelocity/500, 2) * (paddleVelocity < 0 ? -1 : 1)
            paddlePos = paddlePos < paddle.frame.size.width/2.0 ? paddle.frame.size.width/2.0 : (paddlePos > GRID_WIDTH - paddle.frame.size.width/2.0 ? GRID_WIDTH - paddle.frame.size.width/2.0 : paddlePos)
            paddle.position = CGPoint(x: paddlePos, y: paddle.position.y)
            if !ballInPlay {
                ball.position = CGPoint(x: paddle.position.x + 20, y: paddle.position.y + 20 + 10)
            }
        case UIGestureRecognizerState.Ended:
            dragging = false
        default:
            break
        }
        
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    func tap(recognizer:UITapGestureRecognizer) {
        if !ballInPlay {
            ballInPlay = true
        }
    }
}

extension TheWallScene:SKPhysicsContactDelegate
{
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask != BallCategory {
            return
        }
        
        switch secondBody.categoryBitMask {
        case TopWallCategory:
            ball.direction = CGVector(dx:ball.direction.dx, dy:-ball.direction.dy)
            runAction(puckSound)
        case RightWallCategory, LeftWallCategory:
            ball.direction = CGVector(dx:-ball.direction.dx, dy:ball.direction.dy)
            runAction(puckSound)
        case BottomWallCategory:
            //Loose
            ball.direction = CGVector(dx:ball.direction.dx, dy:-ball.direction.dy)
            runAction(puckSound)
       
        case BlockCategory:
            if (firstBody.node?.position.x >= (secondBody.node?.position.x)! + (secondBody.node?.frame.size.width)!/2.0) {
                ball.direction = CGVector(dx: abs(ball.direction.dx), dy: ball.direction.dy)
            }
            
            if (firstBody.node?.position.x <= (secondBody.node?.position.x)! - (secondBody.node?.frame.size.width)!/2.0) {
                ball.direction = CGVector(dx: -abs(ball.direction.dx), dy: ball.direction.dy)
            }
            
            if (firstBody.node?.position.y >= (secondBody.node?.position.y)! + (secondBody.node?.frame.size.height)!/2.0) {
                ball.direction = CGVector(dx: ball.direction.dx, dy: abs(ball.direction.dy))
            }
            
            if (firstBody.node?.position.y <= (secondBody.node?.position.y)! - (secondBody.node?.frame.size.height)!/2.0) {
                ball.direction = CGVector(dx: ball.direction.dx, dy: -abs(ball.direction.dy))
            }
            

            (secondBody.node as? BlockNode)?.hit()
            
            runAction(pingSounds[0])
            
        case PaddleCategory:
            if (firstBody.node?.position.x > (secondBody.node?.position.x)! + (secondBody.node?.frame.size.width)!/2.0 || firstBody.node?.position.x < (secondBody.node?.position.x)! - (secondBody.node?.frame.size.width)!/2.0) {
                ball.direction = CGVector(dx: -ball.direction.dx, dy: ball.direction.dy)
            } else {
                let delta = CGVector(dx:firstBody.node!.position.x-secondBody.node!.position.x, dy:firstBody.node!.position.y-secondBody.node!.position.y)
                let length:CGFloat = sqrt(delta.dx * delta.dx + delta.dy * delta.dy)
                ball.direction = CGVector(dx: delta.dx / length, dy: delta.dy / length)
                
            }
          
            runAction(pingSounds[1])
            
        case BallCategory:
            //The ball can't collide with itself
            break
        default:
            break
        }

    }
}

extension TheWallScene:BlockNodeDelegate
{
    func blockExploded(block: BlockNode) {

        block.removeFromParent()
        
        if blocksNode.children.count == 0 {
            ballInPlay = false
            nextLevel()
        }
    }
}

