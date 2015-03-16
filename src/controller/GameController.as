/**
 * Created by kirillvirich on 13.03.15.
 */
package controller {
import assets.gui.Atlas1;

import com.agnither.utils.gui.Resources;
import com.agnither.utils.gui.atlas.AtlasFactory;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.UserVariable;

import flash.utils.Dictionary;

import model.Game;
import model.control.UserControl;
import model.entities.Hero;
import model.properties.GlobalProps;
import model.properties.LevelProps;
import model.properties.PersonageProps;
import model.properties.RequestProps;
import model.properties.RoomProps;

import server.SmartFoxConnector;

import starling.display.Sprite;
import starling.events.Event;
import starling.events.EventDispatcher;

import utils.KeyLogger;
import utils.TouchLogger;

import view.View;

public class GameController extends EventDispatcher {

    public static const INIT: String = "init";
    public static const LOGGED: String = "logged";
    public static const JOINED: String = "joined";

    public static const COMMAND: String = "command";
    public static const CONNECT: String = "command.connect";
    public static const QUICK_GAME: String = "command.quick_game";
    public static const NEW_GAME: String = "command.new_game";
    public static const JOIN_GAME: String = "command.join_game";

    public static const STATE_UPDATE: String = "state_update_GameController";
    public static const ROOMS_UPDATE: String = "rooms_update_GameController";
    public static const ROOM_UPDATE: String = "room_update_GameController";

    private var _connection: SmartFoxConnector;

    private var _game: Game;
    public function get game():Game {
        return _game;
    }

    private var _view: View;

    private var _userControl: UserControl;

    public function GameController() {
        super();
    }

    public function init(viewPort: Sprite):void {
        initGame();
        initGUI(viewPort);
        initConnection();
        initControl(viewPort);
        setState(INIT);
    }

    private function initGame():void {
        _game = new Game();
    }

    private function initGUI(viewPort: Sprite):void {
        Resources.addAtlas("gui", AtlasFactory.fromAtlasMC(Atlas1));

        _view = new View(this);
        _view.addEventListener(COMMAND, handleCommand);
        viewPort.addChild(_view);
        _view.init();
    }

    private function initConnection():void {
        _connection = new SmartFoxConnector();

        _connection.addEventListener(SmartFoxConnector.LOGGED_IN, handleLoggedIn);
        _connection.addEventListener(SmartFoxConnector.ROOM_JOINED, handleRoomJoined);
        _connection.addEventListener(SmartFoxConnector.USER_ENTER, handleUserEnter);
        _connection.addEventListener(SmartFoxConnector.USER_LEAVE, handleUserLeave);
        _connection.addEventListener(SmartFoxConnector.CONNECTION_LOST, handleConnectionLost);

        _connection.addEventListener(SmartFoxConnector.USER_VARS_UPDATE, handleUserVarsUpdate);
        _connection.addEventListener(SmartFoxConnector.ROOM_VARS_UPDATE, handleRoomVarsUpdate);

        _connection.init();
    }

    private function initControl(viewPort: Sprite):void {
        KeyLogger.init(viewPort.stage);
        TouchLogger.init(viewPort.stage);

        _userControl = new UserControl();
        _userControl.addEventListener(UserControl.MOVE, onMove);
        _userControl.addEventListener(UserControl.ROTATE, onRotate);
        _userControl.addEventListener(UserControl.SHOT, onShot);
    }

    private function setState(state: String):void {
        dispatchEventWith(STATE_UPDATE, false, state);
    }

    private function handleCommand(e: Event):void {
        switch (e.data.type) {
            case CONNECT:
                _connection.connect();
                break;
            case QUICK_GAME:
                _connection.quickGame();
                break;
            case NEW_GAME:
                _connection.newGame();
                break;
            case JOIN_GAME:
                _connection.joinGame(e.data.name);
                break;
        }
    }

    private function onMove(event: Event):void {
        _connection.sendRequest(RequestProps.REQ_MOVE, event.data as SFSObject);
    }

    private function onRotate(event: Event):void {
        _connection.sendRequest(RequestProps.REQ_ROTATE, event.data as SFSObject);
    }

    private function onShot(event: Event):void {
        _connection.sendRequest(RequestProps.REQ_SHOT, event.data as SFSObject);
    }




    private function handleLoggedIn(e: Event):void {
        setState(LOGGED);
        dispatchEventWith(ROOMS_UPDATE, false, _connection.roomList);
    }

    private function handleRoomJoined(e: Event):void {
        setState(JOINED);
        dispatchEventWith(ROOMS_UPDATE, false, _connection.roomList);

        var room: Room = e.data as Room;
        dispatchEventWith(ROOM_UPDATE, false, room);
    }

    private function handleUserEnter(e: Event):void {
        var room:Room = e.data as Room;
        dispatchEventWith(ROOM_UPDATE, false, room);
    }

    private function handleUserLeave(e: Event):void {
        var user: User = e.data as User;
        _game.removeHero(user.id);

        dispatchEventWith(ROOM_UPDATE, false, _connection.currentRoom);
    }

    private function handleConnectionLost(e: Event):void {
        setState(INIT);
    }


    private function handleUserVarsUpdate(e: Event):void {
        if (!GlobalProps.PROPERTIES) {
            return;
        }

        var user: User = e.data as User;
        var vars: Array = user.getVariables();
        var data: Object = {id: user.id, name: user.name};
        for (var i:int = 0; i < vars.length; i++) {
            var userVariable: UserVariable = vars[i];
            data[userVariable.name] = userVariable.getValue();
        }

        if (!_game.getHero(data.id)) {
            _game.addHero(data);
        }
        _game.updateHero(data);

        if (_userControl.ready) {
            _userControl.removeProcessedInputs(data[PersonageProps.REQ_ID]);
            _userControl.processPendingInputs();
        } else {
            var hero: Hero = _game.getHero(_connection.localUser.id);
            if (hero) {
                _userControl.init(hero);
            }
        }
    }

    private function handleRoomVarsUpdate(e: Event):void {
        var except: Dictionary;
        var i: int;

        switch (e.data.name) {
            case RoomProps.CONFIG:
                GlobalProps.PROPERTIES = e.data.data.toObject();
                break;

            case RoomProps.LEVEL:
                LevelProps.LEVEL = e.data.data.toObject();
                _game.init();
                break;

            case RoomProps.MONSTERS:
                except = new Dictionary(true);
                var monsters: ISFSArray = e.data.data as ISFSArray;
                for (i = 0; i < monsters.size(); i++) {
                    var monster: Object = (monsters.getElementAt(i) as ISFSObject).toObject();

                    if (!_game.getEnemy(monster.id)) {
                        _game.addEnemy(monster);
                    }
                    except[monster.id] = true;
                    _game.updateEnemy(monster);
                }
                _game.clearEnemies(except);
                break;

            case RoomProps.BULLETS:
                except = new Dictionary(true);
                var bullets: ISFSArray = e.data.data as ISFSArray;
                for (i = 0; i < bullets.size(); i++) {
                    var bullet: Object = (bullets.getElementAt(i) as ISFSObject).toObject();

                    if (!_game.getBullet(bullet.id)) {
                        _game.addBullet(bullet);
                    }
                    except[bullet.id] = true;
                    _game.updateBullet(bullet);
                }
                _game.clearBullets(except);
                break;

            case RoomProps.BASE:
                _game.updateBase(e.data.data.toObject().hp);
                break;

            case RoomProps.RESULT:
                trace(e.data.name, e.data.data.toObject().win);
                _game.clearHeroes();
                _userControl.init(null);
                _connection.leaveRoom();

                handleLoggedIn(null);
                break;
        }
    }
}
}
