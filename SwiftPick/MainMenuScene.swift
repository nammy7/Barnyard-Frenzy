//
//  MainMenuScene.swift
//  SwiftPick
//
//  Created by Nam Le on 12/4/16.
//  Copyright © 2016 Nam Le. All rights reserved.
//

import SpriteKit
import GameKit

class MainMenuScene: SKScene, GKGameCenterControllerDelegate {
    var highScore = Int()
    var soundLabel = SKSpriteNode()
    var muted = Bool()
    var noMusic = Bool()
    let backgroundMusic = SKAudioNode(fileNamed: "bgmusic.mp3")
    let pauseMusic = SKAction.pause()
    let resumeMusic = SKAction.play()
    
    override func didMove(to view: SKView) {
        
        
        
        //MUTE BUTTON VIEW
        soundLabel = childNode(withName: "sound") as! SKSpriteNode!
        let muteDefault = UserDefaults.standard
        if(muteDefault.value(forKey: "muted") != nil) {
            muted = muteDefault.value(forKey: "muted") as! Bool!
        }
        let noMusicDefault = UserDefaults.standard
        if(noMusicDefault.value(forKey: "noMusic") != nil) {
            noMusic = muteDefault.value(forKey: "noMusic") as! Bool!
        }

        if muted == false {
            soundLabel.texture = SKTexture(imageNamed: "unmute")
            //self.backgroundMusic.run(resumeMusic)
            print("sound is on")
        }
        if muted == true {
            soundLabel.texture = SKTexture(imageNamed: "mute")
            //self.backgroundMusic.run(pauseMusic)
            print("sound is off")
            
        }
        
        
        //// SAVING HIGH SCORE
        let highScoreDefault = UserDefaults.standard
        if(highScoreDefault.value(forKey: "highScore") != nil) {
            highScore = highScoreDefault.value(forKey: "highScore") as! NSInteger!
        }
        saveHighScore(number: highScore)
        
        soundLabel.isHidden = true
        
        
       
        
        
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location =  touch.location(in: self)
            
            
            if atPoint(location).name == "fastPlay" {
                if let scene = FastGameSceneClass(fileNamed: "FastGameScene") {
                    //set the mode to fit the window
                    scene.scaleMode = .aspectFit
                    
                    //present the scene
                    view!.presentScene(scene, transition: SKTransition.doorsOpenVertical(withDuration: (1.0)))
                }
            }
            if atPoint(location).name == "highScores" {
                showLeaderboard()
            }
            if atPoint(location).name == "howToPlay" {
                if let scene = HowToPlaySceneClass(fileNamed: "HowToPlayScene") {
                    scene.scaleMode = .aspectFit
                
                view!.presentScene(scene, transition: SKTransition.doorsOpenVertical(withDuration: (1.0)))
                }
            }
            if atPoint(location).name == "sound" {
                if muted == false {
                    soundLabel.texture = SKTexture(imageNamed: "mute")
                    muted = true
                    //backgroundMusic.run(pauseMusic)
                    let muteDefault = UserDefaults.standard
                    muteDefault.setValue(muted, forKey: "muted")
                    muteDefault.synchronize()
                
                }
                else {
                    soundLabel.texture = SKTexture(imageNamed: "unmute")
                    muted = false
                    //backgroundMusic.run(resumeMusic)
                    let muteDefault = UserDefaults.standard
                    muteDefault.setValue(muted, forKey: "muted")
                    muteDefault.synchronize()
                }
            }
        }
    }
        
    func saveHighScore(number: Int) {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "barnYardFrenzy")
            
            scoreReporter.value = Int64(number)
            let scoreArray : [GKScore] =  [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
    }
    
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

    
    func showLeaderboard() {
        let viewController = self.view?.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        
        gcvc.gameCenterDelegate = self
        
        viewController?.present(gcvc, animated: true, completion: nil)
    }
    

    
    
        
    
}// class
