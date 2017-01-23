//
//  MorseCharacter.swift
//  morse code
//
//  Created by Christopher Wilkinson on 23/01/2017.
//  Copyright © 2017 Christopher Wilkinson. All rights reserved.
//

import SpriteKit

class MorseCharacter: SKSpriteNode {
    
    private(set) var unitsWide = 1
    private(set) var unitDisplaySize = 50.0
    
    override var color: UIColor {
        didSet {
            self.texture = texture(color: self.color)
        }
    }
    
    
    init(unitDisplaySize: Double, unitsWide: Int, name: String, color: UIColor) {
        
        self.unitsWide = unitsWide
        self.unitDisplaySize = unitDisplaySize
        
        let nodeWidth = CGFloat(unitDisplaySize * Double(unitsWide))
        
        self.color = color
        self.size = CGSize(width: nodeWidth, height: CGFloat(unitDisplaySize))
        self.position = CGPoint(x: (frame.maxX + nodeWidth/2), y: frame.midY + (frame.maxY - frame.midY) / 2)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.name = name
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func texture(color: UIColor) -> SKTexture? {
        let nodeWidth = CGFloat(unitDisplaySize * Double(unitsWide))
        let circle = SKShapeNode(rect: CGRect(x: frame.maxX + nodeWidth/2,
                                              y: frame.midY + (frame.maxY - frame.midY) / 2,
                                              width: nodeWidth,
                                              height: CGFloat(unitDisplaySize)),
                                 cornerRadius: CGFloat(unitDisplaySize/2))
        
        circle.lineWidth = 0
        circle.fillColor = color
        
        return SKView.texture(from: circle) // need instance of SKView to create SKTexture from SKShapeNode
    }

}
