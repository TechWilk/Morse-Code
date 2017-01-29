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
    
    
    init(unitDisplaySize: Double, unitsWide: Int, name: String, color: UIColor, view: SKView) {
        
        let texture = self.texture(color: color, view: view)
        
        super.init(texture: texture, color: .clear, size: texture!.size())
        
        self.unitsWide = unitsWide
        self.unitDisplaySize = unitDisplaySize
        
        let nodeWidth = CGFloat(unitDisplaySize * Double(unitsWide))
        
        self.color = color
        self.size = CGSize(width: nodeWidth, height: CGFloat(unitDisplaySize))
        self.position = CGPoint(x: (frame.maxX + nodeWidth/2), y: frame.midY + (frame.maxY - frame.midY) / 2)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func texture(color: UIColor, view: SKView) -> SKTexture? {
        let nodeWidth = CGFloat(unitDisplaySize * Double(unitsWide))
        let circle = SKShapeNode(rect: CGRect(x: frame.maxX + nodeWidth/2,
                                              y: frame.midY + (frame.maxY - frame.midY) / 2,
                                              width: nodeWidth,
                                              height: CGFloat(unitDisplaySize)),
                                 cornerRadius: CGFloat(unitDisplaySize/2))
        
        circle.lineWidth = 0
        circle.fillColor = color
        
        return view.texture(from: circle) // need instance of SKView to create SKTexture from SKShapeNode
    }
    
    func changeColor(color: UIColor, view: SKView) {
        self.color = color
        self.texture = texture(color: color, view: view)
    }

}
