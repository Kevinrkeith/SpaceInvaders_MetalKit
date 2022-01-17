//
//  GameTime.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-30.
//
import MetalKit
public enum ObjectTypes{
    case Player
    case Bullet
    case Gun
}
public struct HitBox {
    var positionX : Float!
    var positionY : Float!
    var width: Float!
    var height: Float!
}
public struct CircleCollider{
    var positionX : Float!
    var positionY : Float!
    var width : Float!
    var height : Float!
    var radius : Float!
}
class GameObject: Node {
    
    public var velocity: Float!
    
    var score: Int = 0
    
    var modelConstants = ModelConstants()
    
    var mesh: Mesh!
    
    var objectType: ObjectTypes!
    
    let vertices: [Vertex] = []
    
    var texture: MTLTexture!
    
    public var hitBox = HitBox()
    
    private var material = Material()
    private var textureType: TextureTypes = TextureTypes.None
    
    init(meshType: MeshTypes) {
        mesh = MeshLibrary.Mesh(meshType)
    }
    override func update(){
        updateModelConstants()
    }
    public func getHitBox()->HitBox{
        return hitBox
    }
    func updateModelConstants(){
        modelConstants.modelMatrix = self.modelMatrix
    }
    func getPixels()->UnsafeMutablePointer<Float32>{
        
        let pixels: UnsafeMutablePointer<Float32> = texture.getPixels()
        print(pixels)
        return pixels
    }
}

extension GameObject: Renderable{
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.pushDebugGroup("Rendering Object \(self.name)")
        //Vertex Shader
        renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.setFragmentBytes(&material, length: Material.stride, index: 1)
        renderCommandEncoder.setFragmentSamplerState(SamplerStateLibrary.samplers[.Linear], index: 0)
        
        if(material.useTexture){
            renderCommandEncoder.setFragmentTexture(texture, index: 0)
        }
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: mesh.vertexCount)
        renderCommandEncoder.popDebugGroup()
    }
}
protocol Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder)
}

extension GameObject {
    public func setColor(_ color: float4){
        self.material.color = color
        self.material.useMaterialColor = true
        self.material.useTexture = false
    }
    
    public func setTexture(_ textureType: TextureTypes) {
        self.textureType = textureType
        self.material.useTexture = true
        self.material.useMaterialColor = false
    }
}
extension MTLTexture {
  func getPixels<T> (_ region: MTLRegion? = nil, mipmapLevel: Int = 0) -> UnsafeMutablePointer<T> {
    let fromRegion  = region ?? MTLRegionMake2D(0, 0, self.width, self.height)
    let width       = fromRegion.size.width
    let height      = fromRegion.size.height
    let bytesPerRow = MemoryLayout<T>.stride * width
    let data        = UnsafeMutablePointer<T>.allocate(capacity: bytesPerRow * height)

    self.getBytes(data, bytesPerRow: bytesPerRow, from: fromRegion, mipmapLevel: mipmapLevel)
    return data
  }
}
