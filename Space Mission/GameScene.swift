//
//  GameScene.swift
//  Space Mission
//
//  Created by 90304588 on 2/16/22.
//

import SpriteKit
import GameplayKit


//sets up current player object using the current index from player select scene
//var player = SKSpriteNode(imageNamed: playerList[GlobalVar.currentIndex].playerSprite)

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
    
    enum abilityState{
        case normal
        case x2
    }
    
    
    let tapToStartLabel = SKLabelNode(fontNamed: "SFDistantGalaxy")
    
    var currentAbilityState = abilityState.normal
    var currentGameState = gameState.preGame
    
    func startGame(){
        currentGameState = gameState.inGame
        currentAbilityState = abilityState.normal
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let removeLabelSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(removeLabelSequence)
        
        let movePlayerOnScreen = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([movePlayerOnScreen, startLevelAction])
        GlobalVar.player.run(startGameSequence)
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
        self.enumerateChildNodes(withName: "Player"){
            player, stop in
            player.removeFromParent()
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
        static let Nuke: UInt32 = 0b1000 //8
        static let x2: UInt32 = 0b10000 //
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
            //&& body2.node!.position.y < self.size.height
        {
           
            //if bullet hits enemy
            if body2.node != nil{
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            addScore()
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        if body1.categoryBitMask == PhysicsCategories.Obj && body2.categoryBitMask == PhysicsCategories.Nuke{
           
            if body2.node != nil{
                spawnExplosion(spawnPosition: body2.node!.position)
                }
                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
            
           self.enumerateChildNodes(withName: "Meteor") {
                meteor, stop in
                self.spawnExplosion(spawnPosition: meteor.position)
                meteor.removeFromParent()
               
            }
            
            
            startNewLevel()
        }
        if body1.categoryBitMask == PhysicsCategories.Obj && body2.categoryBitMask == PhysicsCategories.x2{
            currentAbilityState = abilityState.x2
          
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
    func random(min: CGFloat, max: CGFloat)->CGFloat{
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
    let levelLabel = SKLabelNode(fontNamed: "SFDistantGalaxy")
    
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
        
        
       // let player = GlobalVar.player
        GlobalVar.player.setScale(0.4)
        GlobalVar.player.position = CGPoint(x: self.size.width/2, y: 0-GlobalVar.player.size.height)
        
        GlobalVar.player.zPosition = 2
        GlobalVar.player.name = "Player"
        GlobalVar.player.physicsBody = SKPhysicsBody(rectangleOf: GlobalVar.player.size)
        GlobalVar.player.physicsBody!.affectedByGravity = false
        GlobalVar.player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        GlobalVar.player.physicsBody!.collisionBitMask = PhysicsCategories.None
        GlobalVar.player.physicsBody!.contactTestBitMask = PhysicsCategories.Meteor
        self.addChild(GlobalVar.player)
        
        
        
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
        
        levelLabel.text = "Level 1"
        levelLabel.fontSize = 150
        levelLabel.fontColor = SKColor.white
        levelLabel.alpha = 0.6
        levelLabel.position = CGPoint(x: self.size.width * 0.5,y: self.size.height * 0.7)
        levelLabel.zPosition = 100
        self.addChild(levelLabel)
        
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
        if gameScore == 8 || gameScore == 16 || gameScore == 24 || gameScore == 32 || gameScore == 40 || gameScore == 48 || gameScore == 56 {
            startNewLevel()
        }
    }
    
    func fireObj(){
        
        if currentAbilityState == abilityState.normal{
        let obj = SKSpriteNode(imageNamed: GlobalVar.weapon)
        obj.name = "Bullet"
        obj.setScale(0.5)
        obj.position = GlobalVar.player.position
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
        } else if currentAbilityState == abilityState.x2{
            
            let obj1 = SKSpriteNode(imageNamed: GlobalVar.weapon)
            obj1.name = "Bullet"
            obj1.setScale(0.4)
            obj1.position = CGPoint(x: GlobalVar.player.position.x - GlobalVar.player.size.width * 0.25, y: GlobalVar.player.position.y)
            obj1.zPosition = 1
            obj1.physicsBody = SKPhysicsBody(rectangleOf: obj1.size)
            obj1.physicsBody!.affectedByGravity = false
            obj1.physicsBody!.categoryBitMask = PhysicsCategories.Obj
            obj1.physicsBody!.collisionBitMask = PhysicsCategories.None
            obj1.physicsBody!.contactTestBitMask = PhysicsCategories.Meteor
            self.addChild(obj1)
            
            let moveObj = SKAction.moveTo(y: obj1.size.height + self.size.height, duration: 1)
            let deleteObj = SKAction.removeFromParent()
            let objSequence = SKAction.sequence([capSound, moveObj, deleteObj])
           
            let obj2 = SKSpriteNode(imageNamed: GlobalVar.weapon)
            obj2.name = "Bullet"
            obj2.setScale(0.4)
            obj2.position = CGPoint(x: GlobalVar.player.position.x + GlobalVar.player.size.width * 0.25, y: GlobalVar.player.position.y)
            obj2.zPosition = 1
            obj2.physicsBody = SKPhysicsBody(rectangleOf: obj2.size)
            obj2.physicsBody!.affectedByGravity = false
            obj2.physicsBody!.categoryBitMask = PhysicsCategories.Obj
            obj2.physicsBody!.collisionBitMask = PhysicsCategories.None
            obj2.physicsBody!.contactTestBitMask = PhysicsCategories.Meteor
            self.addChild(obj2)
            
            let moveObj2 = SKAction.moveTo(y: obj2.size.height + self.size.height, duration: 1)
            let deleteObj2 = SKAction.removeFromParent()
            let objSequence2 = SKAction.sequence([capSound, moveObj2, deleteObj2])
            
            obj2.run(objSequence2)
            obj1.run(objSequence)
        }
    }
    
    func spawnMeteor(){
        let randomXStart = random(min: gameArea.minX , max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX , max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height*1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height*0.2)
        
        let meteor = SKSpriteNode(imageNamed: "meteor")
        meteor.name = "Meteor"
        meteor.setScale(0.4)
        meteor.position = startPoint
        meteor.zPosition = 2
        meteor.physicsBody = SKPhysicsBody(rectangleOf: meteor.size)
        meteor.physicsBody!.affectedByGravity = false
        meteor.physicsBody!.categoryBitMask = PhysicsCategories.Meteor
        meteor.physicsBody!.collisionBitMask = PhysicsCategories.None
        meteor.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Obj
        self.addChild(meteor)
        let moveMeteor = SKAction.move(to: endPoint, duration: 3)
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
    
    
    func spawnX2(){
        let randomXStart = random(min: gameArea.minX , max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX , max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height*1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height*0.2)
        
        let x2 = SKSpriteNode(imageNamed: "x2")
        x2.name = "x2"
        x2.setScale(0.4)
        x2.position = startPoint
        x2.zPosition = 2
        x2.physicsBody = SKPhysicsBody(rectangleOf: x2.size)
        x2.physicsBody!.affectedByGravity = false
        x2.physicsBody!.categoryBitMask = PhysicsCategories.x2
        x2.physicsBody!.collisionBitMask = PhysicsCategories.None
        x2.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Obj
        self.addChild(x2)
        let moveMeteor = SKAction.move(to: endPoint, duration: 3)
        let deleteMeteor = SKAction.removeFromParent()
        let loseLifeAction = SKAction.run(loseLife)
        let meteorSequence = SKAction.sequence([moveMeteor, deleteMeteor, loseLifeAction])
        if currentGameState == gameState.inGame{
           x2.run(meteorSequence)
        }
        
        let dx = endPoint.x-startPoint.x
        let dy = endPoint.y-startPoint.y
        let amtRotate = atan2(dy,dx)
        x2.zRotation = amtRotate
        
        
    }
    
    
    
    func spawnNuke(){
        let randomXStart = random(min: gameArea.minX , max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX , max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height*1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height*0.2)
        
        let nuke = SKSpriteNode(imageNamed: "nuke")
        nuke.name = "Nuke"
        nuke.zRotation = 1
        nuke.setScale(0.2)
        nuke.position = startPoint
        nuke.zPosition = 2
        nuke.physicsBody = SKPhysicsBody(rectangleOf: nuke.size)
        nuke.physicsBody!.affectedByGravity = false
        nuke.physicsBody!.categoryBitMask = PhysicsCategories.Nuke
        nuke.physicsBody!.collisionBitMask = PhysicsCategories.None
        nuke.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Obj | PhysicsCategories.Meteor
        self.addChild(nuke)
        let moveMeteor = SKAction.move(to: endPoint, duration: 3)
        let deleteMeteor = SKAction.removeFromParent()
        let loseLifeAction = SKAction.run(loseLife)
        let meteorSequence = SKAction.sequence([moveMeteor, deleteMeteor, loseLifeAction])
        if currentGameState == gameState.inGame{
        nuke.run(meteorSequence)
        }
        
        let dx = endPoint.x-startPoint.x
        let dy = endPoint.y-startPoint.y
        let amtRotate = atan2(dy,dx)
        nuke.zRotation = amtRotate

    }
  
    
    var levelNumber = 0
    func startNewLevel(){
        
        levelNumber += 1
        levelLabel.text = "Level \(levelNumber)"
        let spawnNuke = SKAction.run(spawnNuke)
        let spawnX2 = SKAction.run(spawnX2)
        
        if levelNumber == 2 || levelNumber == 5 || levelNumber == 7{
            self.run(spawnNuke)
        }
        if levelNumber == 3 || levelNumber == 6 {
            self.run(spawnX2)
        }
        if levelNumber == 4 {
            currentAbilityState = abilityState.normal
        }
        if self.action(forKey: "spawningMeteor") != nil{
            self.removeAction(forKey: "spawningMeteor")
        }
        
        var levelDuration = TimeInterval()
        switch levelNumber{
        case 1: levelDuration = 0.8
        case 2: levelDuration = 0.008
        case 3: levelDuration = 0.5
        case 4: levelDuration = 0.4
        case 5: levelDuration = 0.01
        case 6: levelDuration = 0.6
        case 7: levelDuration = 0.01
        case 8: levelDuration = 0.2
            
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
                GlobalVar.player.position.x += amtDragged
            }
            
            if GlobalVar.player.position.x > gameArea.maxX - GlobalVar.player.size.width/2{
                GlobalVar.player.position.x = gameArea.maxX - GlobalVar.player.size.width/2
            }
            if GlobalVar.player.position.x < gameArea.minX + GlobalVar.player.size.width/2{
                GlobalVar.player.position.x = gameArea.minX + GlobalVar.player.size.width/2
            }
        }
    }
    
}
