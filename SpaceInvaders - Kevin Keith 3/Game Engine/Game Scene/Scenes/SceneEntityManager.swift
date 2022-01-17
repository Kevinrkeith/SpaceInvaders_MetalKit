//
//  SceneEntityManager.swift
//  Space Invaders
//
//  Created by Kevin Keith on 2022-01-02.
//

import Foundation
import Metal
class SceneEntityManager{
    
    private var players: [String : GameObject] = [:]
    
    private var enemyBullets: [String : GameObject] = [:]
    private var playerBullets: [String : GameObject] = [:]
    private var explosion: [String : GameObject] = [:]
    private var terrain: [String : GameObject] = [:]
    private var enemies: [String : GameObject] = [:]
    private var trail: [float3] = []
    
    
    func addEnemy(_ child: GameObject){
        enemies.updateValue(child, forKey: child.id)
    }
    func addExplosion(_ child: GameObject){
        players.updateValue(child, forKey: child.id)
    }
    func addPlayer(_ child: GameObject){
        players.updateValue(child, forKey: child.id)
    }
    func addEnemyBullet(_ child: GameObject){
        enemyBullets.updateValue(child, forKey: child.id)
    }
    func addPlayerBullet(_ child: GameObject){
        playerBullets.updateValue(child, forKey: child.id)
    }
    func addTerrain(_ child: GameObject){
        terrain.updateValue(child, forKey: child.id)
    }
    func addTrail(trail: float3){
        self.trail.append(trail)
    }
    func removePlayerMissile(id:String){
        playerBullets.removeValue(forKey: id)
    }
    
    func removeEnemyMissile(id: String){
        enemyBullets.removeValue(forKey: id)
    }
    func removeEnemy(id: String){
        enemies.removeValue(forKey: id)
    }
    func removeExplosion(){
        explosion.removeAll()
    }
    func clearAll(){
        enemyBullets.removeAll()
        enemies.removeAll()
    }
    func getEnemyBullets()->[GameObject]{
        return enemyBullets.values.map {$0}
    }
    func getPlayerBullets()->[GameObject]{
        return playerBullets.values.map {$0}
    }
    func getEnemies()->[GameObject]{
        return playerBullets.values.map {$0}
    }
    func updateAllEntities(){
        for (_, child) in self.terrain{
            child.update()
        }
        for (_, child) in self.explosion{
            child.update()
        }
        for (_, child) in self.playerBullets{
            child.update()
        }
        for (_, child) in self.enemies{
            child.update()
        }
        for (_, child) in self.players{
            child.update()
        }
        for(_,child) in self.playerBullets{
            child.update()
        }
        for (_, child) in self.enemyBullets{
            child.update()
        }
    }
    func renderTerrain(renderCommandEncoder: MTLRenderCommandEncoder){
        for (_, child) in self.terrain{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
    }
    func renderBullets(renderCommandEncoder: MTLRenderCommandEncoder){
        for (_, child) in self.enemyBullets{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
        for (_, child) in self.playerBullets{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
    }
    func renderPlayers(renderCommandEncoder: MTLRenderCommandEncoder){
        for (_, child) in players{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
    }
    func renderEnemies(renderCommandEncoder: MTLRenderCommandEncoder){
        for(_,child) in enemies{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
    }
    func renderAllEntities(renderCommandEncoder: MTLRenderCommandEncoder){
        for (_, child) in self.terrain{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
        for (_, child) in self.players{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
        for (_, child) in self.playerBullets{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
        for (_, child) in self.explosion{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
        for (_, child) in self.enemies{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
        for (_, child) in self.enemyBullets{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
    }
    func endGame()->Bool{
        return enemies.count<=0
    }
}
