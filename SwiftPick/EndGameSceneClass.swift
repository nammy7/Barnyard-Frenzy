//
//  EndGameSceneClass.swift
//  SwiftPick
//
//  Created by Nam Le on 12/10/16.
//  Copyright © 2016 Nam Le. All rights reserved.
//

import SpriteKit

class EndGameScene: SKScene {
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
            for touch in touches {
                let location =  touch.location(in: self)
                
                //start a new game
                if atPoint(location).name == "newGame" {
                    if let scene = OnePlayerSceneClass(fileNamed: "OnePlayerScene") {
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


}// class
    
    
    
    
    
    
    
