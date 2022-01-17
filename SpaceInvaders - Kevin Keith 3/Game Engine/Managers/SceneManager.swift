//
//  TextureLibrary.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-28.
//

import MetalKit
import SpriteKit

enum SceneTypes{
    case Sandbox
}

class SceneManager{
    private static var _currentScene: Scene!
    
    public static func Initialize(_ sceneType: SceneTypes){
        SetScene(sceneType)
    }
    public static func maskRender(renderCommandEncoder: MTLRenderCommandEncoder){
        //Draw to a texture
        //Different colors
        
    }
    public static func SetScene(_ sceneType: SceneTypes){
        switch sceneType {
        case .Sandbox:
            _currentScene = MainGameScene()
        }
    }
    public static func PlayerMaskRender(renderCommandEncoder: MTLRenderCommandEncoder){
        _currentScene.playerMaskRender(renderCommandEncoder: renderCommandEncoder)
    }
    public static func RenderEnemies(renderCommandEncoder: MTLRenderCommandEncoder){
        _currentScene.renderEnemies(renderCommandEncoder: renderCommandEncoder)
    }
    public static func BulletMaskRender(renderCommandEncoder: MTLRenderCommandEncoder){
        _currentScene.bulletMaskRender(renderCommandEncoder: renderCommandEncoder)
    }
    public static func Render(renderCommandEncoder: MTLRenderCommandEncoder){
        _currentScene.render(renderCommandEncoder: renderCommandEncoder)
    }
    
    public static func Update(){
        _currentScene.update()
    }
    
}
