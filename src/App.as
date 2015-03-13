/**
 * Created by kirillvirich on 26.02.15.
 */
package {
import assets.gui.Atlas1;

import com.agnither.utils.gui.Resources;
import com.agnither.utils.gui.atlas.AtlasFactory;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

import controller.GameController;

import model.control.UserControl;

import flash.ui.Mouse;
import flash.utils.Dictionary;

import model.Game;
import model.properties.GlobalProps;
import model.properties.LevelProps;
import model.properties.RequestProps;
import model.properties.RoomProps;

import server.SmartFoxConnector;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;

import utils.KeyLogger;
import utils.TouchLogger;

import view.screens.LobbyScreen;
import view.screens.MainMenu;
import view.screens.RoomScreen;
import view.field.AimView;

public class App extends Sprite implements IStartable {

    private var _gameController: GameController;

    public function start():void {
        _gameController = new GameController();
        _gameController.init(this);
    }
}
}
