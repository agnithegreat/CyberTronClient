/**
 * Created by desktop on 03.03.2015.
 */
package view.screens {
import assets.gui.FieldContainerView;
import assets.gui.RoomPanelView;
import assets.gui.RoomScreenView;

import com.agnither.utils.gui.components.AbstractComponent;

import flash.utils.Dictionary;

import model.properties.GlobalProps;

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

        field.width = GlobalProps.field.width;
        field.height = GlobalProps.field.height;
    }

    public function showRoom(name: String):void {
        room.showRoom(name);
    }

    public function showUsers(list: Array /* of User */):void {
        room.showUsers(list);
    }
}
}
