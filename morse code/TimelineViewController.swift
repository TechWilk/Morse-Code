//
//  TimelineViewController.swift
//  morse code
//
//  Created by Christopher Wilkinson on 09/01/2017.
//  Copyright © 2017 Christopher Wilkinson. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class TimelineViewController: UIViewController, TimelineSceneDelegate {
    
    var text = "morse code"
    var showMorseCode = true
    var wordsPerMin = 5.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'TimelineScene.sks'
            if let scene = TimelineScene(fileNamed: "TimelineScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                scene.sentance = text
                scene.showMorseCode = showMorseCode
                scene.morseWordsPerMin = wordsPerMin
                scene.farnsworthWordsPerMin = wordsPerMin
                scene.timelineSceneDelegate = self
                
                // Present the scene
                view.presentScene(scene)
            }
                        
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func sentanceComplete(completed: Bool) {
        _ = navigationController?.popViewController(animated: true)
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
