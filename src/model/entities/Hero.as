/**
 * Created by kirillvirich on 12.03.15.
 */
package model.entities {

public class Hero extends GameItem {

    public var id: int;
    public var name: String;
    public var color: int;
    public var direction: Number;

    public var weapon: Weapon;

    public function Hero(settings: Object) {
        super(settings);
    }
}
}
