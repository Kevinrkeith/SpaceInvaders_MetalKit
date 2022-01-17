//
//  Player.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-30.
//
import MetalKit

class Player: GameObject {
    var missile: Missile!
    var gun: Health!
    var playerHealth = 3
    init() {
        super.init(meshType: .Quad_Custom)
        texture = TextureLibrary.getTexture(.Player)
        //texture = TextureLibrary.getTexture(.FirstPassTexture0)
        setTexture(.Player)
        scale = float3(100,100,0)
        modelConstants.maskColor = float3(0,1,0)
        
    }
    func createGun(){
        gun = Health()
        gun.position.x = position.x
        gun.position.y = position.y
    }
    func createHitBoxes(){
        hitBox.positionX = position.x
        hitBox.positionY = position.y
        hitBox.width = scale.x
        hitBox.height = scale.y
    }
    override func update() {
        super.update()
        createHitBoxes()
    }
}
