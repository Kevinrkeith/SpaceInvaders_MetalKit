//
//  SamplerLibrary.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-28.
//
import MetalKit
enum ShaderTypes {
    // Vertex
    case Basic_Vertex
    case Mask_Vertex
    case Final_Vertex
    
    // Fragment
    case Basic_Fragment
    case Mask_Fragment
    case Final_Fragment
}

class ShaderLibrary {
    private static var _library: [ShaderTypes: Shader] = [:]
    
    public static func Initialize(){
        fillLibrary()
    }
    
    private static func fillLibrary() {
        
        // Vertex Shaders
        _library.updateValue(Shader(functionName: "basic_vertex_shader"), forKey: .Basic_Vertex)
        _library.updateValue(Shader(functionName: "basic_vertex_shader"), forKey: .Mask_Vertex)
        _library.updateValue(Shader(functionName: "final_vertex_shader"), forKey: .Final_Vertex)
        
        // Fragment Shaders
        _library.updateValue(Shader(functionName: "basic_fragment_shader"), forKey: .Basic_Fragment)
        _library.updateValue(Shader(functionName: "mask_fragment_shader"), forKey: .Mask_Fragment)
        _library.updateValue(Shader(functionName: "final_fragment_shader"), forKey: .Final_Fragment)
    }
    
    public static func getShader(_ type: ShaderTypes)->MTLFunction {
        return (_library[type]?.function)!
    }
}

class Shader {
    var function: MTLFunction!
    init(functionName: String) {
        self.function = Engine.DefaultLibrary.makeFunction(name: functionName)
        self.function.label = functionName
    }
}
