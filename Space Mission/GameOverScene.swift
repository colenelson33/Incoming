//
//  GameOverScene.swift
//  Space Mission
//
//  Created by 90304588 on 2/18/22.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    let mainMenuLabel = SKLabelNode(fontNamed: "SFDistantGalaxy")
    let restartLabel = SKLabelNode(fontNamed: "SFDistantGalaxy")
    override func didMove(to view: SKView) {
        
        
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        background.size = self.size
        self.addChild(background)
        
        mainMenuLabel.text = "Home"
        mainMenuLabel.fontSize = 50
        mainMenuLabel.position = CGPoint(x: self.size.width * 0.3,y: self.size.height * 0.9)
        //mainMenuLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        mainMenuLabel.zPosition = 100
        mainMenuLabel.fontColor = SKColor.white
        self.addChild(mainMenuLabel)
        
        
        
        let gameOverLabel = SKLabelNode(fontNamed: "SFDistantGalaxy")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 125
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "SFDistantGalaxy")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 100
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highScoreNum = defaults.integer(forKey: "highScoreSaved")
        if gameScore > highScoreNum {
            highScoreNum = gameScore
            defaults.set(highScoreNum, forKey: "highScoreSaved")
        }
        
    
        let highScoreLabel = SKLabelNode(fontNamed: "SFDistantGalaxy")
        highScoreLabel.fontSize = 100
        highScoreLabel.text = "High Score: \(highScoreNum)"
        highScoreLabel.zPosition = 1
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.45)
        self.addChild(highScoreLabel)
        
        let accuracyLabel = SKLabelNode(fontNamed: "SFDistantGalaxy")
        accuracyLabel.fontSize = 30
        accuracyLabel.text = "Poor accuracy, hit your shots!"
        accuracyLabel.zPosition = 1
        accuracyLabel.fontColor = SKColor.white
        accuracyLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.1)
        self.addChild(accuracyLabel)
        
        
        restartLabel.fontSize = 100
        restartLabel.text = "Play Again"
        restartLabel.zPosition = 1
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.3)
        self.addChild(restartLabel)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let transition1 = SKTransition.fade(withDuration: 0.5)
            if restartLabel.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                self.view!.presentScene(sceneToMoveTo, transition: transition1)
                
            }
            if mainMenuLabel.contains(pointOfTouch){
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                self.view!.presentScene(sceneToMoveTo, transition: transition1)
            }
            
            
        }
        
    }
}
