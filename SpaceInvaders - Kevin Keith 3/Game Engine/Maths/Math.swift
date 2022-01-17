//
//  Math.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-19.
//
import MetalKit



public var X_AXIS: float3{
    return float3(1,0,0)
}

public var Y_AXIS: float3{
    return float3(0,1,0)
}

public var Z_AXIS: float3{
    return float3(0,0,1)
}
class Math{
    public static func CalculateBall(angle: Float, initialVelocity: Float, startPosition: float3, gameTime: Float)->float3{
        var position: float3 = startPosition
        let vx = initialVelocity * cos(angle)
        let vy = initialVelocity * sin(angle)
        let time = gameTime
        
        let deltaX = vx * time/2
        let deltaY = vy * time - (9.8 * time) / 2
        
        let adjustX = startPosition.x - deltaX
        let adjustY = startPosition.y - deltaY
        
        position = float3(adjustX, adjustY,0)
        
        return position
    }
}
extension matrix_float4x4{
    
    mutating func translate(direction: float3){
        var result = matrix_identity_float4x4
        
        let x: Float = direction.x
        let y: Float = direction.y
        let z: Float = direction.z
        
        result.columns = (
            float4(1,0,0,0),
            float4(0,1,0,0),
            float4(0,0,1,0),
            float4(x,y,z,1)
        )
        
        self = matrix_multiply(self, result)
    }
    
    mutating func scale(axis: float3){
        var result = matrix_identity_float4x4
        
        let x: Float = axis.x
        let y: Float = axis.y
        let z: Float = axis.z
        
        result.columns = (
            float4(x,0,0,0),
            float4(0,y,0,0),
            float4(0,0,z,0),
            float4(0,0,0,1)
        )
        
        self = matrix_multiply(self, result)
    }
    
    
    mutating func rotate(angle: Float, axis: float3){
        var result = matrix_identity_float4x4
        
        let x: Float = axis.x
        let y: Float = axis.y
        let z: Float = axis.z
        
        let c: Float = cos(angle)
        let s: Float = sin(angle)
        
        let mc: Float = (1 - c)
        
        let r1c1: Float = x * x * mc + c
        let r2c1: Float = x * y * mc + z * s
        let r3c1: Float = x * z * mc - y * s
        let r4c1: Float = 0.0
        
        let r1c2: Float = y * x * mc - z * s
        let r2c2: Float = y * y * mc + c
        let r3c2: Float = y * z * mc + x * s
        let r4c2: Float = 0.0
        
        let r1c3: Float = z * x * mc + y * s
        let r2c3: Float = z * y * mc - x * s
        let r3c3: Float = z * z * mc + c
        let r4c3: Float = 0.0
        
        let r1c4: Float = 0.0
        let r2c4: Float = 0.0
        let r3c4: Float = 0.0
        let r4c4: Float = 1.0
        
        result.columns = (
            float4(r1c1, r2c1, r3c1, r4c1),
            float4(r1c2, r2c2, r3c2, r4c2),
            float4(r1c3, r2c3, r3c3, r4c3),
            float4(r1c4, r2c4, r3c4, r4c4)
        )
        
        self = matrix_multiply(self, result)
    }
    
    static func orthographic(left: Float, right: Float, bottom: Float, top: Float, near: Float, far: Float)->matrix_float4x4{
            let r = right
            let l = left
            let t = top
            let b = bottom
            let n = near
            let f = far
            
            let col0 = float4(2 / (r - l), 0, 0, 0)
            let col1 = float4(0, 2 / (t - b), 0, 0)
            let col2 = float4(0, 0, -2 / (f - n), 0)
            let col3 = float4(-(r + l) / (r - l), -(t + b) / (t - b), -(f + n) / (f - n), 1)
            return float4x4 (
                col0, col1, col2, col3
            )
        }
    
}
