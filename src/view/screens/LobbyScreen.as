/**
 * Created by desktop on 03.03.2015.
 */
package view.screens {
import assets.gui.LobbyScreenView;
import assets.gui.RoomPanelView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Button;
import com.agnither.utils.gui.components.Label;

import controller.GameController;

import flash.utils.Dictionary;

import starling.events.Event;
import starling.text.TextField;

import view.lobby.LobbyPanel;
import view.lobby.LobbyTilelist;

public class LobbyScreen extends AbstractComponent {


    override protected function getManifest():Dictionary {
        var manifest: Dictionary = new Dictionary(true);
//        manifest[RoomPanelView] = LobbyPanel;
        manifest[GamesTiles] = LobbyTilelist;
        return manifest;
    }

    public function get lobby():LobbyTilelist {
        return getChild("tiles") as LobbyTilelist;
    }

    public function get quickGameButton():Button {
        return getChild("btn_quickGame") as Button;
    }

    public function get joinGameButton():Button {
        return getChild("btn_joinGame") as Button;
    }

    public function get newGameButton():Button {
        return getChild("btn_newGame") as Button;
    }

    public function get sendButton():Button {
        return getChild("btn_sendMessage") as Button;
    }

    public function LobbyScreen() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(LobbyScreenView, "gui");

//        lobby.width = stage.stageWidth;
//        lobby.height = stage.stageHeight;

        quickGameButton.label.text = "Quick Game";
        quickGameButton.addEventListener(Event.TRIGGERED, handleConnect);

        joinGameButton.label.text = "Join Game";
        joinGameButton.addEventListener(Event.TRIGGERED, handleConnect);

        newGameButton.label.text = "New Game";
        newGameButton.addEventListener(Event.TRIGGERED, handleConnect);

        sendButton.label.text = "Send";
        sendButton.addEventListener(Event.TRIGGERED, sendMessage);

        (getChild("chatTitle") as Label).text = "Chat";
        (getChild("gamesTitle") as Label).text = "Games";

    }

    private function sendMessage(event : Event) : void
    {

    }

    public function showRooms(list: Array /* of Room */):void {
        lobby.showRooms(list);
    }

    private function handleConnect(e: Event):void {
        switch (e.target) {
            case quickGameButton:
                dispatchEventWith(GameController.COMMAND, true, {type :GameController.QUICK_GAME});
                break;
            case newGameButton:
                dispatchEventWith(GameController.COMMAND, true, {type :GameController.NEW_GAME});
                break;
            case joinGameButton:
                /**
                 * TODO get name from selected line
                 */
//                dispatchEventWith(GameController.COMMAND, true, {type :GameController.JOIN_GAME, name:""});
                break;
        }
    }
}
}
