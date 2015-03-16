/**
 * Created by desktop on 01.03.2015.
 */
package view.lobby {

import com.agnither.utils.gui.components.AbstractComponent;

import com.smartfoxserver.v2.entities.Room;

import starling.display.DisplayObject;
import starling.display.Sprite;

public class LobbyTilelist extends AbstractComponent {

    override public function set height(value: Number):void {
//        container.height = back.height - container.y*2;
    }
//    override public function get height():Number {
//        return back.height;
//    }

    private var _tileY: int;
    private var _container : Sprite;

    public function LobbyTilelist() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(GamesTiles, "gui");

        var tile0 : DisplayObject = getChildAt(0);

        _tileY = tile0.height;

        removeChildren();
        tile0 = null;

        _container = new Sprite();
        addChild(_container);

        clearRooms();
    }

    public function showRooms(list: Array /* of Room */):void {
        clearRooms();

        for (var i:int = 0; i < list.length; i++) {
            var room: Room = list[i];
            if(room.name == "Lobby")
            {
                continue;
            }
            var tile: GameTile = new GameTile();
            tile.y = _container.numChildren * _tileY;
            _container.addChild(tile);
            tile.label.text = room.name;
            tile.getChild("selectedBack").visible = false;
        }
    }

    private function clearRooms():void {
        _container.removeChildren(0, -1, true);
    }
}
}
