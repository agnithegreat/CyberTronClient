/**
 * Created by kirillvirich on 12.03.15.
 */
package model {
import flash.utils.Dictionary;

import model.entities.Base;
import model.entities.Bullet;
import model.entities.Enemy;
import model.entities.Hero;
import model.entities.Tower;
import model.entities.Wall;
import model.entities.Weapon;

import model.properties.BulletProps;
import model.properties.GlobalProps;
import model.properties.LevelProps;
import model.properties.MonsterProps;
import model.properties.PersonageProps;

import starling.events.EventDispatcher;

public class Game extends EventDispatcher {

    public static const SET_BASE: String = "set_base_Game";

    public static const ADD_WALL: String = "add_wall_Game";
    public static const ADD_TOWER: String = "add_tower_Game";
    public static const ADD_HERO: String = "add_hero_Game";
    public static const ADD_ENEMY: String = "add_enemy_Game";
    public static const ADD_BULLET: String = "add_bullet_Game";

    public static const REMOVE_HERO: String = "remove_hero_Game";
    public static const REMOVE_ENEMY: String = "remove_enemy_Game";
    public static const REMOVE_BULLET: String = "remove_bullet_Game";

    private var _base: Base;
    public function get base():Base {
        return _base;
    }

    private var _walls: Dictionary;
    private var _towers: Dictionary;

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
        _walls = new Dictionary(true);
        _towers = new Dictionary(true);
        _heroes = new Dictionary(true);
        _enemies = new Dictionary(true);
        _bullets = new Dictionary(true);
    }

    public function init():void {
        setBase(LevelProps.base);

        return;

        for (var i:int = 0; i < LevelProps.walls.length; i++) {
            var wall: Object = LevelProps.walls[i];
            wall.id = i;
            addWall(wall);
        }

        for (i = 0; i < LevelProps.towers.length; i++) {
            var tower: Object = LevelProps.towers[i];
            tower.id = i;
            addTower(tower);
        }
    }

    public function setBase(data: Object):void {
        _base = new Base(data);
        _base.x = data.x;
        _base.y = data.y;
        _base.width = data.width;
        _base.height = data.height;

        dispatchEventWith(SET_BASE, false, _base);
    }
    public function updateBase(hp: int):void {
        _base.hp = hp;
        _base.update();
    }

    public function addWall(data: Object):void {
        var wall: Wall = new Wall(null);
//        var wall: Wall = new Wall(GlobalProps.getWall());
        wall.id = data.id;
        wall.x = data.x;
        wall.y = data.y;
        wall.width = data.width;
        wall.height = data.height;
        _walls[wall.id] = wall;

        dispatchEventWith(ADD_WALL, false, wall);
    }
    public function addTower(data: Object):void {
        var tower: Tower = new Tower(null);
//        var tower: Tower = new Tower(GlobalProps.getTower());
        tower.id = data.id;
        tower.x = data.x;
        tower.y = data.y;
        tower.width = data.width;
        tower.height = data.height;
        _towers[tower.id] = tower;

        dispatchEventWith(ADD_TOWER, false, tower);
    }
    public function addHero(data: Object):void {
        var hero: Hero = new Hero(GlobalProps.hero);
        hero.id = data.id;
        hero.name = data.name;
        hero.color = data[PersonageProps.COLOR];
        hero.weapon = new Weapon(GlobalProps.getWeapon(data[PersonageProps.WEAPON]));
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
        bullet.color = data.user ? getHero(data.user).color : 0xFF000000;
        _bullets[bullet.id] = bullet;

        dispatchEventWith(ADD_BULLET, false, bullet);
    }


    public function updateHero(data: Object):void {
        var hero: Hero = getHero(data.id);
        if (data[PersonageProps.POSX]) {
            hero.x = data[PersonageProps.POSX];
        }
        if (data[PersonageProps.POSY]) {
            hero.y = data[PersonageProps.POSY];
        }
        if (data[PersonageProps.DIRECTION]) {
            hero.direction = data[PersonageProps.DIRECTION];
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
        if(!hero) return;
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
    public function clearEnemies(except: Dictionary = null):void {
        for (var id: int in _enemies) {
            if (!except || !except[id]) {
                removeEnemy(id);
            }
        }
    }
    public function clearBullets(except: Dictionary = null):void {
        for (var id: int in _bullets) {
            if (!except || !except[id]) {
                removeBullet(id);
            }
        }
    }
}
}
