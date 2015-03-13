/**
 * Created by kirillvirich on 12.03.15.
 */
package model {
import com.smartfoxserver.v2.entities.User;

import flash.utils.Dictionary;

import model.entities.Bullet;
import model.entities.Enemy;
import model.entities.Hero;

import model.properties.GlobalProps;
import model.properties.PersonageProps;

import starling.events.EventDispatcher;

public class Game extends EventDispatcher {

    public static const ADD_HERO: String = "add_hero_Game";
    public static const ADD_ENEMY: String = "add_enemy_Game";
    public static const ADD_BULLET: String = "add_bullet_Game";

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
        _bullets[bullet.id] = bullet;

        dispatchEventWith(ADD_BULLET, false, bullet);
    }
}
}
