//
//  Enemy.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-29.
//

import Foundation

class Enemy : GameObject{
    
    init(textureType : TextureTypes){
        super.init(meshType: .Quad_Custom)
        texture = TextureLibrary.getTexture(textureType)
        //texture = TextureLibrary.getTexture(.FirstPassTexture0)
        setTexture(.Player)
        scale = float3(100,100,0)
        modelConstants.maskColor = float3(0,1,0)
    }
    func setScore(score : Int){
        self.score = score
    }
    func getScore()->Int{
        return score
    }
    override func update() {
        hitBox.positionX = position.x
        hitBox.positionY = position.y
        hitBox.height = scale.y
        hitBox.width = scale.x
        super.update()
    }
}
