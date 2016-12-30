//
//  FastGameEndSceneClass.swift
//  SwiftPick
//
//  Created by Nam Le on 12/17/16.
//  Copyright © 2016 Nam Le. All rights reserved.
//

import SpriteKit


class FastGameEndScene: SKScene {
    private var scoreLabel = SKLabelNode()
    private var highScoreLabel = SKLabelNode()
    private var highScore = 0
    private var roundScore = 0
    
    override func didMove(to view: SKView) {
        
        
        //PULL HIGH SCORE FROM MEMORY
        let highScoreDefault = UserDefaults.standard
        if(highScoreDefault.value(forKey: "highScore") != nil) {
            highScore = highScoreDefault.value(forKey: "highScore") as! NSInteger!
        }
        let roundScoreDefault = UserDefaults.standard
        if(roundScoreDefault.value(forKey: "roundScore") != nil) {
            roundScore = roundScoreDefault.value(forKey: "roundScore") as! NSInteger!
        }
        
        // HIGH SCORE
        highScoreLabel = childNode(withName: "highScoreLabel") as! SKLabelNode
        highScoreLabel.text = "\(highScore)"
        
        //Round score
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabel.text = "\(roundScore)"
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
            for touch in touches {
            let location =  touch.location(in: self)
            
            //start a new game
            if atPoint(location).name == "newGame" {
                if let scene = FastGameSceneClass(fileNamed: "FastGameScene") {
                    // set the scale mode to fit the the window
                    scene.scaleMode = .aspectFit
                    
                    //present the scene
                    view!.presentScene(scene, transition:SKTransition.doorsOpenVertical(withDuration: TimeInterval(1.0)))
                }
            }
            //go to main menu
            if atPoint(location).name == "mainMenu" {
                if let scene = MainMenuScene(fileNamed: "MainMenu") {
                    // set the scale mode to fit the the window
                    scene.scaleMode = .aspectFit
                    
                    //present the scene
                    view!.presentScene(scene, transition:SKTransition.doorsOpenVertical(withDuration: TimeInterval(1.0)))
                }
            }
            
        }
}

    
    
    
    
    
    
    
} // class
