/**
 * Created by kirillvirich on 05.03.15.
 */
package utils {
import flash.geom.Point;

import starling.display.Stage;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class TouchLogger {

    private static var _stage: Stage;

    private static var _touch: Point;
    public static function getTouch():Point {
        return _touch;
    }

    public static function init(stage: Stage):void {
        _stage = stage;
        _stage.addEventListener(TouchEvent.TOUCH, onTouch);

        _touch = new Point();
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
            }
        }
    }
}
}
