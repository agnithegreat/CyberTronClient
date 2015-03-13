/**
 * Created by desktop on 02.03.2015.
 */
package view.field {
import assets.gui.FieldContainerView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Scale9Picture;

import flash.utils.Dictionary;

import model.entities.Bullet;
import model.entities.Enemy;
import model.Game;
import model.entities.Hero;

import starling.events.Event;

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

    private var _container: AbstractComponent;

    public function FieldView() {

    }

    override protected function initialize():void {
        createFromFlash(FieldContainerView, "gui");

        _base = new BaseView();
        addChild(_base);

        _container = new AbstractComponent();
        addChild(_container);
    }

    public function init(game: Game):void {
        _game = game;
        _game.addEventListener(Game.ADD_HERO, handleAddHero);
        _game.addEventListener(Game.ADD_ENEMY, handleAddEnemy);
        _game.addEventListener(Game.ADD_BULLET, handleAddBullet);
    }

    public function setBase(x: int, y: int, width: int, height: int):void {
        _base.x = x;
        _base.y = y;
        _base.width = width;
        _base.height = height;
    }

    private function handleAddHero(e: Event):void {
        var hero: Hero = e.data as Hero;
        _personages[hero] = new HeroView(hero);
        _container.addChild(_personages[hero]);
    }

    private function handleAddEnemy(e: Event):void {
        var enemy: Enemy = e.data as Enemy;
        _enemies[enemy] = new EnemyView(enemy);
        _container.addChild(_enemies[enemy]);
    }

    private function handleAddBullet(e: Event):void {
        var bullet: Bullet = e.data as Bullet;
        _bullets[bullet] = new BulletView(bullet);
        _container.addChild(_bullets[bullet]);
    }
}
}
