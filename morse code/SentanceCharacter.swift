//
//  SentanceCharacter.swift
//  morse code
//
//  Created by Christopher Wilkinson on 11/02/2017.
//  Copyright © 2017 Christopher Wilkinson. All rights reserved.
//

import UIKit

class SentanceCharacter {
    
    var morseSprites = [MorseCharacter]()
    
    var morseRepresentation  = [String]()
    var character: Character = "a"
    
    //private var morseCharacters = [MorseCharacter]()
    
    init?(letter: Character) {
        
        let letterLower = String(letter).lowercased()
        
        if let characterMorse = MorseCode.charactersArray()[letterLower]
        {
            morseRepresentation = characterMorse
            character = Character(letterLower)
            
            // MorseCharacters are added to self.morseSprites in the SKScene, since a view is required to texture them
        }
        else
        {
            return nil
        }
    }
    
    func enteredCorrectly() -> Bool? {
        if morseSprites.count > 0 {
            
            for sprite in morseSprites {
                if !sprite.enteredCorrectly {
                    return false
                }
            }
            
            return true
        }
        
        return nil
    }
}
