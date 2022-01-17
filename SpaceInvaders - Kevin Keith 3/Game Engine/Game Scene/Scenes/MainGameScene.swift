//
//  MainGameScene.swift
//  Game Engine
//
//  Created by Kevin Keith on 2021-12-30.
//

import MetalKit
import GameplayKit


protocol SceneExtender {
    func buildSpriteScene()
}
//Create Base World
//Go for 500/500 image
//
class MainGameScene: Scene{
    var playerTurn:Int = 0
    var timer: Float = 0
    var angle: Float = 0
    var missile: Missile!
    var force: Float = 15
    var direction : Float = 1
    var isLaunched: Bool = false
    var canMoveDown: Bool = false
    let map = SKNode()
    var startTimer = false
    var player  = Player()
    var enemies : [GameObject] = []
    var Missiles : [Missile] = []
    var explosion: [Explosion] = []
    var playerHealth : [GameObject] = []
    var entityManager = SceneEntityManager()
    var moveTimer : Float = 3
    var lastTimer : Float = 3
    var randomTimer : Float!
    var explodeTimer : Float = 0
    var coolDown: Float = 0.2
    var isDead =  false
    var moveSpace : Float = 6000
    private var velocity : Float = 50
    private var minX : Float = -54300.0
    private var maxX : Float =  54300.0
    private var playerHitBox : [HitBox] = []
    private var missileHitBox = HitBox()
    private var isGameOver = false
    var playerScore : Int = 0
    var timesBeaten : Int = 0
    //Game Object List
    override func buildScene() {
        player.position =  float3(0, -50000,0)
        player.rotation.y = 0
        player.scale = float3(2500,2500,0)
        entityManager.addPlayer(player)
        randomTimer = 0.4
        for i in 0..<3{
            var health = Health()
            health.position = float3(51000, 50000-Float(i*6000),0)
            health.scale = float3(2000,2000,0)
            playerHealth.append(health)
        }
        for i in 0..<11{
            var enemy = Enemy(textureType: .Enemy3)
            enemy.position = float3(minX  + Float(i) * 6000, 50000, 0)
            enemy.scale = float3(2500,2500,0)
            enemy.score = 800
            enemies.append(enemy)
            entityManager.addEnemy(enemy)
        }
        for i in 0..<11{
            var enemy = Enemy(textureType: .Enemy2)
            enemy.position = float3(minX + Float(i) * 6000, 44000, 0)
            enemy.scale = float3(2500,2500,0)
            enemy.score = 400
            enemies.append(enemy)
            entityManager.addEnemy(enemy)
        }
        for i in 0..<11{
            var enemy = Enemy(textureType: .Enemy2)
            enemy.position = float3(minX + Float(i) * 6000, 39000, 0)
            enemy.scale = float3(2500,2500,0)
            enemy.score = 400
            enemies.append(enemy)
            entityManager.addEnemy(enemy)
        }
        for i in 0..<11{
            var enemy = Enemy(textureType: .Enemy1)
            enemy.position = float3(minX + Float(i) * 6000, 34000, 0)
            enemy.scale = float3(2500,2500,0)
            enemy.score = 200
            enemies.append(enemy)
            entityManager.addEnemy(enemy)
        }
        for i in 0..<11{
            var enemy = Enemy(textureType: .Enemy1)
            enemy.score = 200
            enemy.position = float3(minX + Float(i) * 6000, 29000, 0)
            enemy.scale = float3(2500,2500,0)
            enemies.append(enemy)
            entityManager.addEnemy(enemy)
        }
    }
    func gameOver(){
        print("")
        print("")
        print("")
        print("")
        print("Player Scored: " , playerScore)
        print("times reset: " , timesBeaten)
        print("Game Over!")
        exit(0)
    }
    override func update() {
        let deltaTime : Float = GameTime.DeltaTime
        let randomEnemy : Int = Int.random(in: 0..<enemies.capacity)
        if(entityManager.endGame()){
            gameOver()
        }
        if(KeyBoard.IsKeyPressed(.escape) || player.playerHealth <= 0||IsGameOver()||enemies.isEmpty){
            gameOver()
        }
        if(KeyBoard.IsKeyPressed(.rightArrow) && !isDead){
            player.position.x +=  25000 * deltaTime
        }
        if(KeyBoard.IsKeyPressed(.leftArrow) && !isDead){
            player.position.x -=  25000 * deltaTime
        }
        if (KeyBoard.IsKeyPressed(.space) && coolDown<0 && !isDead){
            var missile = Missile()
            missile.position = player.position
            missile.position = player.position
            missile.scale = float3(2000,200,100)
            missile.setDirection(direction: 1)
            entityManager.addPlayerBullet(missile)
            coolDown = 0.6
        }
        if(moveTimer<=0){
            var temp = moveDown()
            for enemy in enemies {
                if(temp){
                    enemy.position.y -= 6000
                }else{
                    enemy.position.x += 6000 * direction
                    canMoveDown = true
                }
            }
            if(temp){
                direction *= -1
            }
            moveTimer = lastTimer
        }
        
        if(randomTimer<0){
            var missile = Missile()
            var enemy = enemies.randomElement()!
            missile.position = enemy.position
            missile.scale = float3(2000,200,100)
            missile.setDirection(direction: -1)
            entityManager.addEnemyBullet(missile)
            randomTimer = Float.random(in: 0..<4)
        }
        if(explodeTimer<0){
            if(isDead){
                isDead = false
                player.position = float3(0, -50000,0)
                player.playerHealth -= 1
                explosion.removeAll()
            }
        }
        entityManager.updateAllEntities()
        for missile in entityManager.getEnemyBullets(){
            if(checkCollision(hitBox: player.hitBox, hitBox2: missile.hitBox) && !isDead){
                entityManager.removeEnemyMissile(id: missile.id)
                isDead = true
                var explode = Explosion()
                explode.position = player.position
                explode.scale = player.scale
                explosion.append(explode)
                explodeTimer  = 2
                playerHealth.removeLast()
            }
        }
        for missile in entityManager.getPlayerBullets(){
            var remove = -1
            for i  in 0..<enemies.count{
                if(checkCollision(hitBox: enemies[i].hitBox, hitBox2: missile.hitBox)){
                    playerScore += enemies[i].score
                    entityManager.removeEnemy(id: enemies[i].id)
                    entityManager.removePlayerMissile(id: missile.id)
                    remove = i
                    lastTimer -= 0.03636363636
                    break
                }
            }
            if(remove>0){
                enemies.remove(at: remove)
            }
        }
        for explosion in self.explosion {
            explosion.update()
        }
        for health in playerHealth {
            health.update()
        }
        explodeTimer -= deltaTime
        moveTimer -= deltaTime
        randomTimer -= deltaTime
        coolDown -= deltaTime
        super.update()
    }
    func reset(){
        
    }
    func moveDown()->Bool{
        for enemy in enemies {
            if((enemy.position.x>=maxX && canMoveDown)||(enemy.position.x<=minX && canMoveDown)){
                canMoveDown = false
                return true
            }
        }
        return false
    }
    override func renderEnemies(renderCommandEncoder: MTLRenderCommandEncoder) {
        super.render(renderCommandEncoder: renderCommandEncoder)
        entityManager.renderEnemies(renderCommandEncoder: renderCommandEncoder)
    }
    override func playerMaskRender(renderCommandEncoder: MTLRenderCommandEncoder) {
        super.playerMaskRender(renderCommandEncoder: renderCommandEncoder)
        entityManager.renderPlayers(renderCommandEncoder: renderCommandEncoder)
    }
    override func bulletMaskRender(renderCommandEncoder: MTLRenderCommandEncoder) {
        super.render(renderCommandEncoder: renderCommandEncoder)
        entityManager.renderBullets(renderCommandEncoder: renderCommandEncoder)
    }
    override func render(renderCommandEncoder: MTLRenderCommandEncoder){
        super.render(renderCommandEncoder: renderCommandEncoder)
        entityManager.renderAllEntities(renderCommandEncoder: renderCommandEncoder)
        for i in explosion{
            i.render(renderCommandEncoder: renderCommandEncoder)
        }
        for health in playerHealth {
            health.render(renderCommandEncoder: renderCommandEncoder)
        }
    }
    func IsGameOver()->Bool{
        for enemy in enemies {
            if(enemy.position.y <= player.position.y){
                return true
            }
        }
        return false
    }
    //AABB collision
    func checkCollision(hitBox: HitBox, hitBox2: HitBox)->Bool{
        
        
        //check x collision
        if(hitBox.positionX<hitBox2.positionX+hitBox2.width &&
           hitBox.positionX+hitBox.width>hitBox2.positionX &&
           hitBox.positionY<hitBox2.positionY+hitBox2.height &&
           hitBox.positionY+hitBox.height>hitBox2.positionY){
            return true
        }
        return false
    }
}


