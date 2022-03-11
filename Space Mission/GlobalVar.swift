//
//  GlobalVar.swift
//  Space Mission
//
//  Created by 90304588 on 3/9/22.
//

import Foundation
import SpriteKit

struct GlobalVar{
    public static var currentIndex = 0
    public static var player = SKSpriteNode(imageNamed: playerList[GlobalVar.currentIndex].playerSprite)
    public static var weapon = "greenShield"
}
