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
    
    
    var ditSprite = MorseCharacter()
    var dahSprite = MorseCharacter()
    
    let dit = MorseCode.dit
    let dah = MorseCode.dah
    
    var chars = MorseCode.charactersArray()
    
    let timeline = SKNode()
    let tapButton = SKSpriteNode()
    let tapButtonInner = SKSpriteNode()
    var tapButtonTappedTexture: SKTexture? = nil
    var tapButtonTexture: SKTexture? = nil
    var wordsPerMinLabel = SKLabelNode()
    var backLabel = SKLabelNode()
    let markerTapZone = SKSpriteNode()
    var continueLabel = SKLabelNode()
    
    var sentance = "morse code"
    var sentanceCharacters = [SentanceCharacter]()
    var showMorseCode = true
    var showLetters = true
    
    var touchDown = false
    var tapStartTime:NSDate!
    var buttonReleaseAction = SKAction()
    
    
    override func didMove(to view: SKView) {
        setupMorseCodeSprites()
        
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
        
        spawnSentance()
        
        setupLabels()
        setupTimeline()
        setupButtons()
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
        else if backLabel.contains((touches.first?.location(in: self))!) {
            timelineSceneDelegate?.sentanceComplete(completed: false)
        }
        else if continueLabel.contains((touches.first?.location(in: self))!) {
            continueFromScore()
        }
    }
    
    
    // -- MARK: Setup
    
    
    func setupButtons() {
        
        // button outer
        var buttonRadius = 150.0
        let circle = SKShapeNode(rect: CGRect(x: 0,
                                              y: 0,
                                              width: buttonRadius,
                                              height: buttonRadius),
                                 cornerRadius: CGFloat(buttonRadius/2))
        
        circle.fillColor = AppUIDefaults.buttonOuterBlue
        circle.lineWidth = 0
        
        tapButton.texture = view?.texture(from: circle)
        tapButton.size = CGSize(width: 150, height: 150)
        tapButton.position = CGPoint(x: (frame.midX - frame.width/4), y: frame.midY - (frame.midY - frame.minY) / 2/3)
        //tapButton.color = AppUIDefaults.buttonOuterBlue
        tapButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(tapButton)
        
        
        // button inner
        buttonRadius -= 10
        let innerCircle = SKShapeNode(rect: CGRect(x: 0,
                                              y: 0,
                                              width: buttonRadius,
                                              height: buttonRadius),
                                 cornerRadius: CGFloat(buttonRadius/2))
        
        innerCircle.fillColor = AppUIDefaults.buttonInnerBlue
        innerCircle.lineWidth = 0
        tapButtonTexture = view?.texture(from: innerCircle) // save to swap in when button released
        
        tapButtonInner.size = tapButton.frame.insetBy(dx: 10, dy: 10).size
        tapButtonInner.texture = tapButtonTexture
        tapButtonInner.position = CGPoint(x: 0, y: 0 )
        tapButtonInner.name = "tapButtonInner"
        tapButtonInner.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tapButton.addChild(tapButtonInner)
        
        
        // button inner alternate texture
        let innerCircleHighlighted = SKShapeNode(rect: CGRect(x: 0,
                                                   y: 0,
                                                   width: buttonRadius,
                                                   height: buttonRadius),
                                      cornerRadius: CGFloat(buttonRadius/2))
        
        innerCircleHighlighted.fillColor = AppUIDefaults.buttonInnerHighlightedBlue
        innerCircleHighlighted.lineWidth = 0
        tapButtonTappedTexture = view?.texture(from: innerCircleHighlighted) // save to swap in when button tapped
    }
    
    func setupLabels() {
        let edgePadding = CGFloat(20)
        let wordsPerMin = Int((morseUnitPerSecond * 60) / 41)
        wordsPerMinLabel.text = "\(wordsPerMin) wpm"
        wordsPerMinLabel.position = CGPoint(x: frame.maxX - edgePadding, y: frame.minY + edgePadding)
        wordsPerMinLabel.horizontalAlignmentMode = .right
        wordsPerMinLabel.fontName = AppUIDefaults.lightFont
        wordsPerMinLabel.fontSize = AppUIDefaults.normalTextSize
        addChild(wordsPerMinLabel)
        
        backLabel.text = "< Back"
        backLabel.position = CGPoint(x: frame.minX + edgePadding, y: frame.maxY - backLabel.frame.height - edgePadding )
        backLabel.horizontalAlignmentMode = .left
        backLabel.fontName = AppUIDefaults.lightFont
        backLabel.fontSize = AppUIDefaults.normalTextSize
        addChild(backLabel)
        
    }
    
    func setupTimeline() {
        
        let marker = SKSpriteNode()
        marker.size = CGSize(width: 6, height: unitDisplaySize*2)
        marker.position = CGPoint(x: (frame.midX - frame.width/4), y: frame.midY + (frame.maxY - frame.midY) / 2)
        marker.color = UIColor(red: 115/255, green: 220/255, blue: 255/255, alpha: 1)
        marker.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(marker)
        
        markerTapZone.size = CGSize(width: unitDisplaySize, height: 25 )
        markerTapZone.position = CGPoint(x: (frame.midX - frame.width/4), y: frame.midY + (frame.maxY - frame.midY) / 2)
        markerTapZone.color = UIColor(red: 115/255, green: 220/255, blue: 255/255, alpha: 0)
        markerTapZone.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(markerTapZone)
        
        addChild(timeline)
    }
    
    func setupMorseCodeSprites() {
        ditSprite = morseCodeSprite(unitsWide: 1)
        dahSprite = morseCodeSprite(unitsWide: 3)
    }
    
    
    // -- MARK: Morse Sprites
    
    
    func morseCodeSprite(unitsWide: Int) -> MorseCharacter {
        let nodeWidth = CGFloat(unitDisplaySize * Double(unitsWide))
        
        var alpha = 1
        if !showMorseCode {
            alpha = 0
        }
        
        let color = UIColor(red: 115/255, green: 220/255, blue: 255/255, alpha: CGFloat(alpha))
        
        let texture = morseCodeSpriteTexture(unitsWide: unitsWide, color: color)
        let sprite = MorseCharacter(texture: texture)
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
    
    
    // -- MARK: Tap Button
    
    
    func tapButtonPressed() {
        tonePlayer.play()
        tapStartTime = NSDate()
        touchDown = true
        tapButtonInner.texture = tapButtonTappedTexture
    }
    
    func tapButtonReleased() {
        let tapDuration = -tapStartTime.timeIntervalSinceNow
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) {_ in 
            self.tonePlayer.stop()
            self.tonePlayer.prepareToPlay()
            self.tapButtonInner.texture = self.tapButtonTexture
        }
        
        if tapDuration <= (1/morseUnitPerSecond)*1.2 {
            _ = userEnteredCorrectly(morse: dit)
        }
        else if tapDuration <= (1/morseUnitPerSecond*3)*1.2 {
            _ = userEnteredCorrectly(morse: dah)
        }
        else {
            // ignore input
        }
        touchDown = false
    }
    
    
    // -- MARK: Timeline
    
    
    func constructSentance() {
        for letter in sentance.characters {
            
            if let sentanceChar = SentanceCharacter(letter: letter)
            {
                // add sprites
                
                for i in sentanceChar.morseRepresentation {
                    if i == dit {
                        sentanceChar.morseSprites.append(ditSprite.copy() as! MorseCharacter)
                    }
                    else if i == dah {
                        sentanceChar.morseSprites.append(dahSprite.copy() as! MorseCharacter)
                    }
                }
                
                // add to sentance array
                
                sentanceCharacters.append(sentanceChar)
            }
        }
    }
    
    
    func spawnSentance() {
        
        constructSentance()
        
        var actions: [SKAction] = []
        let actionEndOfSentance = SKAction.run {
            self.timelineFinished()
        }
        let waitOneMorseUnit = SKAction.wait(forDuration: 1/morseUnitPerSecond)
        
        actions.append(SKAction.wait(forDuration: 1))
        
        for sentanceChar in sentanceCharacters {
            if showLetters {
                actions.append(SKAction.run {
                    self.spawnCharacter(char: sentanceChar.character)
                })
            }
            if sentanceChar.morseSprites.count == 0 { // treat as a space
                actions.append(contentsOf: [waitOneMorseUnit, waitOneMorseUnit, waitOneMorseUnit, waitOneMorseUnit]) // spaces to separate word
            }
            else {
                for sprite in sentanceChar.morseSprites {
                    if sprite.name == dit {
                        actions.append(contentsOf:
                            [
                                SKAction.run {
                                    self.spawnMorseCharacter(sprite: sprite)
                                },
                                waitOneMorseUnit
                            ]) // append wait same length as shape to prevent drawing over it
                    }
                    else if sprite.name == dah {
                        actions.append(contentsOf:
                            [
                                SKAction.run {
                                    self.spawnMorseCharacter(sprite: sprite)
                                },
                                waitOneMorseUnit,
                                waitOneMorseUnit,
                                waitOneMorseUnit
                            ]) // append wait same length as shape to prevent drawing over it
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
    
    
    func spawnMorseCharacter(sprite: MorseCharacter) {
        timeline.addChild(sprite)
        setupTimelineAnimation(sprite: sprite)
    }
    
    func spawnCharacter(char: Character) {
        let letterLabel = SKLabelNode()
        letterLabel.text = String(char).uppercased()
        letterLabel.position = CGPoint(x: (frame.maxX + CGFloat(unitDisplaySize)/2),
                                       y: frame.midY + (frame.maxY - frame.midY) / 2 + CGFloat(unitDisplaySize/2) + 15 + letterLabel.frame.height/2)
        letterLabel.color = UIColor(red: 115/255, green: 220/255, blue: 255/255, alpha: 1)
        letterLabel.horizontalAlignmentMode = .left
        letterLabel.fontName = AppUIDefaults.lightFont
        letterLabel.fontSize = AppUIDefaults.normalTextSize
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
        for node in timeline.children {
            if markerTapZone.intersects(node) {
                let color = UIColor.green
                let node = node as? MorseCharacter
                if node?.name == morse {
                    var unitsWide = 1
                    if node?.name == dah {
                        unitsWide = 3
                    }
                    node?.texture = morseCodeSpriteTexture(unitsWide: unitsWide, color: color)
                    node?.enteredCorrectly = true
                    return true
                }
            }
        }
        
        return false
    }
    
    
    func hideTimeline() {
        removeAllChildren()
    }
    
    
    // -- MARK: Finish
    
    func timelineFinished() {
        hideTimeline()
        displayScore()
    }
    
    func displayScore() {
        var sentanceCharsCorrect = 0
        var sentanceCharsIncorrect = 0
        var morseCharsCorrect = 0
        var morseCharsIncorrect = 0
        
        for sentanceChar in sentanceCharacters
        {
            if let success = sentanceChar.enteredCorrectly() {
                if success
                {
                    sentanceCharsCorrect += 1
                }
                else
                {
                    sentanceCharsIncorrect += 1
                }
            }
            
            for node in sentanceChar.morseSprites {
                 if node.enteredCorrectly
                 {
                     morseCharsCorrect += 1
                 }
                 else
                 {
                     morseCharsIncorrect += 1
                 }
            }
        }
        
        let sentanceCharsPercentage = Int(round(Double(sentanceCharsCorrect) / Double(sentanceCharsCorrect + sentanceCharsIncorrect) * 100.0))
        let morseCharsPercentage = Int(round(Double(morseCharsCorrect) / Double(morseCharsCorrect + morseCharsIncorrect) * 100.0))
        
        let spacing: CGFloat = 15.0
        
        let label = SKLabelNode()
        label.horizontalAlignmentMode = .center
        label.fontName = AppUIDefaults.lightFont
        label.fontSize = AppUIDefaults.normalTextSize
        
        let sentanceCharsCorrectLabel = label.copy() as! SKLabelNode
        sentanceCharsCorrectLabel.position = CGPoint(x: frame.midX,
                                                     y: frame.midY + label.fontSize*2 + spacing)
        sentanceCharsCorrectLabel.text = "Correct letters: \(sentanceCharsCorrect)"
        addChild(sentanceCharsCorrectLabel)
        
        let sentanceCharsIncorrectLabel = label.copy() as! SKLabelNode
        sentanceCharsIncorrectLabel.position = CGPoint(x: frame.midX,
                                                       y: sentanceCharsCorrectLabel.position.y - label.fontSize - spacing)
        sentanceCharsIncorrectLabel.text = "Incorrect letters: \(sentanceCharsIncorrect)"
        addChild(sentanceCharsIncorrectLabel)
        
        let sentanceCharsScoreLabel = label.copy() as! SKLabelNode
        sentanceCharsScoreLabel.position = CGPoint(x: frame.midX,
                                                   y: sentanceCharsIncorrectLabel.position.y - label.fontSize - spacing)
        sentanceCharsScoreLabel.text = "Letters: \(sentanceCharsPercentage)%"
        addChild(sentanceCharsScoreLabel)
        
        let morseCharsScoreLabel = label.copy() as! SKLabelNode
        morseCharsScoreLabel.position = CGPoint(x: frame.midX,
                                                   y: sentanceCharsScoreLabel.position.y - label.fontSize - spacing)
        morseCharsScoreLabel.text = "Morse units: \(morseCharsPercentage)%"
        addChild(morseCharsScoreLabel)
        
        
        continueLabel = label.copy() as! SKLabelNode
        continueLabel.fontName = AppUIDefaults.boldFont
        continueLabel.fontSize = AppUIDefaults.largeTextSize
        continueLabel.position = CGPoint(x: frame.midX,
                                         y: morseCharsScoreLabel.position.y - label.fontSize - spacing*4)
        continueLabel.text = "Continue"
        addChild(continueLabel)
        
    }
    
    
    func continueFromScore() {
        timelineSceneDelegate!.sentanceComplete(completed: true)
    }
}
