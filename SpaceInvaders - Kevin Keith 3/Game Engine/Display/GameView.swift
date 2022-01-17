//
//  GameView.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-28.
//
import MetalKit

class GameView: MTKView {
    var vertices: [Vertex]!
    var vertexBuffer: MTLBuffer!
    
    
    var renderer: Renderer!
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        
        Engine.StartEngine(device: device!)
        
        self.clearColor = Preferences.ClearColor
        
        self.colorPixelFormat = Preferences.MainPixelFormat
        
        self.renderer = Renderer(mtkView: self)
        
        self.delegate = renderer
    }
    
    //Mouse Input
    
    //Keyboard Input
    override var acceptsFirstResponder: Bool {return true }
    
    override func keyDown(with event: NSEvent) {
        KeyBoard.SetKeyPressed(event.keyCode, isOn: true)
    }
    override func keyUp(with event: NSEvent) {
        KeyBoard.SetKeyPressed(event.keyCode, isOn: false)
    }
}

