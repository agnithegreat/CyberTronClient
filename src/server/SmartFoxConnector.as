/**
 * Created by kirillvirich on 13.03.15.
 */
package server {
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.RoomVariable;
import com.smartfoxserver.v2.requests.ExtensionRequest;
import com.smartfoxserver.v2.requests.JoinRoomRequest;
import com.smartfoxserver.v2.requests.LeaveRoomRequest;
import com.smartfoxserver.v2.requests.LoginRequest;
import com.smartfoxserver.v2.requests.RoomExtension;
import com.smartfoxserver.v2.requests.game.CreateSFSGameRequest;
import com.smartfoxserver.v2.requests.game.SFSGameSettings;

import starling.events.EventDispatcher;

public class SmartFoxConnector extends EventDispatcher {

    public static const LOGGED_IN: String = "logged_in_SmartFoxConnector";
    public static const ROOM_JOINED: String = "room_joined_SmartFoxConnector";
    public static const USER_ENTER: String = "user_enter_SmartFoxConnector";
    public static const USER_LEAVE: String = "user_leave_SmartFoxConnector";
    public static const CONNECTION_LOST: String = "connection_lost_SmartFoxConnector";

    public static const USER_VARS_UPDATE: String = "user_vars_update_SmartFoxConnector";
    public static const ROOM_VARS_UPDATE: String = "room_vars_update_SmartFoxConnector";

    private var _sfs: SmartFox;

    public function get localUser():User {
        return _sfs.mySelf;
    }

    public function get roomList():Array {
        return _sfs.roomList;
    }

    public function get currentRoom():Room {
        return _sfs.lastJoinedRoom;
    }

    public function SmartFoxConnector() {
        super();
    }

    public function init():void {
        _sfs = new SmartFox();

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
        _sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);
    }

    public function connect():void {
        _sfs.loadConfig();
    }

    public function joinQuickGame():void {
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

            var settings: SFSGameSettings = new SFSGameSettings(roomName);
            settings.groupId = "game";
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

    public function leaveRoom():void {
        _sfs.send(new LeaveRoomRequest(currentRoom));
    }

    public function sendRequest(type: String, data: SFSObject):void {
        _sfs.send(new ExtensionRequest(type, data, _sfs.lastJoinedRoom));
    }



    private function onConnection(event:SFSEvent):void {
        // TODO: login
        _sfs.send(new LoginRequest(""));
    }

    private function onConnectionLost(event:SFSEvent):void {
        dispatchEventWith(CONNECTION_LOST);
    }

    private function onLogin(event:SFSEvent):void {
        dispatchEventWith(LOGGED_IN);
    }

    private function onLoginError(event:SFSEvent):void {

    }

    private function onRoomJoin(event:SFSEvent):void {
        var room:Room = event.params.room;

        dispatchEventWith(ROOM_JOINED, false, room);
    }

    private function onRoomJoinError(event:SFSEvent):void {
        trace(event.params.errorMessage, event.params.errorCode);
    }

    private function onPingPong(event:SFSEvent):void {

    }

    private function onUserEnterRoom(event:SFSEvent):void {
        dispatchEventWith(USER_ENTER, false, event.params.room);
    }

    private function onUserExitRoom(event:SFSEvent):void {
        dispatchEventWith(USER_LEAVE, false, event.params.user);
    }

    private function onExtensionResponse(event:SFSEvent):void {

    }

    private function onUserVarsUpdate(event:SFSEvent):void {
        dispatchEventWith(USER_VARS_UPDATE, false, event.params.user);
    }

    private function onRoomVarsUpdate(event:SFSEvent):void {
        var changedVars: Array = event.params.changedVars;

        var room: Room = event.params.room;
        if (room) {
            for (var i:int = 0; i < changedVars.length; i++) {
                var roomVar: RoomVariable = room.getVariable(changedVars[i]);
                dispatchEventWith(ROOM_VARS_UPDATE, false, {name: changedVars[i], data: roomVar.getValue()});
            }
        }
    }
}
}
