//
//  GameTime.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-30.
//
import MetalKit
import SpriteKit

class Engine {
    
    public static var Device: MTLDevice!
    public static var CommandQueue: MTLCommandQueue!
    public static var DefaultLibrary: MTLLibrary!
    public static func CreateCompute(rdc: MTLRenderCommandEncoder, cb: MTLCommandBuffer)->MTLRenderCommandEncoder{
        
        let maskMesh = MeshLibrary.Mesh(.Quad_Custom)
        
        rdc.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Mask))
        rdc.setVertexBuffer(maskMesh.vertexBuffer, offset: 0, index: 0)
        rdc.setFragmentTexture(TextureLibrary.getTexture(.TerrainMask), index: 0)
        rdc.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: maskMesh.vertexCount)
        
        return rdc
    }
    public static func StartEngine(device: MTLDevice){
        self.Device = device
        self.CommandQueue = device.makeCommandQueue()
        DefaultLibrary = device.makeDefaultLibrary()
        
        ShaderLibrary.Initialize()
        
        TextureLibrary.Initialize()
        
        VertexDescriptorLibrary.Intialize()
        
        RenderPipelineDescriptorLibrary.Initialize()
        
        RenderPipelineStateLibrary.Initialize()
        
        MeshLibrary.Initialize()
        
        SceneManager.Initialize(Preferences.StartingSceneType)
        
    }
    
}
