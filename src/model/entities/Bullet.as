/**
 * Created by kirillvirich on 12.03.15.
 */
package model.entities {

public class Bullet extends GameItem {

    public var id: int;
    public var color: int;
    public var direction: Number;

    public function Bullet(settings: Object) {
        super(settings);
    }
}
}
