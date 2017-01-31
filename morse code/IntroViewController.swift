//
//  IntroViewController.swift
//  morse code
//
//  Created by Christopher Wilkinson on 13/01/2017.
//  Copyright © 2017 Christopher Wilkinson. All rights reserved.
//

import UIKit

class IntroViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var sentanceTextBox: UITextField!
    @IBOutlet weak var showMorseCodeSwitch: UISwitch!
    @IBOutlet weak var wordsPerMinSegmentControl: UISegmentedControl!
    
    @IBAction func goButton(_ sender: Any) {
        let text = sentanceTextBox.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if text != "" {
            let defaults = UserDefaults.standard
            defaults.set(wordsPerMinSegmentControl.selectedSegmentIndex, forKey: "wordsPerMinIndex")
            defaults.set(showMorseCodeSwitch.isOn, forKey: "showMorseCode")
            
            if showMorseCodeSwitch.isOn {
                performSegue(withIdentifier: "playback", sender: nil)
            }
            else {
                performSegue(withIdentifier: "timeline", sender: nil)
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
        showMorseCodeSwitch.isOn = defaults.bool(forKey: "showMorseCode")
        
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
        
        if segue.identifier == "playback" {
            let destination = segue.destination as! PlaybackViewController
            destination.text = text
            
            switch wordsPerMinSegmentControl.selectedSegmentIndex {
            case 0:
                destination.wordsPerMin = 5.0
            case 1:
                destination.wordsPerMin = 10.0
            case 2:
                destination.wordsPerMin = 15.0
            case 3:
                destination.wordsPerMin = 20.0
            case 4:
                destination.wordsPerMin = 25.0
            default:
                destination.wordsPerMin = 5.0
            }
            
        }
        if segue.identifier == "timeline" {
            let destination = segue.destination as! TimelineViewController
            destination.text = text
            
            switch wordsPerMinSegmentControl.selectedSegmentIndex {
            case 0:
                destination.wordsPerMin = 5.0
            case 1:
                destination.wordsPerMin = 10.0
            case 2:
                destination.wordsPerMin = 15.0
            case 3:
                destination.wordsPerMin = 20.0
            case 4:
                destination.wordsPerMin = 25.0
            default:
                destination.wordsPerMin = 5.0
            }
            
        }

        
    }
    
}
