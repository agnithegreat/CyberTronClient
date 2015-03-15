/**
 * Created by desktop on 15.03.2015.
 */
package model.entities {
public class Wall extends GameItem {

    public var id: int;

    public var width: int;
    public var height: int;

    public function Wall(settings:Object) {
        super(settings);
    }
}
}
