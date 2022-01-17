//
//  Preferences.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-30.
//

import MetalKit

public enum ClearColors{
    static let White: MTLClearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let Green: MTLClearColor = MTLClearColor(red: 0.22, green: 0.55, blue: 0.34, alpha: 1.0)
    static let Grey: MTLClearColor = MTLClearColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    static let Black: MTLClearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let Blue: MTLClearColor =  MTLClearColor(red: 0, green: 0, blue: 1, alpha: 1)
}

class Preferences {
    
    public static var screenWidth: Float = 500
    
    public static var screenHeight: Float = 500
    
    public static var ClearColor: MTLClearColor = ClearColors.Blue
    
    public static var MainPixelFormat: MTLPixelFormat = MTLPixelFormat.bgra8Unorm_srgb
    
    public static var StartingSceneType: SceneTypes = SceneTypes.Sandbox
    
}
