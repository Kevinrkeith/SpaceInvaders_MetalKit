//
//  Terrain.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-19.
//

import Foundation
import SpriteKit
import GameKit

class Terrain: GameObject {
    
    init() {
        super.init(meshType: .Terrain_Custom)
        setTexture(.Grass)
        texture = Texture("Unknown").texture
        name = "Terrain"
        modelConstants.maskColor = float3(0,0,1)
    }
}
