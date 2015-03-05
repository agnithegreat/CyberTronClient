/**
 * Created by kirillvirich on 05.03.15.
 */
package utils {
import flash.utils.Dictionary;

import starling.display.Stage;
import starling.events.KeyboardEvent;

public class KeyLogger {

    private static var _stage: Stage;

    private static var _activeKeys : Dictionary = new Dictionary(true);
    public static function getKey(key: uint):Boolean {
        return _activeKeys ? _activeKeys[key] : false;
    }

    public static function init(stage: Stage):void {
        _stage = stage;
        _stage.addEventListener(KeyboardEvent.KEY_DOWN, onPress);
        _stage.addEventListener(KeyboardEvent.KEY_UP, onRelease);
    }

    private static function onPress(event: KeyboardEvent):void {
        _activeKeys[event.keyCode] = true;
    }

    private static function onRelease(event: KeyboardEvent):void {
        delete _activeKeys[event.keyCode];
    }
}
}
