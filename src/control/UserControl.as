/**
 * Created by kirillvirich on 05.03.15.
 */
package control {
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

import flash.geom.Point;
import flash.ui.Keyboard;

import model.Properties;

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

    private var _shotCooldown: Number = 0;

    public function UserControl() {
    }

    public function init(user: DisplayObject):void {
        _user = user;
    }

    public function advanceTime(time:Number):void {
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
            params.putInt(Properties.VAR_DELTAX, _deltaX * 80);
            params.putInt(Properties.VAR_DELTAY, _deltaY * 80);
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
            params.putFloat(Properties.VAR_DIRECTION, _direction);
            dispatchEventWith(App.ROTATE_USER_EVT, true, params);
        }


        _shotCooldown -= time;

        if (_shotCooldown <= 0 && TouchLogger.isTouching) {
            _shotCooldown = 0.3;

            params = new SFSObject();
            params.putFloat(Properties.VAR_DIRECTION, _direction);
            dispatchEventWith(App.SHOT_USER_EVT, true, params);
        }
    }
}
}
