//
//  GameScene.swift
//  Game-Starter-Empty
//
//  Created by Jonathan Kopp on 9/29/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameSpeed: CGFloat!
    
    //Initialize score starting at 0
    var score = 0 {
        didSet {
            if score < 0 {
                score = 0
                scoreLabel.text = String(score)
            } else {
                scoreLabel.text = String(score)
            }
        }
    }
    
    //Set up properties of the scoreLabel
    var scoreLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.text = "0"
        label.color = .white
        label.fontSize = 50
        
        return label
    }()
    
    override func didMove(to view: SKView) {
        //Called when the scene has been displayed
        
        createSquares(name: "one")
        createSquares(name: "two")
        createSquares(name: "three")
        
        //Setup the scoreLabel
        labelSetUp()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func labelSetUp() {
        scoreLabel.position.x = view!.bounds.width / 2
        scoreLabel.position.y = view!.bounds.height - 80
        addChild(scoreLabel)
    }
    
    func randomNumber()-> CGFloat {
        //Width of the SKScene's view
        let viewsWidth = self.view!.bounds.width
        //Creates a random number from 0 to the viewsWidth
        let randomNumber = CGFloat.random(in: 40 ... viewsWidth - 40)
        
        return randomNumber
    }
    
    func createSquares(name: String) {
        if score < 50 {
            gameSpeed = 6
        } else if score < 100 {
            gameSpeed = 8
        } else {
            gameSpeed = 11
        }
        
        var randomColor: UIColor {
            let hue : CGFloat = CGFloat(arc4random() % 256) / 256
            let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
            let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
                        
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        }
        
        let screenHeight: CGFloat = view!.bounds.height
        let size = CGSize(width: 80, height: 80)
        let square = SKSpriteNode(texture: nil, color: randomColor, size: size)
        square.name = name
        square.position.y = 40
        square.position.x = randomNumber()
        
        //Create an action to move the square up the screen
        let action = SKAction.customAction(withDuration: 2.0, actionBlock: { (square, _) in
            square.position.y += self.gameSpeed
            if square.position.y >= screenHeight {
                square.removeFromParent()
                self.score -= 1
                self.createSquares(name: name)
            }
        })
        
        square.run(SKAction.repeatForever(action))
        addChild(square)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let positionInScene = touch.location(in: self)
            
            let name = self.atPoint(positionInScene).name
            
            if name != nil {
                let square = self.atPoint(positionInScene)
                square.removeFromParent()
                score += 1
                createSquares(name: name!)
            }
        }
    }
    
}
