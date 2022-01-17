//
//  Health.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-16.
//

import Foundation
import MetalKit

class Health : GameObject{
    init() {
        super.init(meshType: .Quad_Custom)
        texture = TextureLibrary.getTexture(.Player)
        setTexture(.Player)
    }
}
