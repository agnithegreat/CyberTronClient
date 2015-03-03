/**
 * Created by desktop on 01.03.2015.
 */
package view.room {
import assets.gui.RoomPanelView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Label;
import com.agnither.utils.gui.components.Scale9Picture;

import com.smartfoxserver.v2.entities.User;

public class RoomPanel extends AbstractComponent {

    public function get back():Scale9Picture {
        return getChild("back") as Scale9Picture;
    }

    public function get container():Scale9Picture {
        return getChild("container") as Scale9Picture;
    }

    public function get tiles():AbstractComponent {
        return getChild("tiles");
    }

    public function get title():Label {
        return getChild("title") as Label;
    }

    override public function set width(value: Number):void {
        back.width = value;
        container.width = back.width - container.x*2;
        title.width = container.width;
    }
    override public function get width():Number {
        return back.width;
    }

    override public function set height(value: Number):void {
        back.height = value;
        container.height = back.height - container.y*2;
    }
    override public function get height():Number {
        return back.height;
    }

    private var _tileY: int;

    public function RoomPanel() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(RoomPanelView, "gui");

        title.text = "Room";

        _tileY = tiles.getChild("tile2").y - tiles.getChild("tile1").y;
        clearUsers();
    }

    public function showRoom(name: String):void {
        title.text = name;
    }

    public function showUsers(list: Array /* of User */):void {
        clearUsers();

        for (var i:int = 0; i < list.length; i++) {
            var user: User = list[i];
            var tile: UserNameTile = new UserNameTile();
            tiles.addChild(tile);
            tile.width = back.width-tiles.x*2;
            tile.y = i * _tileY;
            tile.label.text = user.name;
        }
    }

    private function clearUsers():void {
        tiles.removeChildren(0, -1, true);
    }
}
}
