//
//  IntroViewController.swift
//  morse code
//
//  Created by Christopher Wilkinson on 13/01/2017.
//  Copyright © 2017 Christopher Wilkinson. All rights reserved.
//

import UIKit

class IntroViewController : UIViewController, UITextFieldDelegate {
    
    struct Storyboard {
        static let playbackSeque = "playback"
        static let timelineSegue = "timeline"
    }
    
    @IBOutlet weak var sentanceTextBox: UITextField!
    @IBOutlet weak var playbackBeforeTimelineSwitch: UISwitch!
    @IBOutlet weak var wordsPerMinSegmentControl: UISegmentedControl!
    
    @IBAction func goButton(_ sender: Any) {
        let text = sentanceTextBox.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if text != "" {
            let defaults = UserDefaults.standard
            defaults.set(wordsPerMinSegmentControl.selectedSegmentIndex, forKey: "wordsPerMinIndex")
            defaults.set(playbackBeforeTimelineSwitch.isOn, forKey: "playbackBeforeTimeline")
            
            if playbackBeforeTimelineSwitch.isOn {
                performSegue(withIdentifier: Storyboard.playbackSeque, sender: nil)
            }
            else {
                performSegue(withIdentifier: Storyboard.timelineSegue, sender: nil)
            }
        }
        else {
            sentanceTextBox.becomeFirstResponder()
        }
    }
    
    
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        let defaults = UserDefaults.standard
        wordsPerMinSegmentControl.selectedSegmentIndex = defaults.integer(forKey: "wordsPerMinIndex")
        playbackBeforeTimelineSwitch.isOn = defaults.bool(forKey: "playbackBeforeTimeline")
        
        sentanceTextBox.becomeFirstResponder()
        sentanceTextBox.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        goButton(sentanceTextBox)
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let text = sentanceTextBox.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        var wordsPerMin = 0.0
        switch wordsPerMinSegmentControl.selectedSegmentIndex {
        case 0:
            wordsPerMin = 5.0
        case 1:
            wordsPerMin = 10.0
        case 2:
            wordsPerMin = 15.0
        case 3:
            wordsPerMin = 20.0
        case 4:
            wordsPerMin = 25.0
        default:
            wordsPerMin = 5.0
        }
        
        if segue.identifier == Storyboard.playbackSeque {
            let destination = segue.destination as! PlaybackViewController
            destination.text = text
            destination.wordsPerMin = wordsPerMin
            
        }
        
        if segue.identifier == Storyboard.timelineSegue {
            let destination = segue.destination as! TimelineViewController
            destination.text = text
            destination.wordsPerMin = wordsPerMin
            
        }

        
    }
    
}
