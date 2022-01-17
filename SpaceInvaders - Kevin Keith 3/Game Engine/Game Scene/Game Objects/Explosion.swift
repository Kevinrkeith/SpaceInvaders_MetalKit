//
//  Explosion.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-30.
//

import Foundation

class Explosion: GameObject{
    var growSpeed : Float = 100
    init() {
        super.init(meshType: .Quad_Custom)
        texture = Texture("Explosion").texture
        setTexture(.None)
    }
    override func update() {
        
        scale.x += growSpeed
        scale.y += growSpeed
        
        super.update()
    }
}
