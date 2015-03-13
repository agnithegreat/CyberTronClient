/**
 * Created by kirillvirich on 26.02.15.
 */
package {
import assets.gui.Atlas1;

import com.agnither.utils.gui.Resources;
import com.agnither.utils.gui.atlas.AtlasFactory;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.SFSObject;

import control.UserControl;

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

import view.LobbyScreen;
import view.MainMenu;
import view.RoomScreen;
import view.field.AimView;

public class App extends Sprite implements IStartable {

    public static const INIT: String = "init";
    public static const LOGGED: String = "logged";
    public static const JOINED: String = "joined";

    private var _connection: SmartFoxConnector;

    private var _game: Game;

    private var _userControl: UserControl;

    private var _mainMenu: MainMenu;
    private var _lobbyScreen: LobbyScreen;
    private var _roomScreen: RoomScreen;

    private var _cursor: AimView;

    public function start():void {
        initGUI();
        initConnection();
        initControl();
        setState(INIT);
    }

    private function initGUI():void {
        Resources.addAtlas("gui", AtlasFactory.fromAtlasMC(Atlas1));

        _game = new Game();

        _mainMenu = new MainMenu();
        addChild(_mainMenu);
        _mainMenu.addEventListener(Event.TRIGGERED, onConnect);

        _lobbyScreen = new LobbyScreen();
        addChild(_lobbyScreen);
        _lobbyScreen.addEventListener(Event.TRIGGERED, onQuickGame);

        _roomScreen = new RoomScreen();
        addChild(_roomScreen);
        _roomScreen.field.init(_game);
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

    private function initControl():void {
        KeyLogger.init(stage);
        TouchLogger.init(stage);

        _userControl = new UserControl();
        _userControl.addEventListener(UserControl.MOVE, onMove);
        _userControl.addEventListener(UserControl.ROTATE, onRotate);
        _userControl.addEventListener(UserControl.SHOT, onShot);

        _cursor = new AimView();
        addChild(_cursor);
        Starling.juggler.add(_cursor);
        Mouse.hide();
    }

    private function setState(state: String):void {
        switch (state) {
            case INIT:
                _mainMenu.visible = true;
                _lobbyScreen.visible = false;
                _roomScreen.visible = false;

                Starling.juggler.remove(_userControl);
                break;
            case LOGGED:
                _mainMenu.visible = false;
                _lobbyScreen.visible = true;
                _roomScreen.visible = false;

                Starling.juggler.remove(_userControl);
                break;
            case JOINED:
                _mainMenu.visible = false;
                _lobbyScreen.visible = false;
                _roomScreen.visible = true;

                Starling.juggler.add(_userControl);
                break;
        }
    }

    private function onConnect(event:Event):void {
        _connection.connect();
    }

    private function onQuickGame(event: Event):void {
        _connection.joinQuickGame();
    }

    private function onMove(event: Event):void {
        _connection.sendRequest(RequestProps.REQ_MOVE, event.data as SFSObject);
    }

    private function onRotate(event: Event):void {
        _connection.sendRequest(RequestProps.REQ_ROTATE, event.data as SFSObject);

//        var hero: Hero = _game.getHero(_sfs.mySelf.id);
//        hero.direction = (event.data as SFSObject).getFloat(PersonageProps.DIRECTION);
//        hero.update();
    }

    private function onShot(event: Event):void {
        _connection.sendRequest(RequestProps.REQ_SHOT, event.data as SFSObject);
    }




    private function handleLoggedIn(e: Event):void {
        setState(LOGGED);
        _lobbyScreen.showRooms(_connection.roomList);
    }

    private function handleRoomJoined(e: Event):void {
        setState(JOINED);

        _lobbyScreen.showRooms(_connection.roomList);

        var room: Room = e.data as Room;
        _roomScreen.showRoom(room.name);
        _roomScreen.showUsers(room.userList);
    }

    private function handleUserEnter(e: Event):void {
        var room:Room = e.data as Room;
        _roomScreen.showUsers(room.userList);
    }

    private function handleUserLeave(e: Event):void {
        var user: User = e.data as User;
        _game.removeHero(user.id);

        _roomScreen.showUsers(_connection.currentRoom.userList);
    }

    private function handleConnectionLost(e: Event):void {
        setState(INIT);
    }


    private function handleUserVarsUpdate(e: Event):void {
        var user: User = e.data as User;

        if (!GlobalProps.PROPERTIES) {
            return;
        }

        if (!_game.getHero(user.id)) {
            _game.addHero(user);
        }
        _game.updateHero(user);

        // TODO: optimize usage
        if (_game.getHero(_connection.localUser.id)) {
            _userControl.init(_game.getHero(_connection.localUser.id));
        }
    }

    private function handleRoomVarsUpdate(e: Event):void {
        var name: String = e.data.name;
        var data: Object = e.data.data;

        var except: Dictionary;
        var i: int;

        switch (name) {
            case RoomProps.CONFIG:
                GlobalProps.PROPERTIES = data;
                break;

            case RoomProps.LEVEL:
                LevelProps.LEVEL = data;

                _roomScreen.setBase(LevelProps.base);
                break;

            case RoomProps.MONSTERS:
                except = new Dictionary();
                var monsters: Array = data as Array;
                for (i = 0; i < monsters.length; i++) {
                    var monster: Object = monsters[i];

                    if (!_game.getEnemy(monster.id)) {
                        _game.addEnemy(monster);
                    }
                    except[monster.id] = _game.getEnemy(monster.id);
                    _game.updateEnemy(monster);
                }
                _game.clearEnemies(except);
                break;

            case RoomProps.BULLETS:
                except = new Dictionary();
                var bullets: Array = data as Array;
                for (var j:int = 0; j < bullets.length; j++) {
                    var bullet: Object = bullets[i];

                    if (!_game.getBullet(bullet.id)) {
                        _game.addBullet(bullet);
                    }
                    except[bullet.id] = _game.getBullet(bullet.id);
                    _game.updateBullet(bullet);
                }
                _game.clearBullets(except);
                break;

            case RoomProps.BASE:
                trace(name, data.hp);
                break;

            case RoomProps.RESULT:
                trace(name, data.win);
                _connection.leaveRoom();

                handleLoggedIn(null);
                break;
        }
    }
}
}
