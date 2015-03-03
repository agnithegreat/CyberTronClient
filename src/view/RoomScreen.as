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
    private var activeKeys : Array;

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

        activeKeys = [];

    }

    private function onRelease(event : KeyboardEvent) : void
    {
        var index : int = activeKeys.indexOf(event.keyCode);
        if(index >= 0)
        {
            activeKeys.splice(index,1);
        }
//        trace("RELEASED",activeKeys);
        updateKeys();
    }

    private function onPress(event : KeyboardEvent) : void
    {
        var index : int = activeKeys.indexOf(event.keyCode);
        if(index >= 0) return;
//        trace("press", event.keyCode);

        switch (event.keyCode)
        {
            case Keyboard.A:
            case Keyboard.D:
            case Keyboard.W:
            case Keyboard.S:
                activeKeys.push(event.keyCode);
                break;


//            case Keyboard.A:
//                index = activeKeys.indexOf(Keyboard.D);
//                if(index >= 0)
//                {
//                    activeKeys.splice(index, 1)
//                }
//                activeKeys.push(event.keyCode);
//                break;
//            case Keyboard.D:
//                index = activeKeys.indexOf(Keyboard.A);
//                if(index >= 0)
//                {
//                    activeKeys.splice(index, 1)
//                }
//                activeKeys.push(event.keyCode);
//                break;
//            case Keyboard.W:
//                index = activeKeys.indexOf(Keyboard.S);
//                if(index >= 0)
//                {
//                    activeKeys.splice(index, 1)
//                }
//                activeKeys.push(event.keyCode);
//                break;
//            case Keyboard.S:
//                index = activeKeys.indexOf(Keyboard.W);
//                if(index >= 0)
//                {
//                    activeKeys.splice(index, 1)
//                }
//                activeKeys.push(event.keyCode);
//                break;
        }
//        trace("PRESSED",activeKeys);


        updateKeys();
    }

    private function updateKeys() : void
    {
        var deltaX : int = 0;
        var deltaY : int = 0;
        for (var i : int = 0; i < activeKeys.length; i++)
        {
            var key : int = activeKeys[i];
            switch(key)
            {
                case Keyboard.A:
                    deltaX += 1;
                    break;
                case Keyboard.D:
                    deltaX -= 1;
                    break;
                case Keyboard.W:
                    deltaY += 1;
                    break;
                case Keyboard.S:
                    deltaX -= 1;
                    break;
            }
        }

//        if(deltaX != 0 && deltaY != 0)
//        {
            var params:ISFSObject = new SFSObject();
//            if(deltaX != 0)
//            {
                params.putInt(Properties.VAR_DELTAX, deltaX);
//            }
//            if(deltaY != 0)
//            {
                params.putInt(Properties.VAR_DELTAY, deltaY);
//            }
            dispatchEventWith(App.MOVE_USER_EVT, true, {params: params});



//        }



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
