//
//  AppUIDefaults.swift
//  morse code
//
//  Created by Christopher Wilkinson on 14/02/2017.
//  Copyright © 2017 Christopher Wilkinson. All rights reserved.
//

//import UIKit
import SpriteKit

class AppUIDefaults {
    
    static let lightFont = UIFont.systemFont(ofSize: 10.0).fontName
    static let boldFont = UIFont.boldSystemFont(ofSize: 45.0).fontName
    
    static let normalTextSize: CGFloat = 30.0
    static let largeTextSize: CGFloat = 40.0
    static let hugeTextSize: CGFloat = 50.0
    
    static let backgroundBlue = SKColor(red: 60/255, green: 173/255, blue: 237/255, alpha: 1)
    
    static let buttonInnerBlue = UIColor(red: 194/255, green: 234/255, blue: 255/255, alpha: 1)
    static let buttonInnerHighlightedBlue = UIColor(red: 160/255, green: 225/255, blue: 255/255, alpha: 1)
    static let buttonOuterBlue = UIColor(red: 115/255, green: 220/255, blue: 255/255, alpha: 1)
}
