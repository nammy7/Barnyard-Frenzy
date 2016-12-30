//
//  FastGameSceneClass.swift
//  SwiftPick
//
//  Created by Nam Le on 12/14/16.
//  Copyright © 2016 Nam Le. All rights reserved.
//

import SpriteKit
import AVFoundation



class FastGameSceneClass: SKScene {
    
    //pause menu buttons
    var mainMenuButton = SKSpriteNode()
    var resumeGameButton = SKSpriteNode()
    var newGameButton = SKSpriteNode()
    var pauseButton = SKSpriteNode()
    var pauseBackground = SKSpriteNode()
    var gamePausedBanner = SKSpriteNode()
    var soundlabel = SKSpriteNode()
    
    //background music
    let backgroundMusic = SKAudioNode(fileNamed: "bgmusic.mp3")
    var backgroundMusicPlayer = AVAudioPlayer()
    let pauseMusic = SKAction.pause()
    let resumeMusic = SKAction.play()
    var musicSwitch = SKSpriteNode()
    
    
    //animations
    var countdownLabel = SKSpriteNode()
    let fadeOut = SKAction.fadeOut(withDuration: 0)
    let fadeIn = SKAction.fadeIn(withDuration: 0)
    let multiplierFadeIn = SKAction.fadeIn(withDuration: 2)
    let multiplierFadeOut = SKAction.fadeOut(withDuration: 2)
    let rotateView = SKAction.rotate(byAngle: -(CGFloat)(M_PI * 4), duration: 1.0)
    var audioPlayer = AVAudioPlayer()
    var sfxLaser: SystemSoundID = 0
    var sfxError: SystemSoundID = 0
    var bgmusic: SystemSoundID = 0
    var muted =  false
    var noMusic = false
    
    //score,timer,multiplier labels
    private var scoreLabel = SKLabelNode()
    private var timerLabel = SKLabelNode()
    private var multiplierLabel =  SKSpriteNode()
    private var highScoreLabel = SKLabelNode()
    
    //animals spots
    private var animal1 = SKSpriteNode()
    private var animal2 = SKSpriteNode()
    private var animal3 = SKSpriteNode()
    private var animal4 = SKSpriteNode()
    
    //animal buttons
    private var cow = SKSpriteNode()
    private var pig = SKSpriteNode()
    private var penguin = SKSpriteNode()
    private var hippo = SKSpriteNode()
    private var owl = SKSpriteNode()
    
    //game vars
    var timer =  Timer()
    var score = 0
    private var correctCount = 0
    private var multiplier = 0
    private var seconds = 0
    private var minX = CGFloat(-200)
    private var maxX = CGFloat(200)
    var highScore = 0
    var roundScore = 0
    
    
    private var cowTracker = 0, pigTracker = 0, penguinTracker = 0, hippoTracker = 0, owlTracker = 0
    
    let animalArray = ["cow.png", "pig.png", "penguin.png", "hippo.png", "owl.png"]
    
    
    
    
    
    override func didMove(to view: SKView) {
        
        
        //HIGH SCORE FROM MEMORY//
        let highScoreDefault = UserDefaults.standard
        if(highScoreDefault.value(forKey: "highScore") != nil) {
            highScore = highScoreDefault.value(forKey: "highScore") as! NSInteger!
        }
        let roundScoreDefault = UserDefaults.standard
        if(roundScoreDefault.value(forKey: "roundScore") != nil) {
            roundScore = roundScoreDefault.value(forKey: "roundScore") as! NSInteger!
        }
        let muteDefault = UserDefaults.standard
        if (muteDefault.value(forKey: "muted") != nil) {
            muted = muteDefault.value(forKey: "muted") as! Bool!
        }
        let noMusicDefault = UserDefaults.standard
        if(noMusicDefault.value(forKey: "noMusic") != nil) {
            noMusic = muteDefault.value(forKey: "noMusic") as! Bool!
        }
        
        initializeGame()
    }
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches {
            let location = touch.location(in: self)
            
            //pause button
            if atPoint(location).name == "pause" {
                paused()
                break;
            }
            /////// ----- PAUSE MENU ------- ////
            if atPoint(location).name == "resumeGame" {
                unPaused()
                break;
            }
            
            if atPoint(location).name == "newGame" {
                timer.invalidate()
                if let scene = FastGameSceneClass(fileNamed: "FastGameScene") {
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
            if atPoint(location).name == "sound" {
                if muted == false {
                    soundlabel.texture = SKTexture(imageNamed: "SoundOff")
                    muted = true
                    let muteDefault = UserDefaults.standard
                    muteDefault.setValue(muted, forKey: "muted")
                    muteDefault.synchronize()
                    print(muted)
                    
                }
                else{
                    if muted == true {
                        soundlabel.texture = SKTexture(imageNamed: "SoundOn")
                        muted = false
                        let muteDefault = UserDefaults.standard
                        muteDefault.setValue(muted, forKey: "muted")
                        muteDefault.synchronize()
                        print(muted)
                    }
                }
            }
            if atPoint(location).name == "musicSwitch" {
                if noMusic == false {
                    print("turning off music")
                    musicSwitch.texture = SKTexture(imageNamed: "MusicOff")
                    backgroundMusicPlayer.stop()
                    //backgroundMusic.removeFromParent()
                    noMusic = true
                    let noMusicDefault = UserDefaults.standard
                    noMusicDefault.setValue(noMusic, forKey: "noMusic")
                    noMusicDefault.synchronize()

                    
                }
                else{
                    if noMusic == true {
                        print("playing music")
                        //addChild(backgroundMusic)
                        playBackgroundMusic()
                        musicSwitch.texture = SKTexture(imageNamed: "MusicOn")
                        //backgroundMusic.run(resumeMusic)
                        noMusic = false
                        let noMusicDefault = UserDefaults.standard
                        noMusicDefault.setValue(noMusic, forKey: "noMusic")
                        noMusicDefault.synchronize()
                    }
                }
            }
          ////////-------- END OF PAUSE MENU ---------//////
            
            //PRESS COW BUTTON
            if atPoint(location).name == "cow" {
    
                //print("pressing cow button")
                //print(animal1?.texture!.description)
                //checks if images match
                if animal1.texture!.description == "<SKTexture> \'cow.png\' (60 x 60)" {
                    animal1.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    //animal1?.zRotation =  CGFloat(M_PI/2.0)
                    dropBall1(sprite: animal1)
                    scoreCorrect()
                    //print("animal1 is a cow")
                    break;
                }
                
                if animal2.texture!.description == "<SKTexture> \'cow.png\' (60 x 60)"{
                    animal2.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall2(sprite: animal2)
                    //print("animal2 is a cow")
                    break;
                }
                if animal3.texture!.description == "<SKTexture> \'cow.png\' (60 x 60)" {
                    animal3.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall3(sprite: animal3)
                    //print("animal3 is a cow")
                    break;
                }
                if animal4.texture!.description == "<SKTexture> \'cow.png\' (60 x 60)" {
                    animal4.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall4(sprite: animal4)
                    //print("animal4 is a cow")
                    break;
                }
                else {
                    scoreIncorrect()
                }
            }
            
            //PRESS PIG BUTTON
            if atPoint(location).name == "pig" {
                
                //print("pressing pig button")
                //print(animal1?.texture!.description)
                //checks if images match
                if animal1.texture!.description == "<SKTexture> \'pig.png\' (60 x 60)" {
                    animal1.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall1(sprite: animal1)
                    //print("animal1 is a pig")
                    break;
                }
                
                if animal2.texture!.description == "<SKTexture> \'pig.png\' (60 x 60)"{
                    animal2.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall2(sprite: animal2)
                    //print("animal2 is a pig")
                    break;
                }
                if animal3.texture!.description == "<SKTexture> \'pig.png\' (60 x 60)" {
                    animal3.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall3(sprite: animal3)
                    //print("animal3 is a pig")
                    break;
                }
                if animal4.texture!.description == "<SKTexture> \'pig.png\' (60 x 60)" {
                    animal4.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall4(sprite: animal4)
                    //print("animal4 is a pig")
                    break;
                } else {
                    scoreIncorrect()
                }
            }
            
            //PRESSING PENGUIN BUTTON
            if atPoint(location).name == "penguin" {
                
                //print("pressing penguin button")
                //print(animal1?.texture!.description)
                //checks if images match
                if animal1.texture!.description == "<SKTexture> \'penguin.png\' (60 x 60)" {
                    animal1.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall1(sprite: animal1)
                    //print("animal1 is a penguin")
                    break;
                }
                
                if animal2.texture!.description == "<SKTexture> \'penguin.png\' (60 x 60)"{
                    animal2.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall2(sprite: animal2)
                    //print("animal2 is a penguin")
                    break;
                }
                if animal3.texture!.description == "<SKTexture> \'penguin.png\' (60 x 60)" {
                    animal3.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall3(sprite: animal3)
                    //print("animal3 is a penguin")
                    break;
                }
                if animal4.texture!.description == "<SKTexture> \'penguin.png\' (60 x 60)" {
                    animal4.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall4(sprite: animal4)
                    //print("animal4 is a penguin")
                    break;
                } else {
                    scoreIncorrect()
                }
            }
            
            
            //PRESSING HIPPO BUTTON
            if atPoint(location).name == "hippo" {
                
                //print("pressing hippo button")
                //print(animal1?.texture!.description)
                //checks if images match
                if animal1.texture!.description == "<SKTexture> \'hippo.png\' (60 x 60)" {
                    animal1.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall1(sprite: animal1)
                    //print("animal1 is a hippo")
                    break;
                }
                
                if animal2.texture!.description == "<SKTexture> \'hippo.png\' (60 x 60)"{
                    animal2.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall2(sprite: animal2)
                    //print("animal2 is a hippo")
                    break;
                }
                if animal3.texture!.description == "<SKTexture> \'hippo.png\' (60 x 60)" {
                    animal3.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall3(sprite: animal3)
                    //print("animal3 is a hippo")
                    break;
                }
                if animal4.texture!.description == "<SKTexture> \'hippo.png\' (60 x 60)" {
                    animal4.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall4(sprite: animal4)
                    //print("animal4 is a hippo")
                    break;
                } else {
                    scoreIncorrect()
                }
            }
            
            //PRESSING OWL BUTTON
            if atPoint(location).name == "owl" {
                
                //print("pressing owl button")
                //print(animal1?.texture!.description)
                //checks if images match
                if animal1.texture!.description == "<SKTexture> \'owl.png\' (60 x 60)" {
                    animal1.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall1(sprite: animal1)
                    //print("animal1 is a owl")
                    break;
                }
                
                if animal2.texture!.description == "<SKTexture> \'owl.png\' (60 x 60)"{
                    animal2.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall2(sprite: animal2)
                    //print("animal2 is a owl")
                    break;
                }
                if animal3.texture!.description == "<SKTexture> \'owl.png\' (60 x 60)" {
                    animal3.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall3(sprite: animal3)
                    //print("animal3 is a owl")
                    break;
                }
                if animal4.texture!.description == "<SKTexture> \'owl.png\' (60 x 60)" {
                    animal4.texture = SKTexture(imageNamed: animalArray[ranNum()])
                    scoreCorrect()
                    dropBall4(sprite: animal4)
                    //print("animal4 is a owl")
                    break;
                } else {
                    scoreIncorrect()
                }
            }
        }
    }
    
    
    func initializeGame() {
        
        
        print("mute value: \(muted)")
        print("music value: \(noMusic)")
        // COUNTDOWN LABEL
        countdownLabel = childNode(withName: "countdownLabel") as! SKSpriteNode
        
       
        
        // LABELS
        musicSwitch = childNode(withName: "musicSwitch") as! SKSpriteNode
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        multiplierLabel = childNode(withName: "multiplierLabel") as! SKSpriteNode
        timerLabel = childNode(withName: "timerLabel") as! SKLabelNode
        timerLabel.text = "60"
        timerLabel.isHidden = true
        scoreLabel.isHidden =  true
        if muted == false {
            soundlabel.texture = SKTexture(imageNamed: "SoundOn")
        }
        if muted == true {
            soundlabel.texture = SKTexture(imageNamed: "SoundOff")
        }
        
        if noMusic == false {
            musicSwitch.texture = SKTexture(imageNamed: "MusicOn")
            playBackgroundMusic()
            //addChild(backgroundMusic)
        } else {
            if noMusic == true {
            musicSwitch.texture = SKTexture(imageNamed: "MusicOff")
            
            }
        }


       
        
        //sounds
        let sfxLaser = URL(fileURLWithPath: Bundle.main.path(forResource: "woosh", ofType: "mp3")!)
        let sfxError = URL(fileURLWithPath: Bundle.main.path(forResource: "splat", ofType: "wav")!)
        //let bgmusic = URL(fileURLWithPath: Bundle.main.path(forResource: "bgmusic", ofType: "mp3")!)
        //AudioServicesCreateSystemSoundID(bgmusic as CFURL, &self.bgmusic)
        AudioServicesCreateSystemSoundID(sfxLaser as CFURL, &self.sfxLaser)
        AudioServicesCreateSystemSoundID(sfxError as CFURL, &self.sfxError)
        
        //pause menu buttons
        pauseButton = childNode(withName: "pause") as! SKSpriteNode
        resumeGameButton = childNode(withName: "resumeGame") as! SKSpriteNode
        newGameButton = childNode(withName: "newGame") as! SKSpriteNode
        mainMenuButton = childNode(withName: "mainMenu")  as! SKSpriteNode
        pauseBackground = childNode(withName: "pauseBackground") as! SKSpriteNode
        gamePausedBanner = childNode(withName: "gamePaused") as! SKSpriteNode
        soundlabel = childNode(withName: "sound") as! SKSpriteNode
        if muted == false {
            soundlabel.texture = SKTexture(imageNamed: "SoundOn")
        }
        if muted == true {
            soundlabel.texture = SKTexture(imageNamed: "SoundOff")
        }

        
        // HIDE PAUSE MENU
        pauseButton.isHidden = false
        pauseBackground.isHidden = true
        gamePausedBanner.isHidden = true
        resumeGameButton.isHidden = true
        newGameButton.isHidden = true
        resumeGameButton.isHidden = true
        mainMenuButton.isHidden = true
        soundlabel.isHidden = true
        musicSwitch.isHidden = true
        
        
        
        //game timer
        seconds = 64
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(gameClock), userInfo: nil, repeats: true)
        
        //setup board

        animal1 = childNode(withName: "animal1") as! SKSpriteNode
        animal2 = childNode(withName: "animal2") as! SKSpriteNode
        animal3 = childNode(withName: "animal3") as! SKSpriteNode
        animal4 = childNode(withName: "animal4") as! SKSpriteNode
        animal1.isHidden = true
        animal2.isHidden = true
        animal3.isHidden = true
        animal4.isHidden = true
        
        cow = childNode(withName: "cow") as! SKSpriteNode
        pig = childNode(withName: "pig") as! SKSpriteNode
        penguin = childNode(withName: "penguin") as! SKSpriteNode
        hippo = childNode(withName: "hippo") as! SKSpriteNode
        owl = childNode(withName: "owl") as! SKSpriteNode
        cow.isHidden = true
        pig.isHidden = true
        penguin.isHidden = true
        hippo.isHidden = true
        owl.isHidden = true
        
        
       // animal1?.texture = SKTexture(imageNamed: animalArray[ranNum()])
       // animal2?.texture = SKTexture(imageNamed: animalArray[ranNum()])
       // animal3?.texture = SKTexture(imageNamed: animalArray[ranNum()])
       // animal4?.texture = SKTexture(imageNamed: animalArray[ranNum()])
        
    }
 
    
    //random number function
    fileprivate func ranNum() -> Int {
        let random = Int(arc4random_uniform(5))
        //print(random)
        return random
    }
    
        
    //track score
    func scoreCorrect() {
        correctCount += 1
        //run(correctSound)
        if muted == false {
            AudioServicesPlaySystemSound(self.sfxLaser)
        }
        
        if correctCount <= 10 {
            score += 1
        }
        if correctCount > 10 && correctCount <= 20 {
            multiplier = 2
            score += 1 * multiplier
            if correctCount == 11 {
                //multiplierAnimation.isHidden = false
                multiplierLabel.texture = SKTexture(imageNamed: "2x small")
                //multiplierAnimation?.texture = SKTexture(imageNamed: "2x-Multiplier")
                //multiplierSprite(sprite: multiplierAnimation!)
            }
            print("multiplier is now: \(multiplier)")
        }
        if correctCount > 20 && correctCount <= 30 {
            multiplier = 5
            score += 1 * multiplier
            if correctCount == 21 {
                //multiplierAnimation.isHidden = false
                multiplierLabel.texture = SKTexture(imageNamed: "5x small")
                //multiplierAnimation?.texture = SKTexture(imageNamed: "5x-Multiplier")
                //multiplierSprite(sprite: multiplierAnimation!)
            }
            print("multiiplier is now: \(multiplier)")
        }
        if correctCount > 30 {
            multiplier = 10
            score += 1 * multiplier
            if correctCount == 31 {
            //multiplierAnimation.isHidden = false
            multiplierLabel.texture = SKTexture(imageNamed: "10x small")
            //multiplierAnimation?.texture = SKTexture(imageNamed: "10x-Multiplier")
            //multiplierSprite(sprite: multiplierAnimation!)
            }
            print("multiplier is now: \(multiplier)")
        }
       
        scoreLabel.text = String(score)
    }
    
    func scoreIncorrect() {
        //run(errorSound)
        if muted == false {
            AudioServicesPlaySystemSound(self.sfxError)
        }

        correctCount = 0
        multiplier = 0
        //streakLabel.text = "Streak: \(correctCount)"
        multiplierLabel.texture = SKTexture(imageNamed: "0x small")
       // multiplierAnimation?.texture = SKTexture(imageNamed: "0x-Multiplier")
        //multiplierSprite(sprite: multiplierAnimation!)
        print("you fucked up back to 0x")
    }
    
    
    func dropBall1(sprite: SKSpriteNode) {
        
        sprite.run(fadeOut)
        let startPoint1 = CGPoint(x: -150, y: 450)
        let endPoint1 =  CGPoint(x: -135, y: 175)
        sprite.run(fadeIn)
        let move = SKAction.move(to: startPoint1, duration: 0)
        let move2 = SKAction.move(to: endPoint1, duration: 0.5)
        let moveToSequence = SKAction.sequence([move,move2])
        
        sprite.run(moveToSequence)
        sprite.run(rotateView)
    }
    
    func dropBall2(sprite: SKSpriteNode) {
        sprite.run(fadeOut)
        let startPoint1 = CGPoint(x: -50, y: 450)
        let endPoint1 =  CGPoint(x: -45, y: 175)
        sprite.run(fadeIn)
        let move = SKAction.move(to: startPoint1, duration: 0)
        let move2 = SKAction.move(to: endPoint1, duration: 0.5)
        let moveToSequence = SKAction.sequence([move,move2])
        
        sprite.run(moveToSequence)
        sprite.run(rotateView)
    }
    
    func dropBall3(sprite: SKSpriteNode) {
        sprite.run(fadeOut)
        let startPoint1 = CGPoint(x: 50, y: 450)
        let endPoint1 =  CGPoint(x: 45, y: 175)
        sprite.run(fadeIn)
        let move = SKAction.move(to: startPoint1, duration: 0)
        let move2 = SKAction.move(to: endPoint1, duration: 0.5)
        let moveToSequence = SKAction.sequence([move,move2])
        
        sprite.run(moveToSequence)
        sprite.run(rotateView)
    }
    
    func dropBall4(sprite: SKSpriteNode) {
        sprite.run(fadeOut)
        let startPoint1 = CGPoint(x: 150, y: 450)
        let endPoint1 =  CGPoint(x: 135, y: 175)
        sprite.run(fadeIn)
        let move = SKAction.move(to: startPoint1, duration: 0)
        let move2 = SKAction.move(to: endPoint1, duration: 0.5)
        let moveToSequence = SKAction.sequence([move,move2])
        
        sprite.run(moveToSequence)
        sprite.run(rotateView)
    }

    

    
    func gameClock() {
        seconds -= 1
        //print("\(seconds)")
        timerLabel.text = "\(seconds)"

        if seconds == 63 {
            countdownLabel.texture = SKTexture(imageNamed: "3")
        }
        if seconds == 62 {
            countdownLabel.texture = SKTexture(imageNamed: "2")
        }
        if seconds == 61 {
            countdownLabel.texture = SKTexture(imageNamed: "1")
        }
        if seconds == 60 {
            countdownLabel.isHidden = true
            timerLabel.isHidden = false
            scoreLabel.isHidden = false
            animal1.isHidden = false
            animal2.isHidden = false
            animal3.isHidden = false
            animal4.isHidden = false
            cow.isHidden = false
            pig.isHidden = false
            penguin.isHidden = false
            hippo.isHidden = false
            owl.isHidden = false

            animal1.texture = SKTexture(imageNamed: animalArray[ranNum()])
            animal2.texture = SKTexture(imageNamed: animalArray[ranNum()])
            animal3.texture = SKTexture(imageNamed: animalArray[ranNum()])
            animal4.texture = SKTexture(imageNamed: animalArray[ranNum()])
            dropBall1(sprite: animal1)
            dropBall2(sprite: animal2)
            dropBall3(sprite: animal3)
            dropBall4(sprite: animal4)
        }
        
        if seconds == 0 {
            timer.invalidate()
            
            //store high score
            if(score > highScore) {
                highScore = score
                let highScoreDefault = UserDefaults.standard
                highScoreDefault.setValue(highScore, forKey: "highScore")
                highScoreDefault.synchronize()
            }
            roundScore = score
            let roundScoreDefault = UserDefaults.standard
            roundScoreDefault.setValue(roundScore, forKey: "roundScore")
            roundScoreDefault.synchronize()
            restartGame()
        }
        
    }
    func paused() {
        resumeGameButton.isHidden = false
        newGameButton.isHidden = false
        mainMenuButton.isHidden = false
        pauseBackground.isHidden =  false
        gamePausedBanner.isHidden = false
        soundlabel.isHidden = false
        musicSwitch.isHidden = false
        pauseButton.isHidden = true
        timer.invalidate()
        
    }
    
    func unPaused() {
        resumeGameButton.isHidden = true
        newGameButton.isHidden = true
        mainMenuButton.isHidden = true
        pauseBackground.isHidden = true
        gamePausedBanner.isHidden = true
        soundlabel.isHidden = true
        musicSwitch.isHidden = true
        pauseButton.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(gameClock), userInfo: nil, repeats: true)
        
    }
    
    
    func playBackgroundMusic() {
        
        let audioSession = AVAudioSession.sharedInstance()
        try!audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)

        if let path = Bundle.main.path(forResource: "bgmusic", ofType: "mp3") {
            let filePath = NSURL(fileURLWithPath:path)
            backgroundMusicPlayer = try! AVAudioPlayer.init(contentsOf: filePath as URL)
            backgroundMusicPlayer.numberOfLoops = -1 //logic for infinite loop
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        }
        
    }
    
    
    func restartGame() {
        
        if let scene = FastGameEndScene(fileNamed: "FastGameEndScene") {
            // set the scale mode to fit the the window
            scene.scaleMode = .aspectFit
            
            //present the scene
            view!.presentScene(scene, transition:SKTransition.doorsOpenVertical(withDuration: TimeInterval(1.0)))
        }
    }
    
    
    
    
    
    
    
    
    
} //class 
