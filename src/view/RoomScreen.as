/**
 * Created by desktop on 03.03.2015.
 */
package view {
import as3reflect.Constant;

import assets.gui.FieldContainerView;
import assets.gui.RoomPanelView;
import assets.gui.RoomScreenView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.User;

import flash.ui.Keyboard;

import flash.utils.Dictionary;

import model.Properties;

import starling.events.KeyboardEvent;

import view.field.FieldView;
import view.room.RoomPanel;

public class RoomScreen extends AbstractComponent {

    private var _activeKeys : Dictionary = new Dictionary(true);

    override protected function getManifest():Dictionary {
        var manifest: Dictionary = new Dictionary(true);
        manifest[RoomPanelView] = RoomPanel;
        manifest[FieldContainerView] = FieldView;
        return manifest;
    }

    public function get room():RoomPanel {
        return getChild("room") as RoomPanel;
    }

    public function get field():FieldView {
        return getChild("field") as FieldView;
    }

    public function RoomScreen() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(RoomScreenView, "gui");

        room.width = 220;
        room.height = stage.stageHeight;

        field.width = 600;
        field.height = 600;

        stage.addEventListener(KeyboardEvent.KEY_DOWN, onPress);
        stage.addEventListener(KeyboardEvent.KEY_UP, onRelease);
    }

    private function onRelease(event: KeyboardEvent):void {
        delete _activeKeys[event.keyCode];
        updateKeys();
    }

    private function onPress(event: KeyboardEvent):void {
        _activeKeys[event.keyCode] = true;
        updateKeys();
    }

    private function updateKeys():void {
        var deltaX: int = int(_activeKeys[Keyboard.D]) - int(_activeKeys[Keyboard.A]);
        var deltaY: int = int(_activeKeys[Keyboard.S]) - int(_activeKeys[Keyboard.W]);

        var params:ISFSObject = new SFSObject();
        params.putInt(Properties.VAR_DELTAX, deltaX);
        params.putInt(Properties.VAR_DELTAY, deltaY);
        dispatchEventWith(App.MOVE_USER_EVT, true, {params: params});
    }

    public function showRoom(name: String):void {
        room.showRoom(name);
    }

    public function showUsers(list: Array /* of User */):void {
        room.showUsers(list);
    }

    public function updateUsers(user: User):void {
        field.updateUser(user);
    }
}
}
