//
//  ItemController.swift
//  SwiftPick
//
//  Created by Nam Le on 12/5/16.
//  Copyright © 2016 Nam Le. All rights reserved.
//

import SpriteKit
class ItemController {
    
    private var minX = CGFloat(-200)
    private var maxX = CGFloat(200)
    private var redTracker = 0, greenTracker = 0, blueTracker = 0, yellowTracker = 0, pinkTracker = 0
    
    func spawnItems() -> SKSpriteNode {
        var item: SKSpriteNode?
        
        if Int(randomBetweenNumbers(firstNum: 0, secondNum: 10)) >= 8{
            item = SKSpriteNode(imageNamed: "ball1")
            item!.name = "redball\(redTracker)"
            item!.setScale(0.8)
            item!.physicsBody = SKPhysicsBody(circleOfRadius: item!.size.height / 2)
            redTracker += 1
        } else {
            let num = randomBetweenNumbers(firstNum: 0, secondNum: 8)
            
            if num >= 7 {
                // spawn green
                item = SKSpriteNode(imageNamed: "ball2")
                item!.name = "greenball\(greenTracker)"
                item!.setScale(0.8)
                item!.physicsBody = SKPhysicsBody(circleOfRadius: item!.size.height / 2)
                greenTracker += 1
            }
            if num >= 5 && num < 7 {
                // spawn blue
                item = SKSpriteNode(imageNamed: "ball3")
                item!.name = "blueball\(blueTracker)"
                item!.setScale(0.8)
                item!.physicsBody = SKPhysicsBody(circleOfRadius: item!.size.height / 2)
                blueTracker += 1
            }
            if num >= 3 && num < 5 {
                // spawn yellow
                item = SKSpriteNode(imageNamed: "ball4")
                item!.name = "yellowball\(yellowTracker)"
                item!.setScale(0.8)
                item!.physicsBody = SKPhysicsBody(circleOfRadius: item!.size.height / 2)
                yellowTracker += 1
            }
            if num >= 0 && num < 3 {
                // spawn pink
                item = SKSpriteNode(imageNamed: "ball5")
                item!.name = "pinkball\(pinkTracker)"
                item!.setScale(0.8)
                item!.physicsBody = SKPhysicsBody(circleOfRadius: item!.size.height / 2)
                pinkTracker += 1
            }
            
        }
        item!.zPosition = 3
        item!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        item!.position.x = randomBetweenNumbers(firstNum: minX, secondNum: maxX)
        item!.position.y = 450;
        return item!
    }
    
    
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum);
    }
    
    
    
    
}// class



























