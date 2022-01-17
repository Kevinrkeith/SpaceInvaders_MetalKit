//
//  RenderPipelineDescriptorLibrary.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-19.
//
import MetalKit

enum RenderPipelineDescriptorTypes {
    case Basic
    case Mask
    case Final
}

class RenderPipelineDescriptorLibrary {
    
    private static var renderPipelineDescriptors: [RenderPipelineDescriptorTypes : RenderPipelineDescriptor] = [:]
    
    public static func Initialize() {
        createDefaultRenderPipelineDescriptors()
    }
    
    private static func createDefaultRenderPipelineDescriptors() {
        
        renderPipelineDescriptors.updateValue(Basic_RenderPipelineDescriptor(), forKey: .Basic)
        renderPipelineDescriptors.updateValue(Mask_RenderPipelineDescriptor(), forKey: .Mask)
        renderPipelineDescriptors.updateValue(Final_RenderPipelineDescriptor(), forKey: .Final)
        
    }
    
    public static func Descriptor(_ renderPipelineDescriptorType: RenderPipelineDescriptorTypes)->MTLRenderPipelineDescriptor{
        return renderPipelineDescriptors[renderPipelineDescriptorType]!.renderPipelineDescriptor
    }
    
}

protocol RenderPipelineDescriptor {
    var name: String { get }
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor! { get }
}

public struct Basic_RenderPipelineDescriptor: RenderPipelineDescriptor{
    var name: String = "Basic Render Pipeline Descriptor"
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor!
    init(){
        renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = Preferences.MainPixelFormat
        renderPipelineDescriptor.vertexFunction = ShaderLibrary.getShader(.Basic_Vertex)
        renderPipelineDescriptor.fragmentFunction = ShaderLibrary.getShader(.Basic_Fragment)
        renderPipelineDescriptor.vertexDescriptor = VertexDescriptorLibrary.Descriptor(.Basic)
        
    }
}
public struct Mask_RenderPipelineDescriptor: RenderPipelineDescriptor{
    var name: String = "Mask Render Pipeline Descriptor"
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor!
    init(){
        renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = Preferences.MainPixelFormat
        
        renderPipelineDescriptor.vertexFunction = ShaderLibrary.getShader(.Basic_Vertex)
        renderPipelineDescriptor.fragmentFunction = ShaderLibrary.getShader(.Mask_Fragment)
        
        renderPipelineDescriptor.vertexDescriptor = VertexDescriptorLibrary.Descriptor(.Basic)
    }
}
public struct Final_RenderPipelineDescriptor: RenderPipelineDescriptor{
    var name: String = "Final Render Pipeline Descriptor"
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor!
    init(){
        renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = Preferences.MainPixelFormat
        renderPipelineDescriptor.vertexFunction = ShaderLibrary.getShader(.Final_Vertex)
        renderPipelineDescriptor.fragmentFunction = ShaderLibrary.getShader(.Final_Fragment)
        renderPipelineDescriptor.vertexDescriptor = VertexDescriptorLibrary.Descriptor(.Basic)
    }
}

