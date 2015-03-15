/**
 * Created by kirillvirich on 02.03.15.
 */
package view.lobby {
import assets.gui.RoomTileView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Label;

public class GameTile extends AbstractComponent {

    public function get label():Label {
        return getChild("label") as Label;
    }

    override public function set width(value: Number):void {
        label.width = value;
    }

    override public function get width():Number {
        return label.width;
    }

    public function GameTile() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(GameLineView, "gui");
    }
}
}
