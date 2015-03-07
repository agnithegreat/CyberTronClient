/**
 * Created by kirillvirich on 06.03.15.
 */
package model {
public class GlobalProps {

    public static var PROPERTIES: Object;

    public static function get field():Object {
        return PROPERTIES.field;
    }

    public static function get hero():Object {
        return PROPERTIES.hero;
    }

    public static function get weapons():Object {
        return PROPERTIES.weapons;
    }

    public static function getWeapon(name: String):Object {
        return PROPERTIES.weapons[name];
    }
}
}
