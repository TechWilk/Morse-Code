//
//  PlaybackScene.swift
//  morse code
//
//  Created by Christopher Wilkinson on 30/01/2017.
//  Copyright © 2017 Christopher Wilkinson. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

protocol PlaybackSceneDelegate {
    func sentanceComplete(completed: Bool)
}

class PlaybackScene: SKScene {
    
    var playbackSceneDelegate: PlaybackSceneDelegate?
    
    
    
    
    var tonePlayer = AVAudioPlayer()
        
    var morseUnitPerSecond = (10.0*41)/60 // length of a dit / space per second
    let unitDisplaySize = 50.0
    
    let dit = MorseCode.dit
    let dah = MorseCode.dah
    
    var chars = MorseCode.charactersArray()
    
    var wordsPerMinLabel = SKLabelNode()
    var textLabel = SKLabelNode()
    var skipLabel = SKLabelNode()
    var backLabel = SKLabelNode()
    
    var sentance = "morse code"
    
    
    override func didMove(to view: SKView) {
        
        let toneFilePath = Bundle.main.path(forResource: "1kHz_tone", ofType: "wav")
        let toneFileUrl = NSURL(fileURLWithPath: toneFilePath!)
        _ = try? tonePlayer = AVAudioPlayer(contentsOf: toneFileUrl as URL)
        tonePlayer.numberOfLoops = -1 // loop indefinitley
        tonePlayer.prepareToPlay()
        
        // play dit tone as a work-around to bug in AVAudioPlayer where first-time playing of looped audio stutters!
        run(SKAction.sequence([SKAction.run({
                self.tonePlayer.volume = 0
                self.tonePlayer.play()
            }),
           SKAction.wait(forDuration: 1/morseUnitPerSecond),
           SKAction.run({
                self.tonePlayer.stop()
                self.tonePlayer.prepareToPlay()
                self.tonePlayer.volume = 1.0
           })])
        )
        
        self.backgroundColor = AppUIDefaults.backgroundBlue
        
        setupLabels()
        
        
        playSentance()
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if backLabel.contains((touches.first?.location(in: self))!) {
            removeAllActions()
            tonePlayer.stop()
            playbackSceneDelegate?.sentanceComplete(completed: false)
        }
        else if skipLabel.contains((touches.first?.location(in: self))!) {
            removeAllActions()
            tonePlayer.stop()
            playbackSceneDelegate?.sentanceComplete(completed: true)
        }
    }
    
    
    // -- MARK: Setup
    
    
    func setupLabels() {
        let edgePadding = CGFloat(20)
        let wordsPerMin = Int((morseUnitPerSecond * 60) / 41)
        wordsPerMinLabel.text = "\(wordsPerMin) wpm"
        wordsPerMinLabel.position = CGPoint(x: frame.maxX - edgePadding, y: frame.minY + edgePadding)
        wordsPerMinLabel.horizontalAlignmentMode = .right
        wordsPerMinLabel.fontName = AppUIDefaults.lightFont
        wordsPerMinLabel.fontSize = AppUIDefaults.normalTextSize
        addChild(wordsPerMinLabel)
        
        textLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        textLabel.horizontalAlignmentMode = .center
        textLabel.text = ""
        textLabel.fontName = AppUIDefaults.lightFont
        textLabel.fontSize = AppUIDefaults.hugeTextSize
        addChild(textLabel)
        
        backLabel.text = "< Back"
        backLabel.position = CGPoint(x: frame.minX + edgePadding, y: frame.maxY - backLabel.frame.height - edgePadding )
        backLabel.horizontalAlignmentMode = .left
        backLabel.fontName = AppUIDefaults.lightFont
        backLabel.fontSize = AppUIDefaults.normalTextSize
        addChild(backLabel)
        
        skipLabel.text = "Skip >"
        skipLabel.position = CGPoint(x: frame.midX, y: frame.midY - (frame.midY - frame.minY)/2 - backLabel.frame.height/2 )
        skipLabel.horizontalAlignmentMode = .center
        skipLabel.fontName = AppUIDefaults.lightFont
        skipLabel.fontSize = AppUIDefaults.normalTextSize
        addChild(skipLabel)

    }

    
    
    // -- MARK: Timeline
    
    
    func playSentance() {
        //let sentance = "andy"
        
        var actions: [SKAction] = []
        let actionPlay = SKAction.run {
            self.tonePlayer.play()
        }
        let actionStop = SKAction.run {
            self.tonePlayer.stop()
            self.tonePlayer.prepareToPlay()
        }
        let actionEndOfSentance = SKAction.run {
            self.playbackSceneDelegate!.sentanceComplete(completed: true)
        }
        let waitOneMorseUnit = SKAction.wait(forDuration: 1/morseUnitPerSecond)
        
        actions.append(SKAction.wait(forDuration: 1))
        
        for letter in sentance.characters {
            let letterLower = String(letter).lowercased()
            if (chars[letterLower] != nil) {
                if true {
                    actions.append(SKAction.run {
                        self.textLabel.text = (self.textLabel.text)! + String(letter)
                    })
                }
                for i in chars[letterLower]! {
                    if i == dit {
                        actions.append(contentsOf: [actionPlay, waitOneMorseUnit, actionStop]) // append wait same length as shape to prevent drawing over it
                    }
                    else if i == dah {
                        actions.append(contentsOf: [actionPlay, waitOneMorseUnit, waitOneMorseUnit, waitOneMorseUnit, actionStop]) // append wait same length as shape to prevent drawing over it
                    }
                    else {
                        actions.append(contentsOf: [waitOneMorseUnit, waitOneMorseUnit, waitOneMorseUnit, waitOneMorseUnit]) // spaces to separate word
                    }
                    // end letter
                    
                    actions.append(waitOneMorseUnit)
                }
            }
            actions.append(waitOneMorseUnit)
            actions.append(waitOneMorseUnit)
        }
        actions.append(SKAction.wait(forDuration: 1))
        actions.append(actionEndOfSentance)
        
        run(SKAction.sequence(actions))
    }


}
