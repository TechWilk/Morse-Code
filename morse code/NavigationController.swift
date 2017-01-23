//
//  NavigationController.swift
//  morse code
//
//  Created by Christopher Wilkinson on 16/01/2017.
//  Copyright © 2017 Christopher Wilkinson. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override var shouldAutorotate: Bool {
        if let visibleViewController = self.visibleViewController {
            return visibleViewController.shouldAutorotate
        }
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
