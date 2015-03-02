/**
 * Created by desktop on 01.03.2015.
 */
package view {
import assets.gui.UsersPanelView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Button;
import com.agnither.utils.gui.components.Scale9Picture;
import com.smartfoxserver.v2.entities.User;

public dynamic class UsersPanel extends AbstractComponent {

    public static const INIT: String = "init";
    public static const LOGGED: String = "logged";
    public static const JOINED: String = "joined";

    public function get roomBack():Scale9Picture {
        return this.back;
    }

    public function get roomContainer():Scale9Picture {
        return this.container;
    }

    public function get roomUsersNames():AbstractComponent {
        return this.userNames;
    }

    public function get quickGame():Button {
        return this.btn_quickGame;
    }

    override public function set width(value: Number):void {
        roomBack.width = value;
        roomContainer.width = roomBack.width - roomContainer.x*2;
        quickGame.x = (roomBack.width-quickGame.width)/2;
    }
    override public function get width():Number {
        return roomBack.width;
    }

    override public function set height(value: Number):void {
        roomBack.height = value;
        roomContainer.height = roomBack.height - roomContainer.y*2;
        quickGame.y = roomContainer.height-quickGame.height;
    }
    override public function get height():Number {
        return roomBack.height;
    }

    private var _tileY: int;

    public function UsersPanel() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(UsersPanelView, "gui");

        quickGame.button_label.text = "Quick Game";

        _tileY = roomUsersNames.user2.y - roomUsersNames.user1.y;
        clearUsers();
    }

    public function setState(state: String):void {
        quickGame.visible = state == LOGGED;
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
