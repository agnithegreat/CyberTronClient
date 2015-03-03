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
import com.smartfoxserver.v2.entities.variables.UserVariable;
import com.smartfoxserver.v2.requests.ExtensionRequest;
import com.smartfoxserver.v2.requests.JoinRoomRequest;
import com.smartfoxserver.v2.requests.LoginRequest;
import com.smartfoxserver.v2.requests.RoomExtension;
import com.smartfoxserver.v2.requests.game.CreateSFSGameRequest;
import com.smartfoxserver.v2.requests.game.SFSGameSettings;

import flash.utils.getTimer;

import model.Properties;

import starling.display.Sprite;
import starling.events.Event;

import view.LobbyScreen;
import view.MainMenu;
import view.RoomScreen;

public class App extends Sprite implements IStartable {

    public static const INIT: String = "init";
    public static const LOGGED: String = "logged";
    public static const JOINED: String = "joined";

    private var _sfs:SmartFox;

    private var _mainMenu: MainMenu;
    private var _lobbyScreen: LobbyScreen;
    private var _roomScreen: RoomScreen;
    public static const MOVE_USER_EVT : String = "App.MOVE_USER_EVT";

    public function start():void {
        initGUI();
        initConnection();
        setState(INIT);
    }

    private function initGUI():void {
        Resources.addAtlas("gui", AtlasFactory.fromAtlasMC(Atlas1));

        _mainMenu = new MainMenu();
        addChild(_mainMenu);
        _mainMenu.addEventListener(Event.TRIGGERED, onConnect);

        _lobbyScreen = new LobbyScreen();
        addChild(_lobbyScreen);
        _lobbyScreen.addEventListener(Event.TRIGGERED, onQuickGame);

        _roomScreen = new RoomScreen();
        addChild(_roomScreen);
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
//        _sfs.addEventListener(SFSEvent.PROXIMITY_LIST_UPDATE, onProximityListUpdate);
        _sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);


        addEventListener(App.MOVE_USER_EVT, onMove)
    }

    private function onMove(event : Event) : void
    {
        _sfs.send( new ExtensionRequest(Properties.REQ_MOVE, event.data.params, _sfs.lastJoinedRoom) );
    }

    private function setState(state: String):void {
        switch (state) {
            case INIT:
                _mainMenu.visible = true;
                _lobbyScreen.visible = false;
                _roomScreen.visible = false;
                break;
            case LOGGED:
                _mainMenu.visible = false;
                _lobbyScreen.visible = true;
                _roomScreen.visible = false;
                break;
            case JOINED:
                _mainMenu.visible = false;
                _lobbyScreen.visible = false;
                _roomScreen.visible = true;
                break;
        }
    }

    private function onConnect(event:Event):void {
        _sfs.loadConfig();

        setState(LOGGED);
    }

    private function onQuickGame(event: Event):void {
        var room:Room = null;

        var gameRooms: Array = _sfs.getRoomListFromGroup("game");
        for (var i:int = 0; i < gameRooms.length; i++) {
            var roomItem:Room = gameRooms[i] as Room;
            trace(roomItem.name, roomItem.id, roomItem.capacity, roomItem.isGame);
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
            settings.extension = new RoomExtension("CyberTron", "com.toxicgames.cybertron.room.GameRoomExtension");

            _sfs.send(new CreateSFSGameRequest(settings));
        }
    }

    private function onExtensionResponse(event:SFSEvent):void {

    }

    private function onUserVarsUpdate(event:SFSEvent):void {
        trace("ON USER UPDATE");
//        var arr : Array = [];
//        var changedVars : Array = event.params.changedVars;
        var user : User = event.params.user;

//        trace(user.name, ":");
//        for (var i : int = 0; i < changedVars.length; i++) {
//            var key : String = changedVars[i];
//            trace(key, " = ",user.getVariable(key))
//        }

        _roomScreen.updateUsers(user);
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
        trace(room.name, room.id, room.userList);

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
        trace(event);
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
