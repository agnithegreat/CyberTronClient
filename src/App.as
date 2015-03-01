/**
 * Created by kirillvirich on 26.02.15.
 */
package {
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.requests.CreateRoomRequest;
import com.smartfoxserver.v2.requests.JoinRoomRequest;
import com.smartfoxserver.v2.requests.LoginRequest;
import com.smartfoxserver.v2.requests.game.CreateSFSGameRequest;
import com.smartfoxserver.v2.requests.game.SFSGameSettings;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

public class App extends Sprite implements IStartable {

    private var _sfs:SmartFox;

    private var _btn:Button;
    private var _user:Sprite;

    public function start():void {
        initConnection();
        initUI();
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
        _sfs.addEventListener(SFSEvent.USER_EXIT_ROOM, onUserExitRoom);
        _sfs.addEventListener(SFSEvent.USER_VARIABLES_UPDATE, onUserVarsUpdate);
//        _sfs.addEventListener(SFSEvent.PROXIMITY_LIST_UPDATE, onProximityListUpdate);
        _sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);

        _sfs.loadConfig();
    }

    private function initUI():void {
        _btn = new Button(Texture.fromColor(80, 30, 0xFF000000));
        _btn.addEventListener(Event.TRIGGERED, onPlay);
        addChild(_btn);
        _btn.visible = false;

        _user = new Sprite();
        addChild(_user);
    }

    private function onPlay(event: Event):void {
        _btn.visible = false;
        var room:Room = null;
        for (var i:int = 0; i < _sfs.roomList.length; i++) {
            var roomItem:Room = _sfs.roomList[i] as Room;
            trace(roomItem.name, roomItem.id, roomItem.groupId, roomItem.capacity, roomItem.isGame);
            if (roomItem.groupId == "game" && roomItem.userCount < roomItem.maxUsers) {
                room = roomItem;
//                sfs.send( new JoinRoomRequest( "Game" ) );
                break;
            }
//            if ((sfs.roomList[i] as Room).name == name_ti.text) {
//                break;
//            }
        }

        if (room) {
            _sfs.send(new JoinRoomRequest(room.name));
        }
        else {
            var roomName:String = "Game_" + String(Math.random() * 100000);
            roomName = roomName.substr(0, 32);
            trace("CREATE ROOM NAMED", roomName);

            var settings: SFSGameSettings = new SFSGameSettings(roomName);
//            var settings = new SFSGameSettings("Game");
            settings.groupId = "game";
//            settings.isGame = true;
            settings.maxUsers = 2;
            settings.maxSpectators = 0;
            settings.isPublic = true;
            settings.minPlayersToStartGame = 2;
            settings.notifyGameStarted = true;

            _sfs.send(new CreateSFSGameRequest(settings));
//            _sfs.send( new CreateRoomRequest(settings, true) );
        }
//         sfs.send( new JoinRoomRequest((sfs.roomList[0] as Room).name) );
//        var data : String =


    }

    private function onExtensionResponse(event:SFSEvent):void {

    }

    private function onUserVarsUpdate(event:SFSEvent):void {

    }

    private function onUserExitRoom(event:SFSEvent):void {

    }

    private function onRoomJoinError(event:SFSEvent):void {
        trace(event.params.errorMessage, event.params.errorCode);
    }

    private function onRoomJoin(event:SFSEvent):void {
        var room:Room = event.params.room;
        trace(room.name, room.id, room.userList);
    }

    private function onPingPong(event:SFSEvent):void {

    }

    private function onLoginError(event:SFSEvent):void {

    }

    private function onLogin(event:SFSEvent):void {
        trace(event);
        _btn.visible = true;
    }

    private function onConnectionLost(event:SFSEvent):void {

    }

    private function onConnection(event:SFSEvent):void {
        _sfs.send(new LoginRequest(""));
    }
}
}
