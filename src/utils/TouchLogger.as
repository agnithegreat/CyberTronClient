/**
 * Created by kirillvirich on 05.03.15.
 */
package utils {
import flash.geom.Point;
import flash.utils.Dictionary;

import starling.display.DisplayObject;
import starling.display.Stage;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class TouchLogger {

    private static var _stage: DisplayObject;

    private static var _targets: Dictionary = new Dictionary(true);

    private static var _touch: Point;
    public static function getTouchByName(name: String):Point {
        var target: DisplayObject = _targets[name];
        return target ? target.globalToLocal(_touch) : null;
    }
    public static function getTouchByTarget(target: DisplayObject):Point {
        return target ? target.globalToLocal(_touch) : null;
    }

    private static var _touching: Boolean;
    public static function get isTouching():Boolean {
        return _touching;
    }

    public static function init(stage: Stage):void {
        _stage = stage;
        _stage.addEventListener(TouchEvent.TOUCH, onTouch);

        _touch = new Point();
    }

    public static function setTarget(name: String, target: DisplayObject):void {
        _targets[name] = target;
    }

    private static function onTouch(event: TouchEvent):void {
        var touch: Touch = event.getTouch(_stage);
        if (touch) {
            switch (touch.phase) {
                case TouchPhase.HOVER:
                case TouchPhase.MOVED:
                    var pos: Point = touch.getLocation(_stage);
                    _touch.x = pos.x;
                    _touch.y = pos.y;
                    break;
                case TouchPhase.BEGAN:
                    _touching = true;
                    break;
                case TouchPhase.ENDED:
                    _touching = false;
                    break;
            }
        }
    }
}
}
