//
//  MeshLibrary.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-19.
//
import MetalKit

enum MeshTypes {
    case Triangle_Custom
    case Quad_Custom
    case Circle_Custom
    case Terrain_Custom
}

class MeshLibrary {
    
    private static var meshes: [MeshTypes:Mesh] = [:]
    
    public static func Initialize(){
        createDefaultMeshes()
    }
    private static func createDefaultMeshes(){
        meshes.updateValue(Quad_CustomMesh(), forKey: .Quad_Custom)
        meshes.updateValue(Terrain_CustomMesh(), forKey: .Terrain_Custom)
    }
    
    public static func Mesh(_ meshType: MeshTypes)->Mesh{
        return meshes[meshType]!
    }
    
}

protocol Mesh {
    var vertexBuffer: MTLBuffer! { get }
    var vertexCount: Int! { get }
}

class CustomMesh: Mesh {
    var vertices: [Vertex] = []
    var vertexBuffer: MTLBuffer!
    var vertexCount: Int! {
        return vertices.count
    }
    
    init() {
        createVertices()
        createBuffers()
    }
    
    func createVertices(){ }
    
    func createBuffers(){
        vertexBuffer = Engine.Device.makeBuffer(bytes: vertices, length: Vertex.stride(vertices.count), options: [])
    }
}
class Terrain_CustomMesh: CustomMesh {
    override func createVertices() {
        vertices = [
            Vertex(position: float3( 1, 1,0), color: float4(1,0,1,1),textureCoordinate: float2(1,0)), //Top Right
            Vertex(position: float3(-1, 1,0), color: float4(1,0,1,1),textureCoordinate: float2(0,0)), //Top Left
            Vertex(position: float3(-1,-1,0), color: float4(1,0,1,1),textureCoordinate: float2(0,1)),  //Bottom Left
            
            Vertex(position: float3( 1,1,0), color: float4(1,0,0,1),textureCoordinate: float2(1,0)), //Top Right
            Vertex(position: float3(-1,-1,0), color: float4(1,0,0,1),textureCoordinate: float2(0,1)), //Bottom Left
            Vertex(position: float3( 1, -1,0), color: float4(1,0,0,1),textureCoordinate: float2(1,1))  //Bottom Right
        ]
    }
}
class Quad_CustomMesh: CustomMesh {
    override func createVertices() {
        vertices = [
            Vertex(position: float3( 1, 1,0), color: float4(1,0,0,1),textureCoordinate: float2(1,0)), //Top Right
            Vertex(position: float3(-1, 1,0), color: float4(1,0,0,1),textureCoordinate: float2(0,0)), //Top Left
            Vertex(position: float3(-1,-1,0), color: float4(1,0,0,1),textureCoordinate: float2(0,1)),  //Bottom Left
            
            Vertex(position: float3( 1, 1,0), color: float4(1,0,0,1),textureCoordinate: float2(1,0)), //Top Right
            Vertex(position: float3(-1,-1,0), color: float4(1,0,0,1),textureCoordinate: float2(0,1)), //Bottom Left
            Vertex(position: float3( 1,-1,0), color: float4(1,0,0,1),textureCoordinate: float2(1,1))  //Bottom Right
        ]
    }
}
