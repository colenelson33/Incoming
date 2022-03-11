//
//  PlayerSelectScene.swift
//  Space Mission
//
//  Created by 90304588 on 2/19/22.
//

import Foundation
import SpriteKit




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

let pinkShip = Character(playerSprite: "ca", weaponSprite: "greenShield", soundEffect: "blasterSound")
let blueShip = Character(playerSprite: "blueShip", weaponSprite: "greenShield", soundEffect: "blasterSound")
let whiteShip = Character(playerSprite: "ship1", weaponSprite: "shield", soundEffect: "blasterSound")
let ship2 = Character(playerSprite: "ship2", weaponSprite: "shield", soundEffect: "blasterSound")
let ship3 = Character(playerSprite: "ship3", weaponSprite: "redBullet", soundEffect: "blasterSound")
let ship4 = Character(playerSprite: "ship4", weaponSprite: "redBullet", soundEffect: "blasterSound")
let ship5 = Character(playerSprite: "ship5", weaponSprite: "greenShield", soundEffect: "blasterSound")

let playerList = [pinkShip, blueShip, whiteShip, ship2, ship3, ship4, ship5]



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
        playerImage.setScale(0.8)
        playerImage.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.6)
        playerImage.zPosition = 2
        playerImage.name = "playerImage"
        self.addChild(playerImage)
        
        
        leftArrow.text = "<"
        leftArrow.fontSize = 250
        leftArrow.position = CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.1)
        leftArrow.zPosition = 1
        leftArrow.name = "left"
        leftArrow.fontColor = SKColor.white
        self.addChild(leftArrow)
        
        
        rightArrow.text = ">"
        rightArrow.fontSize = 250
        rightArrow.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.1)
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
        
        let nextPlayer = SKSpriteNode(imageNamed: playerList[GlobalVar.currentIndex].playerSprite)
        nextPlayer.name = "playerImage"
        nextPlayer.setScale(0.8)
        nextPlayer.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.6)
        nextPlayer.zPosition = 2
        self.addChild(nextPlayer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //let clickSound = SKAction.playSoundFileNamed("next", waitForCompletion: false)
        
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let transition1 = SKTransition.fade(withDuration: 0.5)
            
            if playGameLabel.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                self.view!.presentScene(sceneToMoveTo, transition: transition1)
                print(GlobalVar.currentIndex)
            }
            if leftArrow.contains(pointOfTouch){
                
                //leftArrow.run(clickSound)
                if GlobalVar.currentIndex == 0{
                    GlobalVar.currentIndex = playerList.count-1
                    GlobalVar.player = SKSpriteNode(imageNamed: playerList[GlobalVar.currentIndex].playerSprite)
                    GlobalVar.weapon = playerList[GlobalVar.currentIndex].weaponSprite
                }else{
                    GlobalVar.currentIndex -= 1
                    GlobalVar.player = SKSpriteNode(imageNamed: playerList[GlobalVar.currentIndex].playerSprite)
                    GlobalVar.weapon = playerList[GlobalVar.currentIndex].weaponSprite
                }
                self.enumerateChildNodes(withName: "playerImage") {
                    image, stop in
                    image.removeFromParent()
                }
                saveCharacter()
            }
            if rightArrow.contains(pointOfTouch){
               // rightArrow.run(clickSound)
                if GlobalVar.currentIndex == playerList.count-1{
                    GlobalVar.currentIndex = 0
                    GlobalVar.player = SKSpriteNode(imageNamed: playerList[GlobalVar.currentIndex].playerSprite)
                    GlobalVar.weapon = playerList[GlobalVar.currentIndex].weaponSprite
                }else{
                    GlobalVar.currentIndex += 1
                    GlobalVar.player = SKSpriteNode(imageNamed: playerList[GlobalVar.currentIndex].playerSprite)
                    GlobalVar.weapon = playerList[GlobalVar.currentIndex].weaponSprite
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
