/**
 * Created by desktop on 02.03.2015.
 */
package view.field {
import assets.gui.TowerPlaceView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Scale9Picture;

import model.entities.Tower;

public class TowerView extends AbstractComponent {

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

    private var _tower: Tower;

    public function TowerView(tower: Tower) {
        _tower = tower;
    }

    override protected function initialize():void {
        createFromFlash(TowerPlaceView, "gui");

        x = _tower.x;
        y = _tower.y;
        width = _tower.width;
        height = _tower.height;
    }
}
}
