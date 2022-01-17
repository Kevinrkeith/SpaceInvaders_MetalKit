//
//  RenderPipelineStateLibrary.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-19.
//
import MetalKit

enum RenderPipelineStateTypes {
    case Basic
    case Mask
    case Final
}

class RenderPipelineStateLibrary {
    
    private static var renderPipelineStates: [RenderPipelineStateTypes: RenderPipelineState] = [:]
    
    public static func Initialize(){
        createDefaultRenderPipelineStates()
    }
    
    private static func createDefaultRenderPipelineStates(){
        
        renderPipelineStates.updateValue(Basic_RenderPipelineState(), forKey: .Basic)
        
        renderPipelineStates.updateValue(Mask_RenderPipelineState(), forKey: .Mask)
        
        renderPipelineStates.updateValue(Final_RenderPipelineState(), forKey: .Final)
    }
    
    public static func PipelineState(_ renderPipelineStateType: RenderPipelineStateTypes)->MTLRenderPipelineState{
        return (renderPipelineStates[renderPipelineStateType]?.renderPipelineState)!
    }
    
}

protocol RenderPipelineState {
    var name: String { get }
    var renderPipelineState: MTLRenderPipelineState! { get }
}

public struct Basic_RenderPipelineState: RenderPipelineState {
    var name: String = "Basic Render Pipeline State"
    var renderPipelineState: MTLRenderPipelineState!
    init(){
        do{
            renderPipelineState = try Engine.Device.makeRenderPipelineState(descriptor: RenderPipelineDescriptorLibrary.Descriptor(.Basic))
        }catch let error as NSError {
            print("ERROR::CREATE::RENDER_PIPELINE_STATE::__\(name)__::\(error)")
        }
    }
}
public struct Mask_RenderPipelineState: RenderPipelineState {
    var name: String = "Mask Render Pipeline State"
    var renderPipelineState: MTLRenderPipelineState!
    init(){
        do{
            renderPipelineState = try Engine.Device.makeRenderPipelineState(descriptor: RenderPipelineDescriptorLibrary.Descriptor(.Mask))
        }catch let error as NSError {
            print("ERROR::CREATE::RENDER_PIPELINE_STATE::__\(name)__::\(error)")
        }
    }
}
public struct Final_RenderPipelineState: RenderPipelineState {
    var name: String = "Final Render Pipeline State"
    var renderPipelineState: MTLRenderPipelineState!
    init(){
        do{
            renderPipelineState = try Engine.Device.makeRenderPipelineState(descriptor: RenderPipelineDescriptorLibrary.Descriptor(.Final))
        }catch let error as NSError {
            print("ERROR::CREATE::RENDER_PIPELINE_STATE::__\(name)__::\(error)")
        }
    }
}
