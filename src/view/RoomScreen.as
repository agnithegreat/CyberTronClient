/**
 * Created by desktop on 03.03.2015.
 */
package view {
import assets.gui.FieldContainerView;
import assets.gui.RoomPanelView;
import assets.gui.RoomScreenView;

import com.agnither.utils.gui.components.AbstractComponent;

import flash.utils.Dictionary;

import view.field.FieldView;
import view.room.RoomPanel;

public class RoomScreen extends AbstractComponent {

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
    }

    public function setBase(data: Object):void {
        field.setBase(data.x, data.y, data.width, data.height)
    }

    public function showRoom(name: String):void {
        room.showRoom(name);
    }

    public function showUsers(list: Array /* of User */):void {
        room.showUsers(list);
    }
}
}
