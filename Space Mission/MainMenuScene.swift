//
//  MainMenuScene.swift
//  Space Mission
//
//  Created by 90304588 on 2/19/22.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene{
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.zPosition = 0
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(background)
        
        let gameBy = SKLabelNode(fontNamed: "SFDistantGalaxy")
        gameBy.fontSize = 50
        gameBy.fontColor = SKColor.white
        gameBy.text = "Cole Nelson's"
        gameBy.zPosition = 1
        gameBy.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.70)
        self.addChild(gameBy)
        
        let title1 = SKLabelNode(fontNamed: "SFDistantGalaxy")
        title1.fontSize = 150
        title1.fontColor = SKColor.white
        title1.text = "Incoming"
        title1.zPosition = 1
        title1.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.65)
        self.addChild(title1)
        
        let startGame = SKLabelNode(fontNamed: "SFDistantGalaxy")
        startGame.fontSize = 75
        startGame.fontColor = SKColor.white
        startGame.text = "Start Game"
        startGame.zPosition = 1
        startGame.name = "Start Button"
        startGame.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.4)
        self.addChild(startGame)
        
        let playerSelect = SKLabelNode(fontNamed: "SFDistantGalaxy")
        playerSelect.fontSize = 75
        playerSelect.fontColor = SKColor.white
        playerSelect.text = "Select Player"
        playerSelect.zPosition = 1
        playerSelect.name = "Player Select"
        playerSelect.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.35)
        self.addChild(playerSelect)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            if nodeITapped.name == "Start Button"{
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            if nodeITapped.name == "Player Select"{
                let sceneToMoveTo = PlayerSelectScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.crossFade(withDuration: 1)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
        }
        
        
        
    }
}
