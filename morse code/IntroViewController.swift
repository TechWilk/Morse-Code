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
    
    @IBAction func goButton(_ sender: Any) {
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TimelineViewController") as! GameViewController? {
            viewController.text = sentanceTextBox.text!
            
            navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
}
