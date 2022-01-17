//
//  Renderer.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-28.
//
import MetalKit
import SpriteKit

class Renderer: NSObject {
    public static var ScreenSize = float2(0,0)
    public static var AspectRatio: Float { return ScreenSize.x / ScreenSize.y }
    private var terrainMaskDescriptor : MTLRenderPassDescriptor!
    private var bulletMaskDescriptor : MTLRenderPassDescriptor!
    private var playerMaskDescriptor : MTLRenderPassDescriptor!
    private var secondRenderPassDesc: MTLRenderPassDescriptor!
    private var destroyedTerrainPassDesc: MTLRenderPassDescriptor!
    private var RenderAllDescriptor: MTLRenderPassDescriptor!
    
    init(mtkView: MTKView){
        super.init()
        self.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        
        SamplerStateLibrary.Initialize()
        
        terrainMaskDescriptor = createMaskRenderPass(textureType: .TerrainMask)
        bulletMaskDescriptor = createMaskRenderPass(textureType: .MissileMask)
        playerMaskDescriptor = createMaskRenderPass(textureType: .Player)
        createDestroyedTerrainTex()
        RenderAllDescriptor = createMaskRenderPass(textureType: .FinalRenderPass)
    }
    
    private func createMaskRenderPass(textureType: TextureTypes)->MTLRenderPassDescriptor{ //Applies to all of the renders before
        var renderPassDescriptor : MTLRenderPassDescriptor!
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: Preferences.MainPixelFormat,
                                                                         width: Int(Renderer.ScreenSize.x),
                                                                         height: Int(Renderer.ScreenSize.y),
                                                                         mipmapped: false)
        
        textureDescriptor.usage = [
            .renderTarget,
            .shaderRead
        ]
        TextureLibrary.setTexture(textType: textureType, texture: Engine.Device.makeTexture(descriptor: textureDescriptor)!)
        
        renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = TextureLibrary.getTexture(textureType)
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        return renderPassDescriptor
    }
    private func createDestroyedTerrainTex(){
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: Preferences.MainPixelFormat,
                                                                         width: Int(Renderer.ScreenSize.x),
                                                                         height: Int(Renderer.ScreenSize.y),
                                                                         mipmapped: false)
        textureDescriptor.usage = [
            .shaderRead,
            .shaderWrite
        ]
        TextureLibrary.setTexture(textType: .DestroyedMask, texture: Engine.Device.makeTexture(descriptor: textureDescriptor)!)
        
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeComputeCommandEncoder()
        let device = Engine.Device
        let gpuFunctionlibrary = device?.makeDefaultLibrary()
        let gpuFunction = gpuFunctionlibrary?.makeFunction(name: "Transparency")
        var computePipelineState: MTLComputePipelineState!
        do{
            computePipelineState = try device?.makeComputePipelineState(function: gpuFunction as! MTLFunction)
        }
        catch{
            print(error)
        }
        
        let missile = TextureLibrary.getTexture(.MissileMask)
        let terrain = TextureLibrary.getTexture(.TerrainMask)
        let result = TextureLibrary.getTexture(.DestroyedMask)!
        
        commandEncoder?.setTexture(terrain, index: 0)
        commandEncoder?.setTexture(missile, index: 1)
        commandEncoder?.setTexture(result, index: 2)
        
        
        commandEncoder?.endEncoding()
        commandBuffer?.commit()
        commandBuffer?.waitUntilCompleted()
        
        
        TextureLibrary.setTexture(textType: .DestroyedMask, texture: result)
        
        
    }
}

extension Renderer: MTKViewDelegate{
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        //When the window is resized
        Renderer.ScreenSize = float2(Float(size.width), Float(size.height))
    }
    func draw(in view: MTKView) {
        GameTime.UpdateTime(1 / Float(view.preferredFramesPerSecond)) //Updates game time
        
        SceneManager.Update() //No drawing in the update
        //Updates the game object
        //Before update, get keyinput
        //Use Event manager to listen into key presses
        MissileMaskRender()
        TerrainMaskRender()  //This sets up the base logic and scene
        PlayerMaskRender()
        GenerateDestroyedTerrain()
        RenderAll()
        LastRender(view: view) // This displays the final product
    }
    func GenerateDestroyedTerrain(){
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()!
        commandBuffer.label = "Destroyed Terrain Mask"
        let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: terrainMaskDescriptor)!
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Mask))
        SceneManager.RenderEnemies(renderCommandEncoder: renderCommandEncoder)
        renderCommandEncoder.endEncoding()
        commandBuffer.commit()
    }
    func PlayerMaskRender(){
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()!
        commandBuffer.label = "Player Mask"
        let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: playerMaskDescriptor)!
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Mask))
        SceneManager.PlayerMaskRender(renderCommandEncoder: renderCommandEncoder)
        renderCommandEncoder.endEncoding()
        commandBuffer.commit()
    }
    //Render what we want to compare
    func TerrainMaskRender(){ //This creates the basic scene
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()!
        commandBuffer.label = "Terrain Mask"
        let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: terrainMaskDescriptor)!
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Mask))
        SceneManager.RenderEnemies(renderCommandEncoder: renderCommandEncoder)
        renderCommandEncoder.endEncoding()
        commandBuffer.commit()
    }
    func MissileMaskRender(){ //This creates the basic scene
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()!
        commandBuffer.label = "Missile Mask"
        let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: bulletMaskDescriptor)!
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Mask))
        SceneManager.BulletMaskRender(renderCommandEncoder: renderCommandEncoder)
        renderCommandEncoder.endEncoding()
        commandBuffer.commit()
    }
    func RenderAll(){
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()!
        commandBuffer.label = "RenderAll"
        let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: RenderAllDescriptor)!
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        SceneManager.Render(renderCommandEncoder: renderCommandEncoder)
        renderCommandEncoder.endEncoding()
        commandBuffer.commit()
    }
    func LastRender(view : MTKView){
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()!
        let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        let finalMesh = MeshLibrary.Mesh(.Quad_Custom)
        
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Final))
        renderCommandEncoder.setVertexBuffer(finalMesh.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.setFragmentTexture(TextureLibrary.getTexture(.FinalRenderPass), index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: finalMesh.vertexCount)
        
        renderCommandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
