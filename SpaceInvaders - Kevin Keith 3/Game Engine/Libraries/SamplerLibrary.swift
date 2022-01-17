//
//  SamplerLibrary.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-28.
//


import Foundation
import Metal

enum SamplerStateTypes {
    case None
    case Linear
}

class SamplerStateLibrary {
    
    public static var samplers: [SamplerStateTypes : MTLSamplerState] = [:]
    public static func Initialize(){
        fillLibrary()
    }
    private static func fillLibrary(){
        samplers.updateValue(Linear_SamplerState().sampler2D, forKey: .Linear)
    }
}
protocol SamplerState {
    var name: String { get }
    var sampler2D: MTLSamplerState! { get }
}

class Linear_SamplerState: SamplerState {
    var name: String = "Linear Sampler State"
        var sampler2D: MTLSamplerState!
        
        init() {
            let samplerDescriptor = MTLSamplerDescriptor()
            samplerDescriptor.minFilter = .linear
            samplerDescriptor.magFilter = .linear
            samplerDescriptor.label = name
            sampler2D = Engine.Device.makeSamplerState(descriptor: samplerDescriptor)
        }
}
