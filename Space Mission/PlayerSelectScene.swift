//
//  PlayerSelectScene.swift
//  Space Mission
//
//  Created by 90304588 on 2/19/22.
//

import Foundation
import SpriteKit

var characterSelected = "ca"
var currentIndex = 0

class Character{
    
    var playerSprite: String
    var weaponSprite: String
    var soundEffect: String
    
    init(playerSprite: String, weaponSprite: String, soundEffect: String){
        self.playerSprite = playerSprite
        self.weaponSprite = weaponSprite
        self.soundEffect = soundEffect
    }
    
}

let pinkShip = Character(playerSprite: "ca", weaponSprite: "shield", soundEffect: "blasterSound")
let blueShip = Character(playerSprite: "blueShip", weaponSprite: "greenShield", soundEffect: "blasterSound")
let whiteShip = Character(playerSprite: "whiteShip", weaponSprite: "shield", soundEffect: "blasterSound")

let playerList = [pinkShip, blueShip, whiteShip]



class PlayerSelectScene: SKScene{
    
    
    let playGameLabel = SKLabelNode(fontNamed: "SFDistantGalaxy")
    let leftArrow = SKLabelNode(fontNamed: "SFDistantGalaxy")
    let rightArrow = SKLabelNode(fontNamed: "SFDistantGalaxy")
    
    
    
    override func didMove(to view: SKView) {
        
        
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.zPosition = 0
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(background)
        
        
        let playerImage = SKSpriteNode(imageNamed: "ca")
        playerImage.setScale(0.6)
        playerImage.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.6)
        playerImage.zPosition = 2
        playerImage.name = "playerImage"
        self.addChild(playerImage)
        
        
        leftArrow.text = "<"
        leftArrow.fontSize = 200
        leftArrow.position = CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.6)
        leftArrow.zPosition = 1
        leftArrow.name = "left"
        leftArrow.fontColor = SKColor.white
        self.addChild(leftArrow)
        
        
        rightArrow.text = ">"
        rightArrow.fontSize = 200
        rightArrow.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.6)
        rightArrow.zPosition = 1
        rightArrow.name = "right"
        rightArrow.fontColor = SKColor.white
        self.addChild(rightArrow)
        
        
        
        playGameLabel.text = "Play Game"
        playGameLabel.fontSize = 100
        playGameLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.3)
        playGameLabel.zPosition = 1
        playGameLabel.fontColor = SKColor.white
        self.addChild(playGameLabel)
    
        
    }
    
    
    func saveCharacter(){
        
        let nextPlayer = SKSpriteNode(imageNamed: playerList[currentIndex].playerSprite)
        nextPlayer.name = "playerImage"
        nextPlayer.setScale(0.6)
        nextPlayer.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.6)
        nextPlayer.zPosition = 2
        self.addChild(nextPlayer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let clickSound = SKAction.playSoundFileNamed("next", waitForCompletion: false)
        
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let transition1 = SKTransition.fade(withDuration: 0.5)
            
            if playGameLabel.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                self.view!.presentScene(sceneToMoveTo, transition: transition1)
            }
            if leftArrow.contains(pointOfTouch){
                
                leftArrow.run(clickSound)
                if currentIndex == 0{
                currentIndex = 2
                }else{
                    currentIndex -= 1
                }
                self.enumerateChildNodes(withName: "playerImage") {
                    image, stop in
                    image.removeFromParent()
                }
                saveCharacter()
            }
            if rightArrow.contains(pointOfTouch){
                rightArrow.run(clickSound)
                if currentIndex == 2{
                currentIndex = 0
                }else{
                    currentIndex += 1
                }
                self.enumerateChildNodes(withName: "playerImage") {
                    image, stop in
                    image.removeFromParent()
                }
                saveCharacter()
            }
        
        }
    }
    
    
}
