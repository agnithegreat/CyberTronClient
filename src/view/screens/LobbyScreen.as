/**
 * Created by desktop on 03.03.2015.
 */
package view.screens {
import assets.gui.LobbyScreenView;
import assets.gui.RoomPanelView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Button;

import controller.GameController;

import flash.utils.Dictionary;

import starling.events.Event;

import view.lobby.LobbyPanel;

public class LobbyScreen extends AbstractComponent {

    override protected function getManifest():Dictionary {
        var manifest: Dictionary = new Dictionary(true);
        manifest[RoomPanelView] = LobbyPanel;
        return manifest;
    }

    public function get lobby():LobbyPanel {
        return getChild("lobby") as LobbyPanel;
    }

    public function get quickGameButton():Button {
        return getChild("btn_quickGame") as Button;
    }

    public function LobbyScreen() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(LobbyScreenView, "gui");

        lobby.width = stage.stageWidth;
        lobby.height = stage.stageHeight;

        quickGameButton.label.text = "Quick Game";
        quickGameButton.addEventListener(Event.TRIGGERED, handleConnect);
    }

    public function showRooms(list: Array /* of Room */):void {
        lobby.showRooms(list);
    }

    private function handleConnect(e: Event):void {
        dispatchEventWith(GameController.COMMAND, true, GameController.QUICK_GAME);
    }
}
}
