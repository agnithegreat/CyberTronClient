/**
 * Created by kirillvirich on 06.03.15.
 */
package model.properties {
public class GlobalProps {

    public static var PROPERTIES: Object;

    public static function get field():Object {
        return PROPERTIES.field;
    }

    public static function get base():Object {
        return PROPERTIES.base;
    }

    public static function get hero():Object {
        return PROPERTIES.hero;
    }

    public static function get enemies():Object {
        return PROPERTIES.enemies;
    }

    public static function getEnemy(name: String):Object {
        return PROPERTIES.enemies[name];
    }

    public static function get weapons():Object {
        return PROPERTIES.weapons;
    }

    public static function getWeapon(name: String):Object {
        if(!name)
        {
            return PROPERTIES.weapons["m4"];
        }

        return PROPERTIES.weapons[name];
    }
}
}
