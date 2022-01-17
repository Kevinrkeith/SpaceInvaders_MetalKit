//
//  Keyboard.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-15.
//
//
import Foundation
import MetalKit

class KeyBoard{
    
    private static var KEY_COUNT: Int = 256
    private static var keys = [Bool].init(repeating: false, count: KEY_COUNT)
    public static func SetKeyPressed(_ keyCode: UInt16, isOn: Bool){
        keys[Int(keyCode)] = isOn
    }
    public static func IsKeyPressed(_ keyCode: KeyCode)->Bool{
        return keys[Int(keyCode.rawValue)]
    }
}
