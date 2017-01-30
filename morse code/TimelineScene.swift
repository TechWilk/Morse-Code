//
//  TimelineScene.swift
//  morse code
//
//  Created by Christopher Wilkinson on 09/01/2017.
//  Copyright © 2017 Christopher Wilkinson. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation


protocol TimelineSceneDelegate {
    func sentanceComplete(completed: Bool)
}


class TimelineScene: SKScene {
    
    var timelineSceneDelegate: TimelineSceneDelegate?
    
    var tonePlayer = AVAudioPlayer()
    
    var morseUnitPerSecond = (10.0*41)/60 // length of a dit / space per second
    let unitDisplaySize = 50.0
    
    
    var ditSprite = SKSpriteNode()
    var dahSprite = SKSpriteNode()
    
    let dit = "•"
    let dah = "-"
    
    var chars = [String: Array<String>]()
    
    let timeline = SKSpriteNode()
    let tapButton = SKSpriteNode()
    var wordsPerMinLabel = SKLabelNode()
    var timeLabel = SKLabelNode()
    let markerTapZone = SKSpriteNode()
    
    var sentance = "morse code"
    var showMorseCode = true
    var showLetters = true
    
    var touchDown = false
    var tapStartTime:NSDate!
    var buttonReleaseAction = SKAction()
    
    
    override func didMove(to view: SKView) {
        setupCharactersArray()
        setupMorseCodeSprites()
        
        let toneFilePath = Bundle.main.path(forResource: "1kHz_tone", ofType: "wav")
        let toneFileUrl = NSURL(fileURLWithPath: toneFilePath!)
        _ = try? tonePlayer = AVAudioPlayer(contentsOf: toneFileUrl as URL)
        tonePlayer.numberOfLoops = -1 // loop indefinitley
        tonePlayer.prepareToPlay()
        
        // play dit tone to give user a sense of the speed
        // (plus as a work-around to bug in AVAudioPlayer where first-time playing of looped audio stutters!)
        run(SKAction.sequence([SKAction.run({
                self.tonePlayer.play()
            }),
            SKAction.wait(forDuration: 1/morseUnitPerSecond),
            SKAction.run({
                self.tonePlayer.stop()
                self.tonePlayer.prepareToPlay()
            })]))
        tonePlayer.play()
        
        
        self.backgroundColor = SKColor(red: 60/255, green: 173/255, blue: 237/255, alpha: 1)
        
        setupButtons()
        setupLabels()
        setupTimeline()
        
        
        spawnSentance()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !touchDown {
            if tapButton.frame.contains((touches.first?.location(in: self))!) {
                tapButtonPressed()
                return
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchDown {
            if touches.count == 1 {
                tapButtonReleased()
                return
            }
        }
    }
    
    
    /* ~~~~~~~~~~~ SETUP ~~~~~~~~~~ */
    
    
    func setupButtons() {
        tapButton.size = CGSize(width: 150, height: 150)
        tapButton.position = CGPoint(x: (frame.midX - frame.width/4), y: frame.midY - (frame.midY - frame.minY) / 2/3)
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
        let edgePadding = CGFloat(20)
        let wordsPerMin = Int((morseUnitPerSecond * 60) / 41)
        wordsPerMinLabel.text = "\(wordsPerMin) wpm"
        wordsPerMinLabel.position = CGPoint(x: frame.maxX - edgePadding, y: frame.minY + edgePadding)
        wordsPerMinLabel.horizontalAlignmentMode = .right
        addChild(wordsPerMinLabel)
        
        timeLabel.text = "time"
        timeLabel.position = CGPoint(x: frame.maxX - edgePadding, y: (frame.minY + 10 + wordsPerMinLabel.fontSize + edgePadding) )
        timeLabel.horizontalAlignmentMode = .right
        addChild(timeLabel)
        
    }
    
    func setupTimeline() {
        
        timeline.size = frame.size
        
        let marker = SKSpriteNode()
        marker.size = CGSize(width: 2, height: unitDisplaySize*2)
        marker.position = CGPoint(x: (frame.midX - frame.width/4), y: frame.midY + (frame.maxY - frame.midY) / 2)
        marker.color = UIColor(red: 115/255, green: 220/255, blue: 255/255, alpha: 1)
        marker.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(marker)
        
        markerTapZone.size = CGSize(width: unitDisplaySize, height: 25 )
        markerTapZone.position = CGPoint(x: (frame.midX - frame.width/4), y: frame.midY + (frame.maxY - frame.midY) / 2)
        markerTapZone.color = UIColor(red: 115/255, green: 220/255, blue: 255/255, alpha: 0)
        markerTapZone.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(markerTapZone)
    }
    
    func setupCharactersArray() {
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
            
            " ": [],
        ]
    }
    
    func setupMorseCodeSprites() {
        ditSprite = morseCodeSprite(unitsWide: 1)
        dahSprite = morseCodeSprite(unitsWide: 3)
    }
    
    func morseCodeSprite(unitsWide: Int) -> SKSpriteNode {
        let nodeWidth = CGFloat(unitDisplaySize * Double(unitsWide))
        
        var alpha = 1
        if !showMorseCode {
            alpha = 0
        }
        
        let color = UIColor(red: 115/255, green: 220/255, blue: 255/255, alpha: CGFloat(alpha))
        
        let texture = morseCodeSpriteTexture(unitsWide: unitsWide, color: color)
        let sprite = SKSpriteNode(texture: texture)
        sprite.size = CGSize(width: nodeWidth, height: CGFloat(unitDisplaySize))
        sprite.position = CGPoint(x: (frame.maxX + nodeWidth/2), y: frame.midY + (frame.maxY - frame.midY) / 2)
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        if unitsWide == 1 {
            sprite.name = dit
        }
        if unitsWide == 3 {
            sprite.name = dah
        }
        
        return sprite
    }
    
    func morseCodeSpriteTexture(unitsWide: Int, color: UIColor) -> SKTexture {
        let nodeWidth = CGFloat(unitDisplaySize * Double(unitsWide))
        let circle = SKShapeNode(rect: CGRect(x: frame.maxX + nodeWidth/2,
        y: frame.midY + (frame.maxY - frame.midY) / 2,
        width: nodeWidth,
        height: CGFloat(unitDisplaySize)),
        cornerRadius: CGFloat(unitDisplaySize/2))

        circle.fillColor = color
        circle.lineWidth = 0
        
        return (view?.texture(from: circle))!
    }
    
    
    /* ~~~~~~~~~~~ TAP BUTTON ~~~~~~~~~~ */
    
    
    func tapButtonPressed() {
        tonePlayer.play()
        tapStartTime = NSDate()
        touchDown = true
        (tapButton.childNode(withName: "tapButtonInner") as! SKSpriteNode).color = UIColor(red: 160/255, green: 225/255, blue: 255/255, alpha: 1)
    }
    
    func tapButtonReleased() {
        let tapDuration = -tapStartTime.timeIntervalSinceNow
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) {_ in 
            self.tonePlayer.stop()
            self.tonePlayer.prepareToPlay()
            (self.tapButton.childNode(withName: "tapButtonInner") as! SKSpriteNode).color = UIColor(red: 194/255, green: 234/255, blue: 255/255, alpha: 1)
        }
        
        if tapDuration <= (1/morseUnitPerSecond)*1.2 {
            timeLabel.text = "Dit"
            _ = userEnteredCorrectly(morse: dit)
        }
        else if tapDuration <= (1/morseUnitPerSecond*3)*1.2 {
            timeLabel.text = "Dah"
            _ = userEnteredCorrectly(morse: dah)
        }
        else {
            timeLabel.text = "N/A"
        }
        touchDown = false
    }
    
    
    /* ~~~~~~~~~~~ TIMELINE ~~~~~~~~~~ */
    
    
    func spawnSentance() {
        //let sentance = "andy"
        
        var actions: [SKAction] = []
        let actionSpawnDit = SKAction.run {
            self.spawnDit()
        }
        let actionSpawnDah = SKAction.run {
            self.spawnDah()
        }
        let actionEndOfSentance = SKAction.run {
            self.timelineSceneDelegate!.sentanceComplete(completed: true)
        }
        let waitOneMorseUnit = SKAction.wait(forDuration: 1/morseUnitPerSecond)
        
        actions.append(SKAction.wait(forDuration: 1))
        
        for letter in sentance.characters {
            let letterLower = String(letter).lowercased()
            if (chars[letterLower] != nil) {
                if showLetters {
                    actions.append(SKAction.run {
                        self.spawnCharacter(char: letter)
                    })
                }
                for i in chars[letterLower]! {
                    if i == dit {
                        actions.append(contentsOf: [actionSpawnDit, waitOneMorseUnit]) // append wait same length as shape to prevent drawing over it
                    }
                    else if i == dah {
                        actions.append(contentsOf: [actionSpawnDah, waitOneMorseUnit, waitOneMorseUnit, waitOneMorseUnit]) // append wait same length as shape to prevent drawing over it
                    }
                    else {
                        actions.append(contentsOf: [waitOneMorseUnit, waitOneMorseUnit, waitOneMorseUnit, waitOneMorseUnit]) // spaces to separate word
                    }
                    actions.append(waitOneMorseUnit)
                }
            }
            actions.append(waitOneMorseUnit)
            actions.append(waitOneMorseUnit)
        }
        let distanceInUnits = (frame.maxX - frame.minX + CGFloat(unitDisplaySize*3)) / CGFloat(unitDisplaySize)
        let dahAnimationDuration = CGFloat(1/morseUnitPerSecond) * distanceInUnits
        actions.append(SKAction.wait(forDuration: TimeInterval (dahAnimationDuration)))
        actions.append(SKAction.wait(forDuration: 1)) // pause before finishing
        actions.append(actionEndOfSentance)
        
        run(SKAction.sequence(actions))
    }
    
    
    func spawnDit() {
        let sprite = ditSprite.copy() as! SKSpriteNode
        addChild(sprite)
        setupTimelineAnimation(sprite: sprite)
    }
    
    func spawnDah() {
        let sprite = dahSprite.copy() as! SKSpriteNode
        addChild(sprite)
        setupTimelineAnimation(sprite: sprite)
    }
    
    func spawnCharacter(char: Character) {
        let letterLabel = SKLabelNode()
        letterLabel.text = String(char).uppercased()
        letterLabel.position = CGPoint(x: (frame.maxX + CGFloat(unitDisplaySize)/2),
                                       y: frame.midY + (frame.maxY - frame.midY) / 2 + CGFloat(unitDisplaySize/2) + 15 + letterLabel.frame.height/2)
        letterLabel.color = UIColor(red: 115/255, green: 220/255, blue: 255/255, alpha: 1)
        letterLabel.horizontalAlignmentMode = .left
        addChild(letterLabel)
        
        setupTimelineAnimation(label: letterLabel)
    }
    
    func setupTimelineAnimation(sprite: SKSpriteNode) {
        let move = SKAction.moveTo(x: frame.minX-sprite.size.width/2, duration: TimeInterval(timelineAnimationDuration(width: sprite.size.width)))
        sprite.run(SKAction.sequence([move, SKAction.removeFromParent()]))
    }
    
    
    func setupTimelineAnimation(label: SKLabelNode) {
        let move = SKAction.moveTo(x: frame.minX-label.frame.width/2, duration: TimeInterval(timelineAnimationDuration(width: label.frame.width)))
        label.run(SKAction.sequence([move, SKAction.removeFromParent()]))
    }
    
    
    func timelineAnimationDuration(width: CGFloat) -> CGFloat {
        let distanceInUnits = (frame.maxX - frame.minX + width) / CGFloat(unitDisplaySize)
        return CGFloat(1/morseUnitPerSecond) * distanceInUnits
    }
    
    
    func userEnteredCorrectly(morse: String) -> Bool {
        if morse != dit && morse != dah {
            return false
        }
        for node in self.children {
            if markerTapZone.intersects(node) && (node.name == dit || node.name == dah) {
                let color = UIColor.green
                let node = node as? SKSpriteNode
                if node?.name == morse {
                    var unitsWide = 1
                    if node?.name == dah {
                        unitsWide = 3
                    }
                    node?.texture = morseCodeSpriteTexture(unitsWide: unitsWide, color: color)
                    timeLabel.text = "Success"
                    return true
                }
            }
        }
        
        return false
    }
}
