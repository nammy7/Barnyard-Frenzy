//
//  OnePlayerSceneClass.swift
//  SwiftPick
//
//  Created by Nam Le on 12/4/16.
//  Copyright © 2016 Nam Le. All rights reserved.
//

import SpriteKit
import AVFoundation
import AudioToolbox


class OnePlayerSceneClass: SKScene {
    
    private var itemController = ItemController();
    private var scoreLabel: SKLabelNode?
    private var livesLabel: SKLabelNode?
    private var multiplierLabel: SKLabelNode?
    private var mainMenuButton = SKSpriteNode()
    private var resumeGameButton = SKSpriteNode()
    private var newGameButton = SKSpriteNode()
    private var pauseButton = SKSpriteNode()


    
    private var score = 0
    private var lives = 5
    private var redCounter = 0, blueCounter = 0, greenCounter = 0, yellowCounter = 0, pinkCounter = 0;
    private var seconds = 0
    private var timer = Timer()
    private var dropRate = Timer()
    private var remove = Timer()
    private var correctCount = 0, multiplier = 0, incorrectCount = 0;
    
    
    
    
    override func didMove(to view: SKView) {
        initializeGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches {
            let location =  touch.location(in: self)
            
            if atPoint(location).name == "pause" {
                print("pressed pause button")
                resumeGameButton.isHidden = false
                newGameButton.isHidden = false
                mainMenuButton.isHidden = false
                pauseButton.isHidden = true
                timer.invalidate()
                dropRate.invalidate()
                remove.invalidate()
                self.scene?.isPaused = true
                break;
            }
            
            /////// ----- PAUSE MENU ------- ////
            if atPoint(location).name == "resumeGame" {
                resumeGameButton.isHidden = true
                newGameButton.isHidden = true
                mainMenuButton.isHidden = true
                pauseButton.isHidden = false
                self.scene?.isPaused =  false
                
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(gameClock), userInfo: nil, repeats: true)
                
                
                dropRate = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(difficulty), userInfo: nil, repeats: true)
                
                remove = Timer.scheduledTimer(timeInterval: TimeInterval(0.0), target: self, selector: #selector(OnePlayerSceneClass.removeItems), userInfo: nil, repeats: true)

                break;
            }
            
            if atPoint(location).name == "newGame" {
                timer.invalidate()
                if let scene = OnePlayerSceneClass(fileNamed: "OnePlayerScene") {
                    // set the scale mode to fit the the window
                    scene.scaleMode = .aspectFit
                    
                    //present the scene
                    view!.presentScene(scene, transition:SKTransition.doorsOpenVertical(withDuration: TimeInterval(1.0)))
                }
            }
            
            if atPoint(location).name == "mainMenu" {
                timer.invalidate()
                if let scene = MainMenuScene(fileNamed: "MainMenu") {
                    scene.scaleMode = .aspectFit
                    view!.presentScene(scene, transition:SKTransition.doorsOpenVertical(withDuration: TimeInterval(1.0)))
                }
            }
            ////////-------- END OF PAUSE MENU ---------//////

            
            for child in children {
                
                //if red button match
                if (atPoint(location).name == "red") {
                    if child.name == "redball\(redCounter)"{
                        child.removeFromParent()
                        redCounter += 1
                        scoreCorrect()
                        print("red is matched")
                        break;
                    }
                    if !(childNode(withName: "redball\(redCounter)") != nil) {
                        print("incorrect match")
                        scoreIncorrect()
                        break;
                    }
                }
        
                //if green button match
                if (atPoint(location).name == "green") {
                    if child.name == "greenball\(greenCounter)" {
                        childNode(withName: "greenball\(self.greenCounter)")?.removeFromParent()
                        greenCounter += 1
                        scoreCorrect()
                        print("green is matched")
                        break;
                    }
                    if !(childNode(withName: "greenball\(greenCounter)") != nil) {
                        print("incorrect match")
                        scoreIncorrect()
                        break;
                    }
                }
                
                //if blue button match
                if (atPoint(location).name == "blue") {
                    if child.name == "blueball\(blueCounter)" {
                        childNode(withName: "blueball\(self.blueCounter)")?.removeFromParent()
                        blueCounter += 1
                        scoreCorrect()
                        print("blue is matched")
                        break;
                    }
                    if !(childNode(withName: "blueball\(blueCounter)") != nil) {
                        print("incorrect match")
                        scoreIncorrect()
                        break;
                    }
                }
                
                //if yellow button match
                if (atPoint(location).name == "yellow") {
                    if child.name == "yellowball\(yellowCounter)" {
                        childNode(withName: "yellowball\(self.yellowCounter)")?.removeFromParent()
                        yellowCounter += 1
                        scoreCorrect()
                        print("yellow is matched")
                        break;
                        
                    }
                    if !(childNode(withName: "yellowball\(yellowCounter)") != nil) {
                        print("incorrect match")
                        scoreIncorrect()
                        break;
                    }
                }

                //if pink button match
                if (atPoint(location).name == "pink") {
                    if child.name == "pinkball\(pinkCounter)" {
                        childNode(withName: "pinkball\(self.pinkCounter)")?.removeFromParent()
                        pinkCounter += 1
                        scoreCorrect()
                        print("pink is matched")
                        break;
                    }
                    if !(childNode(withName: "pinkball\(pinkCounter)") != nil) {
                        print("incorrect match")
                        scoreIncorrect()
                        break;
                    }
                }
            }
        }
    }

    
    //setup the game
    private func initializeGame() {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -0.5)
        self.physicsBody?.velocity = CGVector(dx: 0, dy: -0.5)
        
        //lives tracker
        livesLabel = childNode(withName: "LivesLabel") as? SKLabelNode!
        livesLabel?.text = "5"
        
        //pause menu
        pauseButton = childNode(withName: "pause") as! SKSpriteNode
        resumeGameButton = childNode(withName: "resumeGame") as! SKSpriteNode
        newGameButton = childNode(withName: "newGame") as! SKSpriteNode
        mainMenuButton = childNode(withName: "mainMenu")  as! SKSpriteNode
        pauseButton.isHidden = false
        resumeGameButton.isHidden = true
        newGameButton.isHidden = true
        resumeGameButton.isHidden = true
        mainMenuButton.isHidden = true
        
        
        //score
        scoreLabel = childNode(withName: "ScoreLabel") as? SKLabelNode!
        scoreLabel?.text = "0"
        
        //multiplier tracker
        multiplierLabel = childNode(withName: "multiplierLabel") as? SKLabelNode!
        multiplierLabel?.text = "0x"
        
        //game clock   
        seconds = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(gameClock), userInfo: nil, repeats: true)
        
        
        //drop rate
        difficulty()
        dropRate = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(difficulty), userInfo: nil, repeats: true)
        
        
        //remove fallen objects
        remove = Timer.scheduledTimer(timeInterval: TimeInterval(0.0), target: self, selector: #selector(OnePlayerSceneClass.removeItems), userInfo: nil, repeats: true)
        
    }
    
    
    //function that spawns balls
    func spawnItems() {
        self.scene?.addChild(itemController.spawnItems())
    }
    
    func restartGame() {
        
        if let scene = EndGameScene(fileNamed: "EndGameScene") {
            // set the scale mode to fit the the window
            scene.scaleMode = .aspectFit
            
            //present the scene
            view!.presentScene(scene, transition:SKTransition.doorsOpenVertical(withDuration: TimeInterval(2)))
        }
    }
    
    //remove items
    func removeItems() {
        for child in children {
            if child.name ==  "redball\(redCounter)" || child.name == "blueball\(blueCounter)" || child.name == "greenball\(greenCounter)"||child.name == "yellowball\(yellowCounter)" || child.name == "pinkball\(pinkCounter)" {
                if child.position.y < -self.scene!.frame.height + 300 {
                    
                    //if red ball
                    if child.name == "redball\(redCounter)" {
                        child.removeFromParent();
                        lives-=1;
                        livesLabel?.text = String(lives)
                        redCounter += 1
                        scoreIncorrect()
                    }
                    //if green ball
                    if child.name == "greenball\(greenCounter)" {
                        child.removeFromParent();
                        lives-=1;
                        livesLabel?.text = String(lives)
                        greenCounter += 1
                        scoreIncorrect()
                    }
                    //if blue ball
                    if child.name == "blueball\(blueCounter)" {
                        child.removeFromParent();
                        lives-=1;
                        livesLabel?.text = String(lives)
                        blueCounter += 1
                        scoreIncorrect()
                    }
                    //if yellow ball
                    if child.name == "yellowball\(yellowCounter)" {
                        child.removeFromParent();
                        lives-=1;
                        livesLabel?.text = String(lives)
                        yellowCounter += 1
                        scoreIncorrect()
                    }
                    //if pink ball
                    if child.name == "pinkball\(pinkCounter)" {
                        child.removeFromParent();
                        lives-=1;
                        livesLabel?.text = String(lives)
                        pinkCounter += 1
                        scoreIncorrect()
                    }
                    // LIVES END RESTART GAME
                        if lives == 0 {
                            timer.invalidate()
                            dropRate.invalidate()
                            remove.invalidate()
                            restartGame();
                        }
                }
            }
        }
    }
    
    
    //GAME CLOCK
    func gameClock() {
        seconds += 1
        print("seconds: \(seconds)")
    }
    
    //TRACK SCORE
    func scoreCorrect() {
        correctCount += 1
        
        if correctCount <= 10 {
            score += 1
        }
        if correctCount > 10 && correctCount <= 20 {
            multiplier = 2
            score += 1 * multiplier
            print("multiplier is now: \(multiplier)")
        }
        if correctCount > 20 && correctCount <= 30 {
            multiplier = 5
            score += 1 * multiplier
            print("multiiplier is now: \(multiplier)")
        }
        if correctCount > 30 {
            multiplier = 10
            score += 1 * multiplier
            print("multiplier is now: \(multiplier)")
        }
        multiplierLabel?.text = String(multiplier) + "x"
        scoreLabel?.text = String(score)
    }
    
    //incorrect match
    func scoreIncorrect() {
        correctCount = 0
        multiplier = 0
        multiplierLabel?.text = String(multiplier)
        print("incorrect back to 0 multiplier")
        
    }
    
    // INCREASE DIFFICULTY BY TIME
    func difficulty() {
        
        if (seconds < 15) {
        // initialize easy drop rate
        Timer.scheduledTimer(timeInterval: TimeInterval(itemController.randomBetweenNumbers(firstNum: 1.5, secondNum: 2.0)), target: self, selector: #selector(OnePlayerSceneClass.spawnItems), userInfo: nil, repeats: true)
            print("this is easy")
        }
        
        if (seconds >= 15 && seconds < 30) {
        // initialize medium drop rate
        Timer.scheduledTimer(timeInterval: TimeInterval(itemController.randomBetweenNumbers(firstNum: 1.0, secondNum: 1.5)), target: self, selector: #selector(OnePlayerSceneClass.spawnItems), userInfo: nil, repeats: true)
            print("this is medium")
        }
        if (seconds >= 30 && seconds < 45) {
        // initialize hard drop rate
        Timer.scheduledTimer(timeInterval: TimeInterval(itemController.randomBetweenNumbers(firstNum: 0.5, secondNum: 1.0)), target: self, selector: #selector(OnePlayerSceneClass.spawnItems), userInfo: nil, repeats: true)
            print("this is hard")
        }
        if (seconds >= 45) {
        // intialize insane drop rate
            Timer.scheduledTimer(timeInterval: TimeInterval(itemController.randomBetweenNumbers(firstNum: 0.5, secondNum: 0.5)), target: self, selector: #selector(OnePlayerSceneClass.spawnItems), userInfo: nil, repeats: true)
            print("this is insane")
        }
    }
    
} // class



