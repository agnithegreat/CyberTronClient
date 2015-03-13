/**
 * Created by kirillvirich on 05.03.15.
 */
package model.control {
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

import flash.geom.Point;
import flash.ui.Keyboard;

import model.entities.Hero;
import model.properties.PersonageProps;

import starling.animation.IAnimatable;
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

    private var _requestCounter: int = 0;
    public function get requestCounter():int {
        return _requestCounter;
    }
    public function set requestCounter(value: int):void {
        _requestCounter = value;
    }

    public function UserControl() {
    }

    public function init(hero: Hero):void {
        _hero = hero;
    }

    public function advanceTime(time:Number):void {
        _requestCounter++;

        var left: Boolean = KeyLogger.getKey(Keyboard.A) || KeyLogger.getKey(Keyboard.LEFT);
        var right: Boolean = KeyLogger.getKey(Keyboard.D) || KeyLogger.getKey(Keyboard.RIGHT);
        var up: Boolean = KeyLogger.getKey(Keyboard.W) || KeyLogger.getKey(Keyboard.UP);
        var down: Boolean = KeyLogger.getKey(Keyboard.S) || KeyLogger.getKey(Keyboard.DOWN);

        var deltaX: int = int(right) - int(left);
        var deltaY: int = int(down)  - int(up);

        if (_deltaX != deltaX || _deltaY != deltaY) {
            _deltaX = deltaX;
            _deltaY = deltaY;

            var params:ISFSObject = new SFSObject();
            params.putInt(PersonageProps.REQ_ID, _requestCounter);
            params.putInt(PersonageProps.DELTAX, _deltaX);
            params.putInt(PersonageProps.DELTAY, _deltaY);
            dispatchEventWith(MOVE, false, params);
        }

        if (!_hero) {
            return;
        }

        var touch: Point = TouchLogger.getTouchByName("field");
        var dx: Number = touch.x - _hero.x;
        var dy: Number = touch.y - _hero.y;
        var direction: Number = Math.atan2(dy, dx);

        if (_direction != direction) {
            _direction = direction;

            params = new SFSObject();
            params.putInt(PersonageProps.REQ_ID, _requestCounter);
            params.putFloat(PersonageProps.DIRECTION, _direction);
            dispatchEventWith(ROTATE, false, params);
        }

        if (_isShooting != TouchLogger.isTouching) {
            _isShooting = TouchLogger.isTouching;

            params = new SFSObject();
            params.putInt(PersonageProps.REQ_ID, _requestCounter);
            params.putBool(PersonageProps.SHOOT, _isShooting);
            dispatchEventWith(SHOT, false, params);
        }
    }
}
}
