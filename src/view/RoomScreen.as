/**
 * Created by desktop on 03.03.2015.
 */
package view {
import assets.gui.FieldContainerView;
import assets.gui.RoomPanelView;
import assets.gui.RoomScreenView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.SFSObject;

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

    public function showRoom(name: String):void {
        room.showRoom(name);
    }

    public function showUsers(list: Array /* of User */):void {
        room.showUsers(list);
        field.showUsers(list);
    }

    public function updateUser(user: User):void {
        field.updateUser(user);
    }

    public function updateBullet(bullet: SFSObject, user: User):void {
        field.updateBullet(bullet, user);
    }

    public function cleanBullets():void {
        field.cleanBullets();
    }

    public function updateMonster(monster : SFSObject) : void
    {
        field.updateMonster(monster);
    }

    public function cleanMonsters() : void
    {
        field.cleanMonsters()
    }
}
}
