//
//  Scene.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-30.
//
import MetalKit
import SpriteKit

class Scene: Node {
    
    var projectionMatrix : matrix_float4x4!
    
    var sceneConstants = ScreenConstants()
    
    override init(){
        super.init()
        projectionMatrix = matrix_float4x4.orthographic(left: -Preferences.screenWidth/2, right: Preferences.screenWidth/2, bottom: -Preferences.screenHeight/2, top: Preferences.screenHeight/2, near: -10, far: 10)
        buildScene()
        
    }

    override func update() {
        sceneConstants.projectionMatrix = projectionMatrix
        super.update()
    }
    
    func buildScene() { }
    func bulletMaskRender(renderCommandEncoder: MTLRenderCommandEncoder){
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: ScreenConstants.size, index: 1)
    }
    func renderEnemies(renderCommandEncoder: MTLRenderCommandEncoder){
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: ScreenConstants.size, index: 1)
    }
    func playerMaskRender(renderCommandEncoder: MTLRenderCommandEncoder){
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: ScreenConstants.size, index: 1)
    }
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: ScreenConstants.size, index: 1)
        super.render(renderCommandEncoder: renderCommandEncoder)
    }
    
}

/*
 Compute Shaders - Image processes all at the same time Image Processing - Change Color
 Multiple Render Passes - MTLRenderPass Descriptor
 Texture Rendering - Read in Textures
 
 */
