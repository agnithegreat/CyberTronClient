/**
 * Created by desktop on 02.03.2015.
 */
package view.field {
import assets.gui.WallPlaceView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Scale9Picture;

import model.entities.Wall;

public class WallView extends AbstractComponent {

    public function get back():Scale9Picture {
        return getChild("back") as Scale9Picture;
    }

    override public function set width(value: Number):void {
        back.width = value;
    }
    override public function get width():Number {
        return back.width;
    }

    override public function set height(value: Number):void {
        back.height = value;
    }
    override public function get height():Number {
        return back.height;
    }

    private var _wall: Wall;

    public function WallView(wall: Wall) {
        _wall = wall;
    }

    override protected function initialize():void {
        createFromFlash(WallPlaceView, "gui");

        x = _wall.x;
        y = _wall.y;
        width = _wall.width;
        height = _wall.height;
    }
}
}
