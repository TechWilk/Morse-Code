//
//  IntroViewController.swift
//  morse code
//
//  Created by Christopher Wilkinson on 13/01/2017.
//  Copyright © 2017 Christopher Wilkinson. All rights reserved.
//

import UIKit

class IntroViewController : UIViewController {
    
    @IBOutlet weak var sentanceTextBox: UITextField!
    @IBOutlet weak var showLettersSwitch: UISwitch!
    @IBOutlet weak var wordsPerMinSegmentControl: UISegmentedControl!
    
    @IBAction func goButton(_ sender: Any) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TimelineViewController") as! GameViewController? {
            let text = sentanceTextBox.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if text != "" {
                viewController.text = text
                viewController.showLetters = showLettersSwitch.isOn
                
                switch wordsPerMinSegmentControl.selectedSegmentIndex {
                case 0:
                    viewController.wordsPerMin = 5.0
                case 1:
                    viewController.wordsPerMin = 10.0
                case 2:
                    viewController.wordsPerMin = 15.0
                case 3:
                    viewController.wordsPerMin = 20.0
                case 4:
                    viewController.wordsPerMin = 25.0
                default:
                    viewController.wordsPerMin = 5.0
                }
                
                navigationController?.pushViewController(viewController, animated: true)
            }
            else {
                // error message
            }
        }
    }
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}
