//
//  GameScene.swift
//  Space Mission
//
//  Created by 90304588 on 2/16/22.
//

import SpriteKit
import GameplayKit

var currentPlay = playerList[currentIndex]
//sets up current player object using the current index from player select scene
var player = SKSpriteNode(imageNamed: currentPlay.playerSprite)
//sets up current image by retrieving the String from Character object

var gameScore = 0
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var livesNum = 3
    let livesLabel = SKLabelNode(fontNamed: "SFDistantGalaxy")
    
    let scoreLabel = SKLabelNode(fontNamed: "SFDistantGalaxy")
    enum gameState{
        case preGame //before start of game
        case inGame
        case afterGame //case after game
    }
    let tapToStartLabel = SKLabelNode(fontNamed: "SFDistantGalaxy")
    
    
    var currentGameState = gameState.preGame
    
    func startGame(){
        currentGameState = gameState.inGame
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let removeLabelSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(removeLabelSequence)
        
        let movePlayerOnScreen = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([movePlayerOnScreen, startLevelAction])
        player.run(startGameSequence)
    }
    
    func runGameOver(){
        currentGameState = gameState.afterGame
        self.removeAllActions()
        self.enumerateChildNodes(withName: "Bullet") {
            obj, stop in
            obj.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Meteor") {
            meteor, stop in
            meteor.removeAllActions()
        }
        let changeSceneAction = SKAction.run(changeScene)
        let waitAction = SKAction.wait(forDuration: 1)
        let changeSequence = SKAction.sequence([waitAction, changeSceneAction])
        self.run(changeSequence)
        changeScene()
        
    }
    func changeScene(){
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition1 = SKTransition.fade(withDuration: 0.6)
        self.view!.presentScene(sceneToMoveTo, transition: transition1)
        
        
    }
        
    
    
    struct PhysicsCategories{
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1 //binary for 1
        static let Obj: UInt32 = 0b10 //binary for 2
        static let Meteor : UInt32 = 0b100 //binary for 4
    }
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Meteor{
            // if player hits enemy...
            
           if body1.node != nil{
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil{
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            runGameOver()
        }
        if body1.categoryBitMask == PhysicsCategories.Obj && body2.categoryBitMask == PhysicsCategories.Meteor
            //&& body2.node?.position.y < self.size.height
        {
            //if bullet hits enemy
            if body2.node != nil{
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            addScore()
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        
    }
    
    func spawnExplosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 0.2, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let deleteE = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, deleteE])
        explosion.run(explosionSequence)
    }
    
    var gameArea: CGRect
    override init(size: CGSize){
        self.gameArea = CGRect()
        super.init(size: size)
        let maxAspectRatio: CGFloat = 19.5/9.0
        let playableWidth = size.height/maxAspectRatio
        let margin = (size.width-playableWidth)/2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let capSound = SKAction.playSoundFileNamed("blasterSound", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("boomSound", waitForCompletion: false)
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    func random(min min: CGFloat, max: CGFloat)->CGFloat{
        return random() * (max - min) + min
    }
    /*override func update(_ currentTime: TimeInterval){
        if lastUpdateTime == 0{
            lastUpdateTime = currentTime
        }else{
            deltaTime = currentTime - lastUpdateTime
        }
        
        let amountToMoveBackground = amtToMovePerSec * CGFloat(deltaTime)
        self.enumerateChildNodes(withName: "Background"){
            background, stop in
            if self.currentGameState == gameState.inGame{
            background.position.y -= amountToMoveBackground
            }
            if background.position.y < -self.size.height{
                background.position.y += self.size.height*2
            }
        }
        
    }*/
    
    var lastUpdateTime : TimeInterval = 0
    var deltaTime : TimeInterval = 0
    var amtToMovePerSec: CGFloat = 600.0
    
    override func didMove(to view: SKView) {
        gameScore = 0
        self.physicsWorld.contactDelegate = self
        
        for i in 0...1{
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0)
        background.position = CGPoint(x: self.size.width/2,
                                      y: self.size.height * CGFloat(i))
        background.name = "Background"
        background.zPosition = 0
        self.addChild(background)
        }
        
        
        
        player.setScale(0.2)
        player.position = CGPoint(x: self.size.width/2, y: 0-player.size.height)
        
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Meteor
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.22,y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 50
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width * 0.78,y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        let moveToScreen = SKAction.moveTo(y: self.size.height*0.9, duration: 0.7)
        livesLabel.run(moveToScreen)
        scoreLabel.run(moveToScreen)
        
        tapToStartLabel.text = "Tap To Begin"
        tapToStartLabel.fontSize = 90
        tapToStartLabel.color = SKColor.white
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.7)
        tapToStartLabel.run(fadeInAction)
        
        
        
        
        
    }
    func loseLife(){
        livesNum -= 1
        livesLabel.text = "Lives: \(livesNum)"
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        if livesNum == 0 {
            runGameOver()
        }
        
    }
    
    
    func addScore(){
        gameScore+=1
        scoreLabel.text = "Score: \(gameScore)"
        if gameScore == 8 || gameScore == 16 || gameScore == 24 || gameScore == 30{
            startNewLevel()
        }
    }
    
    func fireObj(){
        let obj = SKSpriteNode(imageNamed: "shield")
        obj.name = "Bullet"
        obj.setScale(0.5)
        obj.position = player.position
        obj.zPosition = 1
        obj.physicsBody = SKPhysicsBody(rectangleOf: obj.size)
        obj.physicsBody!.affectedByGravity = false
        obj.physicsBody!.categoryBitMask = PhysicsCategories.Obj
        obj.physicsBody!.collisionBitMask = PhysicsCategories.None
        obj.physicsBody!.contactTestBitMask = PhysicsCategories.Meteor
        self.addChild(obj)
        
        let moveObj = SKAction.moveTo(y: obj.size.height + self.size.height, duration: 1)
        let deleteObj = SKAction.removeFromParent()
        let objSequence = SKAction.sequence([capSound, moveObj, deleteObj])
        obj.run(objSequence)
    }
    
    func spawnMeteor(){
        let randomXStart = random(min: gameArea.minX , max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX , max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height*1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height*0.2)
        
        let meteor = SKSpriteNode(imageNamed: "rock")
        meteor.name = "Meteor"
        meteor.setScale(0.2)
        meteor.position = startPoint
        meteor.zPosition = 2
        meteor.physicsBody = SKPhysicsBody(rectangleOf: meteor.size)
        meteor.physicsBody!.affectedByGravity = false
        meteor.physicsBody!.categoryBitMask = PhysicsCategories.Meteor
        meteor.physicsBody!.collisionBitMask = PhysicsCategories.None
        meteor.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Obj
        self.addChild(meteor)
        let moveMeteor = SKAction.move(to: endPoint, duration: 2)
        let deleteMeteor = SKAction.removeFromParent()
        let loseLifeAction = SKAction.run(loseLife)
        let meteorSequence = SKAction.sequence([moveMeteor, deleteMeteor, loseLifeAction])
        if currentGameState == gameState.inGame{
        meteor.run(meteorSequence)
        }
        
        let dx = endPoint.x-startPoint.x
        let dy = endPoint.y-startPoint.y
        let amtRotate = atan2(dy,dx)
        meteor.zRotation = amtRotate
        
        
    }
    
    var levelNumber = 0
    func startNewLevel(){
        
        levelNumber += 1
        if self.action(forKey: "spawningMeteor") != nil{
            self.removeAction(forKey: "spawningMeteor")
        }
        
        var levelDuration = TimeInterval()
        switch levelNumber{
        case 1: levelDuration = 1.2
        case 2: levelDuration = 1
        case 3: levelDuration = 0.8
        case 4: levelDuration = 0.6
        case 5: levelDuration = 0.01
            
        default:
            levelDuration = 0.5
            print("Cannot find level info")
            
        }
        
        let spawn = SKAction.run(spawnMeteor)
        let waitSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningMeteor")
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == gameState.preGame{
            startGame()
        } else if currentGameState == gameState.inGame{
        fireObj()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let previousPoT = touch.previousLocation(in: self)
            let amtDragged = pointOfTouch.x - previousPoT.x
            if currentGameState == gameState.inGame{
            player.position.x += amtDragged
            }
            
            if player.position.x > gameArea.maxX - player.size.width/2{
                player.position.x = gameArea.maxX - player.size.width/2
            }
            if player.position.x < gameArea.minX + player.size.width/2{
                player.position.x = gameArea.minX + player.size.width/2
            }
        }
    }
    
}
