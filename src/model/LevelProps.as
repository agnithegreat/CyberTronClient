/**
 * Created by kirillvirich on 06.03.15.
 */
package model {
public class LevelProps {

    public static var LEVEL: Object;

    public static function get id():int {
        return LEVEL.id;
    }

    public static function get base():Object {
        return LEVEL.base;
    }

    public static function get heroes():Array {
        return LEVEL.heroes;
    }

    public static function get enemies():Array {
        return LEVEL.enemies;
    }
}
}
