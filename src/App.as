/**
 * Created by kirillvirich on 26.02.15.
 */
package {
import assets.gui.Atlas1;

import com.agnither.utils.gui.Resources;
import com.agnither.utils.gui.atlas.AtlasFactory;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.RoomVariable;
import com.smartfoxserver.v2.requests.ExtensionRequest;
import com.smartfoxserver.v2.requests.JoinRoomRequest;
import com.smartfoxserver.v2.requests.LeaveRoomRequest;
import com.smartfoxserver.v2.requests.LoginRequest;
import com.smartfoxserver.v2.requests.RoomExtension;
import com.smartfoxserver.v2.requests.game.CreateSFSGameRequest;
import com.smartfoxserver.v2.requests.game.SFSGameSettings;

import control.UserControl;

import flash.ui.Mouse;

import model.entities.Bullet;
import model.entities.Enemy;

import model.entities.Game;
import model.entities.Hero;

import model.properties.BulletProps;
import model.properties.GlobalProps;
import model.properties.LevelProps;
import model.properties.MonsterProps;
import model.properties.PersonageProps;
import model.properties.RequestProps;
import model.properties.RoomProps;

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

    public static const MOVE_USER_EVT : String = "App.MOVE_USER_EVT";
    public static const ROTATE_USER_EVT : String = "App.ROTATE_USER_EVT";
    public static const SHOT_USER_EVT : String = "App.SHOT_USER_EVT";

    private var _sfs:SmartFox;

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
        _sfs = new SmartFox();

        // Add SFS2X event listeners
        _sfs.addEventListener(SFSEvent.CONNECTION, onConnection);
        _sfs.addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost);
        _sfs.addEventListener(SFSEvent.LOGIN, onLogin);
        _sfs.addEventListener(SFSEvent.LOGIN_ERROR, onLoginError);
        _sfs.addEventListener(SFSEvent.PING_PONG, onPingPong);
        _sfs.addEventListener(SFSEvent.ROOM_JOIN, onRoomJoin);
        _sfs.addEventListener(SFSEvent.ROOM_JOIN_ERROR, onRoomJoinError);
        _sfs.addEventListener(SFSEvent.USER_ENTER_ROOM, onUserEnterRoom);
        _sfs.addEventListener(SFSEvent.USER_EXIT_ROOM, onUserExitRoom);
        _sfs.addEventListener(SFSEvent.USER_VARIABLES_UPDATE, onUserVarsUpdate);
        _sfs.addEventListener(SFSEvent.ROOM_VARIABLES_UPDATE, onRoomVarsUpdate);
//        _sfs.addEventListener(SFSEvent.PROXIMITY_LIST_UPDATE, onProximityListUpdate);
        _sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);
    }

    private function initControl():void {
        KeyLogger.init(stage);
        TouchLogger.init(stage);

        _userControl = new UserControl();
        _userControl.addEventListener(App.MOVE_USER_EVT, onMove);
        _userControl.addEventListener(App.ROTATE_USER_EVT, onRotate);
        _userControl.addEventListener(App.SHOT_USER_EVT, onShot);

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
        _sfs.loadConfig();
    }

    private function onQuickGame(event: Event):void {
        var room:Room = null;

        var gameRooms: Array = _sfs.getRoomListFromGroup("game");
        for (var i:int = 0; i < gameRooms.length; i++) {
            var roomItem:Room = gameRooms[i] as Room;
            if (roomItem.userCount < roomItem.maxUsers) {
                room = roomItem;
                break;
            }
        }

        if (room) {
            _sfs.send(new JoinRoomRequest(room.name));
        } else {
            var roomName:String = "Game_" + (new Date()).time;
            roomName = roomName.substr(0, 32);
            trace("CREATE ROOM NAMED", roomName);

            var settings: SFSGameSettings = new SFSGameSettings(roomName);
            settings.groupId = "game";
//            settings.isGame = true;
            settings.maxUsers = 4;
            settings.maxSpectators = 0;
            settings.isPublic = true;
            settings.minPlayersToStartGame = 2;
            settings.notifyGameStarted = true;
            settings.maxVariables = 10;
            settings.extension = new RoomExtension("CyberTron", "com.toxicgames.cybertron.room.GameRoomExtension");

            _sfs.send(new CreateSFSGameRequest(settings));
        }
    }

    private function onMove(event: Event):void {
        _sfs.send(new ExtensionRequest(RequestProps.REQ_MOVE, event.data as SFSObject, _sfs.lastJoinedRoom));
    }

    private function onRotate(event: Event):void {
        _sfs.send(new ExtensionRequest(RequestProps.REQ_ROTATE, event.data as SFSObject, _sfs.lastJoinedRoom));

        var hero: Hero = _game.getHero(_sfs.mySelf.id);
        hero.direction = (event.data as SFSObject).getFloat(PersonageProps.DIRECTION);
        hero.update();
    }

    private function onShot(event: Event):void {
        _sfs.send(new ExtensionRequest(RequestProps.REQ_SHOT, event.data as SFSObject, _sfs.lastJoinedRoom));
    }

    private function onExtensionResponse(event:SFSEvent):void {

    }

    private function onUserVarsUpdate(event:SFSEvent):void {
        if (!GlobalProps.PROPERTIES) {
            return;
        }

        var user : User = event.params.user;

        var hero: Hero = _game.getHero(user.id);
        if (!hero) {
            _game.addHero(user);
            hero = _game.getHero(user.id);
        }
        hero.x = user.getVariable(PersonageProps.POSX).getIntValue();
        hero.y = user.getVariable(PersonageProps.POSY).getIntValue();
        if (user.getVariable(PersonageProps.DIRECTION)) {
            hero.direction = user.getVariable(PersonageProps.DIRECTION).getDoubleValue();
        }
        hero.update();

        if (_game.getHero(_sfs.mySelf.id)) {
            _userControl.init(_game.getHero(_sfs.mySelf.id));
        }
    }

    private function onRoomVarsUpdate(event:SFSEvent):void {
        var changedVars: Array = event.params.changedVars;

        var user: User;

        var room: Room = event.params.room;
        if (room) {
            for (var i:int = 0; i < changedVars.length; i++) {
                var roomVar: RoomVariable = room.getVariable(changedVars[i]);
                switch (changedVars[i]) {
                    case RoomProps.CONFIG:
                        GlobalProps.PROPERTIES = roomVar.getSFSObjectValue().toObject();
                        break;

                    case RoomProps.LEVEL:
                        LevelProps.LEVEL = roomVar.getSFSObjectValue().toObject();

                        _roomScreen.setBase(LevelProps.base);
                        break;

                    case RoomProps.BULLETS:
                        var bullets:Object = roomVar.getSFSArrayValue();
                        for (var j:int = 0; j < bullets.size(); j++) {
                            var bulletObj:SFSObject = bullets.getElementAt(j) as SFSObject;

                            user = room.getUserById(bulletObj.getInt(BulletProps.USER));
                            var bullet: Bullet = _game.getBullet(bulletObj.getInt(BulletProps.ID));
                            if (!bullet) {
                                _game.addBullet(bulletObj.toObject());
                                bullet = _game.getBullet(bulletObj.getInt(BulletProps.ID));
                                bullet.color = _game.getHero(user.id).color;
                            }
                            bullet.x = bulletObj.getInt(BulletProps.POSX);
                            bullet.y = bulletObj.getInt(BulletProps.POSY);
                            bullet.direction = bulletObj.getInt(BulletProps.DIRECTION);
                            bullet.update();
                        }
                        break;

                    case RoomProps.MONSTERS:
                        var monsters:ISFSArray = roomVar.getSFSArrayValue();
                        for (i = 0; i < monsters.size(); i++) {
                            var monsterData:SFSObject = monsters.getElementAt(i) as SFSObject;

                            user = room.getUserById(monsterData.getInt(MonsterProps.USER));
                            var monster: Enemy = _game.getEnemy(monsterData.getInt(MonsterProps.ID));
                            if (!monster) {
                                _game.addEnemy(monsterData.toObject());
                                monster = _game.getEnemy(monsterData.getInt(MonsterProps.ID));
                            }
                            monster.x = monsterData.getInt(MonsterProps.POSX);
                            monster.y = monsterData.getInt(MonsterProps.POSY);
                            monster.direction = monsterData.getInt(MonsterProps.DIRECTION);
                            monster.update();
                        }
                        break;

                    case RoomProps.BASE:
                        trace(roomVar.getSFSObjectValue().getInt("hp"));
                        break;

                    case RoomProps.RESULT:
                        var win: Boolean = roomVar.getSFSObjectValue().getBool("win");
                        _sfs.send(new LeaveRoomRequest(room));

                        onLogin(null);
                        break;
                }
            }
        }
    }

    private function onUserEnterRoom(event:SFSEvent):void {
        var room:Room = event.params.room;
        _roomScreen.showUsers(room.userList);
    }

    private function onUserExitRoom(event:SFSEvent):void {
        var room:Room = event.params.room;
        _roomScreen.showUsers(room.userList);
    }

    private function onRoomJoinError(event:SFSEvent):void {
        trace(event.params.errorMessage, event.params.errorCode);
    }

    private function onRoomJoin(event:SFSEvent):void {
        var room:Room = event.params.room;

        setState(JOINED);

        _lobbyScreen.showRooms(_sfs.roomList);
        _roomScreen.showRoom(room.name);
        _roomScreen.showUsers(room.userList);
    }

    private function onPingPong(event:SFSEvent):void {

    }

    private function onLoginError(event:SFSEvent):void {

    }

    private function onLogin(event:SFSEvent):void {
        setState(LOGGED);
        _lobbyScreen.showRooms(_sfs.roomList);
    }

    private function onConnectionLost(event:SFSEvent):void {
        setState(INIT);
    }

    private function onConnection(event:SFSEvent):void {
        _sfs.send(new LoginRequest(""));
    }
}
}
