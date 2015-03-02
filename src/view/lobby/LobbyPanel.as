/**
 * Created by desktop on 01.03.2015.
 */
package view.lobby {
import assets.gui.UsersPanelView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Button;
import com.agnither.utils.gui.components.Label;
import com.agnither.utils.gui.components.Scale9Picture;
import com.smartfoxserver.v2.entities.Room;

public class LobbyPanel extends AbstractComponent {

    public function get lobbyBack():Scale9Picture {
        return _children.back;
    }

    public function get lobbyContainer():Scale9Picture {
        return _children.container;
    }

    public function get lobbyRoomNames():AbstractComponent {
        return _children.userNames;
    }

    public function get lobbyTitle():Label {
        return _children.room_title;
    }

    public function get quickGame():Button {
        return _children.btn_quickGame;
    }
    public function get quickGameLabel():Label {
        return quickGame.getChild("button_label") as Label;
    }

    override public function set width(value: Number):void {
        lobbyBack.width = value;
        lobbyContainer.width = lobbyBack.width - lobbyContainer.x*2;
        lobbyTitle.width = lobbyContainer.width;
        lobbyTitle.x = lobbyContainer.x;
        quickGame.x = (lobbyBack.width-quickGame.width)/2;
    }
    override public function get width():Number {
        return lobbyBack.width;
    }

    override public function set height(value: Number):void {
        lobbyBack.height = value;
        lobbyContainer.height = lobbyBack.height - lobbyContainer.y*2;
        quickGame.y = lobbyContainer.height-quickGame.height/2;
    }
    override public function get height():Number {
        return lobbyBack.height;
    }

    private var _tileY: int;

    public function LobbyPanel() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(UsersPanelView, "gui");

        lobbyTitle.text = "Lobby";

        quickGameLabel.text = "Quick Game";

        _tileY = lobbyRoomNames.getChild("user2").y - lobbyRoomNames.getChild("user1").y;
        clearRooms();
    }

    public function setState(state: String):void {
        quickGame.visible = state == App.LOGGED;
    }

    public function showRooms(list: Array /* of Room */):void {
        clearRooms();

        for (var i:int = 0; i < list.length; i++) {
            var room: Room = list[i];
            var tile: RoomTile = new RoomTile();
            lobbyRoomNames.addChild(tile);
            tile.width = lobbyBack.width-lobbyRoomNames.x*2;
            tile.y = i * _tileY;
            tile.roomName.text = room.name;
        }
    }

    private function clearRooms():void {
        lobbyRoomNames.removeChildren(0, -1, true);
    }
}
}