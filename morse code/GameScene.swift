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
    
    
    let dit = CGRect(x: 100.0, y: 100.0, width: 100.0, height: 10.0)
    let dah = CGRect(x: 100.0, y: 100.0, width: 10.0, height: 10.0)
    
    var chars = [String: Array<Any>]()
    
    
    
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
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tonePlayer.play()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tonePlayer.stop()
    }
}
