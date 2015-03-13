/**
 * Created by kirillvirich on 13.03.15.
 */
package model.entities {
public class Weapon extends GameItem {

    public var counter: int = 0;

    public var ammo: int = 0;

    public var cooldown: Number = 0;

    public function Weapon(settings: Object) {
        super(settings);
    }

    public function reload():void {
        ammo = settings.ammo;
    }

    public function shot():void {
        ammo--;

        if (ammo <= 0) {
            cooldown = settings.reload;
        } else {
            cooldown = settings.cooldown;
        }
    }

    public function getSpread():Number {
        return settings.spread;
    }

    public function getShotAmount():int {
        return settings.shotamount;
    }
}
}
