//
//  Node.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-30.
//

import MetalKit
import SpriteKit

class Node {
    var id : String = ""
    var position: float3 = float3(0,0,0)
    var scale: float3 = float3(1,1,1)
    var rotation: float3 = float3(0,0,0)
    var speedX: Float = 100
    var speedY: Float = 100
    var modelMatrix: matrix_float4x4{
        var modelMatrix = matrix_identity_float4x4
        modelMatrix.translate(direction: position)
        modelMatrix.rotate(angle: rotation.x, axis: X_AXIS)
        modelMatrix.rotate(angle: rotation.y, axis: Y_AXIS)
        modelMatrix.rotate(angle: rotation.z, axis: Z_AXIS)
        modelMatrix.scale(axis: scale)
        return modelMatrix
    }
    
    var name: String = "None"
    init(){
        self.id = UUID().uuidString
    }
    func update(){
        
    }
//    func maskRender(renderCommandEncoder: MTLRenderCommandEncoder){
////        for bullet in bullets{
////            bullet.render(renderCommandEncoder: renderCommandEncoder)
////        }
////        for t in terrain{
////            t.render(renderCommandEncoder: renderCommandEncoder)
////        }
//    }
    func render(renderCommandEncoder: MTLRenderCommandEncoder){
        if let renderable = self as? Renderable {
            renderable.doRender(renderCommandEncoder)
        }
    }
    
}
