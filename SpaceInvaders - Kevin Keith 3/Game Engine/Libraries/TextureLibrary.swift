//
//  TextureLibrary.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-28.
//

import Foundation
import Metal
import MetalKit

enum TextureTypes{
    case None
    case Sand
    case Grass
    case TerrainMask
    case MissileMask
    case playerMask
    case ExplosionMask
    case DestroyedMask
    case FirstPassTexture1
    case FinalRenderPass
    case Player
    case Enemy1
    case Enemy2
    case Enemy3
}

class TextureLibrary {
    private static var library: [TextureTypes : Texture] = [:]
    public static func Initialize(){
        fillLibrary()
    }
    private static func fillLibrary() {
        library.updateValue(Texture("Player"), forKey: .Player)
        library.updateValue(Texture("Enemy1"), forKey: .Enemy1)
        library.updateValue(Texture("Enemy2"), forKey: .Enemy2)
        library.updateValue(Texture("Enemy3"), forKey: .Enemy3)
    }
    public static func setTexture(textType: TextureTypes, texture: MTLTexture){
        library.updateValue(Texture(texture:texture), forKey: textType)
    }
    public static func getTexture(_ type: TextureTypes) -> MTLTexture? {
        return library[type]?.texture
    }
}
class Texture {
    public var texture: MTLTexture!
    private var _textureName: String!
    private var _textureExtension: String!
    private var _origin: MTKTextureLoader.Origin!
    
    init(_ textureName: String, ext: String = "png", origin: MTKTextureLoader.Origin = .topLeft){
        let textureLoader = TextureLoader(textureName: textureName, textureExtension: ext, origin: origin)
        let texture: MTLTexture = textureLoader.loadTextureFromBundle()
        
        setTexture(texture)
    }
    init(texture: MTLTexture){
        self.texture = texture
    }
    func setTexture(_ texture: MTLTexture){
        self.texture = texture
    }
}
class TextureLoader{
    
    private var _textureName: String!
    private var _textureExtension: String!
    private var _origin: MTKTextureLoader.Origin!
    init(textureName: String, textureExtension: String = "png", origin: MTKTextureLoader.Origin = .topLeft){
        self._textureName = textureName
        self._textureExtension = textureExtension
        self._origin = origin
    }
    public func loadTextureFromBundle()-> MTLTexture{
        var result: MTLTexture!
        if let url = Bundle.main.url(forResource: _textureName, withExtension: self._textureExtension) {
            let textureLoader = MTKTextureLoader(device: Engine.Device)
            
            let options: [MTKTextureLoader.Option : MTKTextureLoader.Origin] = [MTKTextureLoader.Option.origin : _origin]
            
            do{
                result = try textureLoader.newTexture(URL: url, options: options)
                result.label = _textureName
            }catch let error as NSError {
                print("ERROR::CREATING::TEXTURE::__\(_textureName!)__::\(error)")
            }
        }else {
            print("ERROR::CREATING::TEXTURE::__\(_textureName!) does not exist")
        }
        
        return result
    }
}
