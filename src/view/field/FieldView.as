/**
 * Created by desktop on 02.03.2015.
 */
package view.field {
import assets.gui.FieldContainerView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Scale9Picture;

import flash.utils.Dictionary;

import model.entities.Base;
import model.entities.Hero;
import model.entities.Bullet;
import model.entities.Enemy;

import model.Game;

import starling.events.Event;

import utils.TouchLogger;

public class FieldView extends AbstractComponent {

    public function get back():Scale9Picture {
        return getChild("back") as Scale9Picture;
    }

    override public function set width(value: Number):void {
        back.width = value;
    }
    override public function get width():Number {
        return back.width;
    }

    override public function set height(value: Number):void {
        back.height = value;
    }
    override public function get height():Number {
        return back.height;
    }

    private var _game: Game;

    private var _base: BaseView;

    private var _personages: Dictionary = new Dictionary(true);
    private var _enemies: Dictionary = new Dictionary(true);
    private var _bullets: Dictionary = new Dictionary(true);

    private var _staticContainer: AbstractComponent;
    private var _dynamicContainer: AbstractComponent;

    public function FieldView() {

    }

    override protected function initialize():void {
        createFromFlash(FieldContainerView, "gui");

        _staticContainer = new AbstractComponent();
        addChild(_staticContainer);

        _dynamicContainer = new AbstractComponent();
        addChild(_dynamicContainer);

        TouchLogger.setTarget("field", this);
    }

    public function init(game: Game):void {
        _game = game;

        _game.addEventListener(Game.SET_BASE, handleSetBase);

        _game.addEventListener(Game.ADD_HERO, handleAddHero);
        _game.addEventListener(Game.ADD_ENEMY, handleAddEnemy);
        _game.addEventListener(Game.ADD_BULLET, handleAddBullet);

        _game.addEventListener(Game.REMOVE_HERO, handleRemoveHero);
        _game.addEventListener(Game.REMOVE_ENEMY, handleRemoveEnemy);
        _game.addEventListener(Game.REMOVE_BULLET, handleRemoveBullet);
    }

    private function handleSetBase(e: Event):void {
        _base = new BaseView(e.data as Base);
        _staticContainer.addChild(_base);
    }

    private function handleAddHero(e: Event):void {
        var hero: Hero = e.data as Hero;
        _personages[hero] = new HeroView(hero);
        _dynamicContainer.addChild(_personages[hero]);
    }

    private function handleAddEnemy(e: Event):void {
        var enemy: Enemy = e.data as Enemy;
        _enemies[enemy] = new EnemyView(enemy);
        _dynamicContainer.addChild(_enemies[enemy]);
    }

    private function handleAddBullet(e: Event):void {
        var bullet: Bullet = e.data as Bullet;
        _bullets[bullet] = new BulletView(bullet);
        _dynamicContainer.addChild(_bullets[bullet]);
    }

    private function handleRemoveHero(e: Event):void {
        var hero: Hero = e.data as Hero;
        (_personages[hero] as HeroView).destroy();
        delete _personages[hero];
    }

    private function handleRemoveEnemy(e: Event):void {
        var enemy: Enemy = e.data as Enemy;
        (_enemies[enemy] as EnemyView).destroy();
        delete _enemies[enemy];
    }

    private function handleRemoveBullet(e: Event):void {
        var bullet: Bullet = e.data as Bullet;
        (_bullets[bullet] as BulletView).destroy();
        delete _bullets[bullet];
    }
}
}
