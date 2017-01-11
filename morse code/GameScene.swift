//
//  GameScene.swift
//  morse code
//
//  Created by Christopher Wilkinson on 09/01/2017.
//  Copyright © 2017 Christopher Wilkinson. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    private var tonePlayer = AVAudioPlayer()
    
    public var unit = 1.0 // length of a dit / space
    //public var gapUnit = unit
    
    
    let dit = CGRect(x: 100.0, y: 100.0, width: 100.0, height: 10.0)
    let dah = CGRect(x: 100.0, y: 100.0, width: 10.0, height: 10.0)
    
    var chars = [String: Array<Any>]()
    
    let tapButton = SKSpriteNode()
    var wordsPerMinLabel = SKLabelNode()
    var timeLabel = SKLabelNode()
    
    
    override func didMove(to view: SKView) {
        chars = [
            "a": [dit, dah],
            "b": [dah, dit, dit, dit],
            "c": [dah, dit, dah, dit],
            "d": [dah, dit, dit],
            "e": [dit],
            "f": [dit, dit, dah, dit],
            "g": [dah, dah, dit],
            "h": [dit, dit, dit, dit],
            "i": [dit, dit],
            "j": [dit, dah, dah, dah],
            "k": [dah, dit, dah],
            "l": [dit, dah, dit, dit],
            "m": [dah, dah],
            "n": [dah, dit],
            "o": [dah, dah, dah],
            "p": [dit, dah, dah, dit],
            "q": [dah, dah, dit, dah],
            "r": [dit, dah, dit],
            "s": [dit, dit, dit],
            "t": [dah],
            "u": [dit, dit, dah],
            "v": [dit, dit, dit, dah],
            "w": [dit, dah, dah],
            "x": [dah, dit, dit, dah],
            "y": [dah, dit, dah, dah],
            "z": [dah, dah, dit, dit],
            
            "1": [dit, dah, dah, dah, dah],
            "2": [dit, dit, dah, dah, dah],
            "3": [dit, dit, dit, dah, dah],
            "4": [dit, dit, dit, dit, dah],
            "5": [dit, dit, dit, dit, dit],
            "6": [dah, dit, dit, dit, dit],
            "7": [dah, dah, dit, dit, dit],
            "8": [dah, dah, dah, dit, dit],
            "9": [dah, dah, dah, dah, dit],
            "0": [dah, dah, dah, dah, dah],
        ]
        
        let toneFilePath = Bundle.main.path(forResource: "1kHz_tone", ofType: "wav")
        let toneFileUrl = NSURL(fileURLWithPath: toneFilePath!)
        _ = try? tonePlayer = AVAudioPlayer(contentsOf: toneFileUrl as URL)
        tonePlayer.numberOfLoops = -1 // loop indefinitley
        tonePlayer.prepareToPlay()
        
        self.backgroundColor = SKColor(red: 60/255, green: 173/255, blue: 237/255, alpha: 1)
        
        setupButtons()
        setupLabels()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            if tapButton.frame.contains(touch.location(in: self)) {
                tonePlayer.play()
                // todo: start tapTimer
                (tapButton.childNode(withName: "tapButtonInner") as! SKSpriteNode).color = UIColor(red: 160/255, green: 225/255, blue: 255/255, alpha: 1)
                
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            if tapButton.frame.contains(touch.location(in: self)) {
                // todo: end tapTimer
                // todo: calculate if dit or dah was entered
                run(SKAction.sequence([SKAction.wait(forDuration: 0.005), SKAction.run {
                    self.tonePlayer.stop()
                    self.tonePlayer.prepareToPlay()
                    (self.tapButton.childNode(withName: "tapButtonInner") as! SKSpriteNode).color = UIColor(red: 194/255, green: 234/255, blue: 255/255, alpha: 1)
                    }]))
            }
        }
    }
    
    
    /* ~~~~~~~~~~~ SETUP ~~~~~~~~~~ */
    
    func setupButtons() {
        tapButton.size = CGSize(width: 100, height: 100)
        tapButton.position = CGPoint(x: (frame.midX - frame.width/4), y: frame.midY)
        tapButton.color = UIColor(red: 115/255, green: 220/255, blue: 255/255, alpha: 1)
        tapButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(tapButton)
        
        let tapButtonInner = SKSpriteNode(color: UIColor(red: 194/255, green: 234/255, blue: 255/255, alpha: 1), size: tapButton.frame.insetBy(dx: 10, dy: 10).size)
        tapButtonInner.position = CGPoint(x: 0, y: 0 )
        tapButtonInner.name = "tapButtonInner"
        tapButtonInner.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tapButton.addChild(tapButtonInner)
    }
    
    func setupLabels() {
        let wordsPerMin = Int((unit * 18) / 60)
        wordsPerMinLabel.text = "\(wordsPerMin) wpm"
        wordsPerMinLabel.position = CGPoint(x: frame.maxX - 10, y: frame.minY + 10)
        wordsPerMinLabel.horizontalAlignmentMode = .right
        wordsPerMinLabel.verticalAlignmentMode = .bottom
        addChild(wordsPerMinLabel)
        
        timeLabel.text = "time"
        timeLabel.position = CGPoint(x: frame.maxX - 10, y: (frame.minY + 10 + wordsPerMinLabel.fontSize + 10) )
        timeLabel.horizontalAlignmentMode = .right
        timeLabel.verticalAlignmentMode = .bottom
        addChild(timeLabel)
        
    }
}
