/**
 * Created by kirillvirich on 05.03.15.
 */
package model.control {
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

import flash.geom.Point;
import flash.ui.Keyboard;

import model.entities.Hero;
import model.properties.BulletProps;
import model.properties.GlobalProps;
import model.properties.PersonageProps;

import starling.animation.IAnimatable;
import starling.core.Starling;
import starling.events.EventDispatcher;

import utils.KeyLogger;
import utils.TouchLogger;

public class UserControl extends EventDispatcher implements IAnimatable {

    public static const MOVE : String = "move_UserControl";
    public static const ROTATE : String = "rotate_UserControl";
    public static const SHOT : String = "shot_UserControl";

    private var _hero: Hero;

    private var _deltaX: int = 0;
    private var _deltaY: int = 0;

    private var _direction: Number;

    private var _isShooting: Boolean;

    private var _inputCounter: int;
    private var _pendingInputs: Vector.<Input>;

    public function get ready():Boolean {
        return _hero != null;
    }

    public function UserControl() {
    }

    public function init(hero: Hero):void {
        _hero = hero;

        if (_hero) {
            Starling.juggler.add(this);
        } else {
            Starling.juggler.remove(this);
        }

        _inputCounter = 0;
        _pendingInputs = new <Input>[];
    }

    public function removeProcessedInputs(counter: int):void {
        while (_pendingInputs.length > 0 && _pendingInputs[0].id <= counter) {
            _pendingInputs.shift();
        }
    }

    public function processPendingInputs():void {
        var l: int = _pendingInputs.length;
        for (var i:int = 0; i < l; i++) {
            processInput(_pendingInputs[i]);
        }
    }

    public function advanceTime(time:Number):void {
        _inputCounter++;

        var left: Boolean = KeyLogger.getKey(Keyboard.A) || KeyLogger.getKey(Keyboard.LEFT);
        var right: Boolean = KeyLogger.getKey(Keyboard.D) || KeyLogger.getKey(Keyboard.RIGHT);
        var up: Boolean = KeyLogger.getKey(Keyboard.W) || KeyLogger.getKey(Keyboard.UP);
        var down: Boolean = KeyLogger.getKey(Keyboard.S) || KeyLogger.getKey(Keyboard.DOWN);

        _deltaX = int(right) - int(left);
        _deltaY = int(down)  - int(up);

        var params:ISFSObject = new SFSObject();
        params.putInt(PersonageProps.REQ_ID, _inputCounter);
        params.putDouble(PersonageProps.TIME, time);
        params.putInt(PersonageProps.DELTAX, _deltaX);
        params.putInt(PersonageProps.DELTAY, _deltaY);
        dispatchEventWith(MOVE, false, params);


        var touch: Point = TouchLogger.getTouchByName("field");
        var dx: Number = touch.x - _hero.x;
        var dy: Number = touch.y - _hero.y;

        _direction = Math.atan2(dy, dx);

        params = new SFSObject();
        params.putInt(PersonageProps.REQ_ID, _inputCounter);
        params.putFloat(PersonageProps.DIRECTION, _direction);
        dispatchEventWith(ROTATE, false, params);


        _isShooting = TouchLogger.isTouching;

        _hero.weapon.cooldown -= time;
        if (_isShooting && _hero.weapon.cooldown <= 0) {
            if (_hero.weapon.ammo <= 0) {
                _hero.weapon.reload();
            }
            if (_hero.weapon.ammo > 0) {
                _hero.weapon.shot();

                var amount: int = _hero.weapon.getShotAmount();
                var angle: Number = _hero.weapon.getSpread() / amount;
                for (var i: int = 0; i < amount; i++) {
                    var direction: Number = _direction + (i - amount/2) * angle;

                    params = new SFSObject();
                    params.putInt(PersonageProps.REQ_ID, _inputCounter);
                    params.putInt(BulletProps.ID, ++_hero.weapon.counter);
                    params.putInt(BulletProps.USER, _hero.id);
                    params.putDouble(BulletProps.DIRECTION, direction);
                    dispatchEventWith(SHOT, false, params);
                }
            }
        }


        var input: Input = new Input();
        input.id = _inputCounter;
        input.time = time;
        input.deltaX = _deltaX;
        input.deltaY = _deltaY;
        input.direction = _direction;
        _pendingInputs.push(input);
        processInput(input);
    }

    private function processInput(input: Input):void {
        var distance: Number = Math.sqrt(input.deltaX*input.deltaX + input.deltaY*input.deltaY);
        if (distance > 0) {
            var delta: Number = GlobalProps.hero.speed/distance * input.time;
            _hero.x += input.deltaX * delta;
            _hero.y += input.deltaY * delta;
        }
        _hero.direction = input.direction;
        _hero.update();
    }
}
}

class Input {
    public var id: int;
    public var time: Number;

    public var deltaX: int;
    public var deltaY: int;
    public var direction: Number;
}