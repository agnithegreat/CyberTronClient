/**
 * Created by kirillvirich on 13.03.15.
 */
package model.entities {
public class Base extends GameItem {

    public var width: int;
    public var height: int;

    public var hp: int;

    public function Base(settings:Object) {
        super(settings);

        hp = settings.hp;
    }
}
}
