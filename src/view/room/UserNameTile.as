/**
 * Created by kirillvirich on 02.03.15.
 */
package view.room {
import assets.gui.RoomTileView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Label;

public class UserNameTile extends AbstractComponent {

    public function get label():Label {
        return getChild("label") as Label;
    }

    override public function set width(value: Number):void {
        label.width = value;
    }

    override public function get width():Number {
        return label.width;
    }

    public function UserNameTile() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(RoomTileView, "gui");
    }
}
}
