//
//  Missile.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-15.
//

import Foundation
import MetalKit
import SwiftUI


class Missile: GameObject {
     //Initial Velocity
    var start: float3! //Starting position
    var angle: Float! //Starting angle
    var gravity: Float = 100.0
    var time : Float!
    var wind : Float =  0.1
    var speed: Float = 0.01
    var direction: Float = 1
    init() {
        super.init(meshType: .Quad_Custom)
        hitBox = HitBox()
        texture = Texture("CannonBall").texture
        setTexture(.None)
        rotation.z = -1.6
        speedX = 1000
        modelConstants.maskColor = float3(1,0,0)
        time = 0
        time += GameTime.DeltaTime
        velocity = 400
    }
    func setDirection(direction: Float){
        self.direction = direction
    }
    //F=MA
    //y = y + initialVelocity + 1/2acceleration(deltaTime)
    //Acceleration formula
    
    override func update() {
        position.y += velocity * direction
        
        time += GameTime.DeltaTime
        hitBox.positionX = position.x
        hitBox.positionY = position.y
        hitBox.height = scale.y
        hitBox.width = scale.x
        super.update()
    }
}
