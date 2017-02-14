//
//  PlaybackViewController.swift
//  morse code
//
//  Created by Christopher Wilkinson on 30/01/2017.
//  Copyright © 2017 Christopher Wilkinson. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class PlaybackViewController: UIViewController, PlaybackSceneDelegate {
    
    struct Storyboard {
        static let timelineSegue = "timeline"
    }
    
    var text = "morse code"
    var wordsPerMin = 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'PlaybackScene.sks'
            if let scene = PlaybackScene(fileNamed: "PlaybackScene") {
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                scene.sentance = text
                scene.morseUnitPerSecond = (wordsPerMin*41)/60
                scene.playbackSceneDelegate = self
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    func sentanceComplete(completed: Bool) {
        if completed {
            performSegue(withIdentifier: Storyboard.timelineSegue, sender: nil)
        }
        else
        {
            _ = navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.timelineSegue {
            let destination = segue.destination as! TimelineViewController
            destination.text = self.text
            destination.wordsPerMin = self.wordsPerMin
        }
    }
}
