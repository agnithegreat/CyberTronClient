/**
 * Created by kirillvirich on 02.03.15.
 */
package view.lobby {
import assets.gui.UserNameView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Label;

public class RoomTile extends AbstractComponent {

    public function get roomName():Label {
        return _children.userName_label;
    }

    override public function set width(value: Number):void {
        roomName.width = value;
    }

    override public function get width():Number {
        return roomName.width;
    }

    public function RoomTile() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(UserNameView, "gui");
    }
}
}
