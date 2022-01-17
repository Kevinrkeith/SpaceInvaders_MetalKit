//
//  Types.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-30.
//

import simd
public typealias float2 = SIMD2<Float>
public typealias float3 = SIMD3<Float>
public typealias float4 = SIMD4<Float>

protocol sizeable{ }
extension sizeable{
    static var size: Int{
        return MemoryLayout<Self>.size
    }
    
    static var stride: Int{
        return MemoryLayout<Self>.stride
    }
    
    static func size(_ count: Int)->Int{
        return MemoryLayout<Self>.size * count
    }
    
    static func stride(_ count: Int)->Int{
        return MemoryLayout<Self>.stride * count
    }
}

extension Float: sizeable { }
extension float2: sizeable { }
extension float3: sizeable { }
extension float4: sizeable { }


struct Vertex: sizeable{
    var position: float3
    var color: float4
    var textureCoordinate: float2
}

struct ModelConstants: sizeable{
    var modelMatrix = matrix_identity_float4x4
    var maskColor = float3(1,1,1)
}
struct ScreenConstants: sizeable{
    var projectionMatrix = matrix_identity_float4x4
}
struct Material: sizeable{
    var color = float4(0.8, 0.8, 0.8, 1.0)
    var useMaterialColor: Bool = false
    var useTexture: Bool = false
}
//First layer represents collision
//Second layer is for what we render to the screen

