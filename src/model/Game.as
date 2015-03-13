/**
 * Created by kirillvirich on 12.03.15.
 */
package model {
import com.smartfoxserver.v2.entities.User;

import flash.utils.Dictionary;

import model.entities.Bullet;
import model.entities.Enemy;
import model.entities.Hero;
import model.properties.BulletProps;

import model.properties.GlobalProps;
import model.properties.MonsterProps;
import model.properties.PersonageProps;

import starling.events.EventDispatcher;

public class Game extends EventDispatcher {

    public static const ADD_HERO: String = "add_hero_Game";
    public static const ADD_ENEMY: String = "add_enemy_Game";
    public static const ADD_BULLET: String = "add_bullet_Game";

    public static const REMOVE_HERO: String = "remove_hero_Game";
    public static const REMOVE_ENEMY: String = "remove_enemy_Game";
    public static const REMOVE_BULLET: String = "remove_bullet_Game";

    private var _heroes: Dictionary;
    public function getHero(id: int):Hero {
        return _heroes[id];
    }

    private var _enemies: Dictionary;
    public function getEnemy(id: int):Enemy {
        return _enemies[id];
    }

    private var _bullets: Dictionary;
    public function getBullet(id: int):Bullet {
        return _bullets[id];
    }

    public function Game() {
        _heroes = new Dictionary(true);
        _enemies = new Dictionary(true);
        _bullets = new Dictionary(true);
    }

    public function addHero(user: User):void {
        var hero: Hero = new Hero(GlobalProps.hero);
        hero.id = user.id;
        hero.color = user.getVariable(PersonageProps.COLOR).getIntValue();
        hero.name = user.name;
        _heroes[hero.id] = hero;

        dispatchEventWith(ADD_HERO, false, hero);
    }
    public function addEnemy(data: Object):void {
        var enemy: Enemy = new Enemy(GlobalProps.getEnemy("monster"));
        enemy.id = data.id;
        enemy.color = 0xFF0000;
        _enemies[enemy.id] = enemy;

        dispatchEventWith(ADD_ENEMY, false, enemy);
    }
    public function addBullet(data: Object):void {
        var bullet: Bullet = new Bullet(GlobalProps.getWeapon("m4"));
        bullet.id = data.id;
        bullet.color = getHero(data.user).color;
        _bullets[bullet.id] = bullet;

        dispatchEventWith(ADD_BULLET, false, bullet);
    }


    public function updateHero(user: User):void {
        var hero: Hero = getHero(user.id);
        hero.x = user.getVariable(PersonageProps.POSX).getIntValue();
        hero.y = user.getVariable(PersonageProps.POSY).getIntValue();
        if (user.getVariable(PersonageProps.DIRECTION)) {
            hero.direction = user.getVariable(PersonageProps.DIRECTION).getDoubleValue();
        }
        hero.update();
    }
    public function updateEnemy(data: Object):void {
        var monster: Enemy = getEnemy(data.id);
        monster.x = data[MonsterProps.POSX];
        monster.y = data[MonsterProps.POSY];
        monster.direction = data[MonsterProps.DIRECTION];
        monster.update();
    }
    public function updateBullet(data: Object):void {
        var bullet: Bullet = getBullet(data.id);
        bullet.x = data[BulletProps.POSX];
        bullet.y = data[BulletProps.POSY];
        bullet.direction = data[BulletProps.DIRECTION];
        bullet.update();
    }


    public function removeHero(id: int):void {
        var hero: Hero = _heroes[id];
        hero.destroy();
        delete _heroes[id];

        dispatchEventWith(REMOVE_HERO, false, hero);
    }
    public function removeEnemy(id: int):void {
        var enemy: Enemy = _enemies[id];
        enemy.destroy();
        delete _enemies[id];

        dispatchEventWith(REMOVE_ENEMY, false, enemy);
    }
    public function removeBullet(id: int):void {
        var bullet: Bullet = _bullets[id];
        bullet.destroy();
        delete _bullets[id];

        dispatchEventWith(REMOVE_BULLET, false, bullet);
    }


    public function clearHeroes():void {
        for (var id: int in _heroes) {
            removeHero(id);
        }
    }
    public function clearEnemies(except: Dictionary):void {
        for (var id: int in _enemies) {
            if (!except[id]) {
                removeEnemy(id);
            }
        }
    }
    public function clearBullets(except: Dictionary):void {
        for (var id: int in _bullets) {
            if (!except[id]) {
                removeBullet(id);
            }
        }
    }
}
}
