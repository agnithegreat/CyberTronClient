/**
 * Created by desktop on 01.03.2015.
 */
package view.room {
import assets.gui.UsersPanelView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Button;
import com.agnither.utils.gui.components.Label;
import com.agnither.utils.gui.components.Scale9Picture;
import com.smartfoxserver.v2.entities.User;

public dynamic class RoomPanel extends AbstractComponent {

    public function get roomBack():Scale9Picture {
        return this.back;
    }

    public function get roomContainer():Scale9Picture {
        return this.container;
    }

    public function get roomUsersNames():AbstractComponent {
        return this.userNames;
    }

    public function get roomTitle():Label {
        return this.room_title;
    }

    public function get quickGame():Button {
        return this.btn_quickGame;
    }

    override public function set width(value: Number):void {
        roomBack.width = value;
        roomContainer.width = roomBack.width - roomContainer.x*2;
        roomTitle.width = roomContainer.width;
        roomTitle.x = roomContainer.x;
    }
    override public function get width():Number {
        return roomBack.width;
    }

    override public function set height(value: Number):void {
        roomBack.height = value;
        roomContainer.height = roomBack.height - roomContainer.y*2;
    }
    override public function get height():Number {
        return roomBack.height;
    }

    private var _tileY: int;

    public function RoomPanel() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(UsersPanelView, "gui");

        roomTitle.text = "Room";

        quickGame.button_label.text = "Quick Game";
        quickGame.visible = false;

        _tileY = roomUsersNames.user2.y - roomUsersNames.user1.y;
        clearUsers();
    }

    public function showRoom(name: String):void {
        roomTitle.text = name;
    }

    public function showUsers(list: Array /* of User */):void {
        clearUsers();

        for (var i:int = 0; i < list.length; i++) {
            var user: User = list[i];
            var tile: UserNameTile = new UserNameTile();
            roomUsersNames.addChild(tile);
            tile.width = roomBack.width-roomUsersNames.x*2;
            tile.y = i * _tileY;
            tile.userName.text = user.name;
        }
    }

    private function clearUsers():void {
        roomUsersNames.removeChildren(0, -1, true);
    }
}
}
