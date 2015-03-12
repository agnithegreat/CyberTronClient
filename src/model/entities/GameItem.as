/**
 * Created by kirillvirich on 12.03.15.
 */
package model.entities {
import starling.events.EventDispatcher;

public class GameItem extends EventDispatcher {

    public static const UPDATE: String = "update_GameItem";

    protected var settings: Object;

    public var x: Number;
    public var y: Number;

    public function GameItem(settings: Object) {
        super();

        this.settings = settings;
    }

    public function update():void {
        dispatchEventWith(UPDATE);
    }
}
}
