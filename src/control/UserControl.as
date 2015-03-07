/**
 * Created by kirillvirich on 05.03.15.
 */
package control {
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

import flash.geom.Point;
import flash.ui.Keyboard;

import model.PersonageProps;

import starling.animation.IAnimatable;
import starling.display.DisplayObject;
import starling.events.EventDispatcher;

import utils.KeyLogger;
import utils.TouchLogger;

public class UserControl extends EventDispatcher implements IAnimatable {

    private static const local: Point = new Point();

    private var _user: DisplayObject;

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

    public function init(user: DisplayObject):void {
        _user = user;
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
            dispatchEventWith(App.MOVE_USER_EVT, true, params);
        }


        if (!_user) {
            return;
        }

        var place: Point = _user.localToGlobal(local);
        var dx: Number = TouchLogger.touch.x - place.x;
        var dy: Number = TouchLogger.touch.y - place.y;
        var direction: Number = Math.atan2(dy, dx);

        if (_direction != direction) {
            _direction = direction;

            params = new SFSObject();
            params.putInt(PersonageProps.REQ_ID, _requestCounter);
            params.putFloat(PersonageProps.DIRECTION, _direction);
            dispatchEventWith(App.ROTATE_USER_EVT, true, params);
        }

        if (_isShooting != TouchLogger.isTouching) {
            _isShooting = TouchLogger.isTouching;

            params = new SFSObject();
            params.putInt(PersonageProps.REQ_ID, _requestCounter);
            params.putBool(PersonageProps.SHOOT, _isShooting);
            dispatchEventWith(App.SHOT_USER_EVT, true, params);
        }
    }
}
}
