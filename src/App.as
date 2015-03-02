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
import com.smartfoxserver.v2.requests.JoinRoomRequest;
import com.smartfoxserver.v2.requests.LoginRequest;
import com.smartfoxserver.v2.requests.game.CreateSFSGameRequest;
import com.smartfoxserver.v2.requests.game.SFSGameSettings;

import starling.display.Sprite;
import starling.events.Event;

import view.lobby.LobbyPanel;
import view.room.RoomPanel;

public class App extends Sprite implements IStartable {

    public static const INIT: String = "init";
    public static const LOGGED: String = "logged";
    public static const JOINED: String = "joined";

    private var _sfs:SmartFox;

    private var _lobbyPanel: LobbyPanel;
    private var _roomPanel: RoomPanel;

    public function start():void {
        initGUI();
        initConnection();
    }

    private function initGUI():void {
        Resources.addAtlas("gui", AtlasFactory.fromAtlasMC(Atlas1));

        _lobbyPanel = new LobbyPanel();
        addChild(_lobbyPanel);
        _lobbyPanel.width = 250;
        _lobbyPanel.height = 500;
        _lobbyPanel.quickGame.addEventListener(Event.TRIGGERED, onPlay);

        _roomPanel = new RoomPanel();
        addChild(_roomPanel);

        _roomPanel.x = 550;
        _roomPanel.width = 250;
        _roomPanel.height = 500;
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

        _sfs.loadConfig();

        _lobbyPanel.setState(INIT);
    }

    private function onPlay(event: Event):void {
        _lobbyPanel.setState(JOINED);
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
            var roomName:String = "Game_" + uint(Math.random() * uint.MAX_VALUE);
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

            _sfs.send(new CreateSFSGameRequest(settings));
        }
    }

    private function onExtensionResponse(event:SFSEvent):void {

    }

    private function onUserVarsUpdate(event:SFSEvent):void {

    }

    private function onUserEnterRoom(event:SFSEvent):void {
        var room:Room = event.params.room;
        _roomPanel.showUsers(room.userList);
    }

    private function onUserExitRoom(event:SFSEvent):void {
        var room:Room = event.params.room;
        _roomPanel.showUsers(room.userList);
    }

    private function onRoomJoinError(event:SFSEvent):void {
        trace(event.params.errorMessage, event.params.errorCode);
    }

    private function onRoomJoin(event:SFSEvent):void {
        var room:Room = event.params.room;
        trace(room.name, room.id, room.userList);

        _lobbyPanel.showRooms(_sfs.roomList);
        _roomPanel.showRoom(room.name);
        _roomPanel.showUsers(room.userList);
    }

    private function onPingPong(event:SFSEvent):void {

    }

    private function onLoginError(event:SFSEvent):void {

    }

    private function onLogin(event:SFSEvent):void {
        trace(event);
        _lobbyPanel.setState(LOGGED);
        _lobbyPanel.showRooms(_sfs.roomList);
    }

    private function onConnectionLost(event:SFSEvent):void {

    }

    private function onConnection(event:SFSEvent):void {
        _sfs.send(new LoginRequest(""));
    }
}
}
