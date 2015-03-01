package {

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.requests.CreateRoomRequest;
import com.smartfoxserver.v2.requests.JoinRoomRequest;
import com.smartfoxserver.v2.requests.LoginRequest;
import com.smartfoxserver.v2.requests.RoomSettings;
import com.smartfoxserver.v2.requests.game.CreateSFSGameRequest;
import com.smartfoxserver.v2.requests.game.SFSGameSettings;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.MouseEvent;
import flash.text.TextField;

public class Main_V extends Sprite {
    private var sfs : SmartFox;
    private var _btn : Sprite;
    private var _user : Sprite;
    public function Main_V() {

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        sfs = new SmartFox();

        // Add SFS2X event listeners
        sfs.addEventListener(SFSEvent.CONNECTION, onConnection);
        sfs.addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost);
        sfs.addEventListener(SFSEvent.LOGIN, onLogin);
        sfs.addEventListener(SFSEvent.LOGIN_ERROR, onLoginError);
        sfs.addEventListener(SFSEvent.PING_PONG, onPingPong);
        sfs.addEventListener(SFSEvent.ROOM_JOIN, onRoomJoin);
        sfs.addEventListener(SFSEvent.ROOM_JOIN_ERROR, onRoomJoinError);
        sfs.addEventListener(SFSEvent.USER_EXIT_ROOM, onUserExitRoom);
        sfs.addEventListener(SFSEvent.USER_VARIABLES_UPDATE, onUserVarsUpdate);
//        sfs.addEventListener(SFSEvent.PROXIMITY_LIST_UPDATE, onProximityListUpdate);
        sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);

        // Connect
        sfs.loadConfig();


        _btn = new Sprite();
        addChild(_btn);
        _btn.graphics.beginFill(0);
        _btn.graphics.drawRect(0,0, 80,30);
        _btn.addEventListener(MouseEvent.CLICK, onPlay);
        _btn.visible = false;


        _user = new Sprite();
        addChild(_user);
    }

    private function onPlay(event : MouseEvent) : void
    {
        _btn.visible = false;
        var room : Room = null;
        for (var i:int = 0; i < sfs.roomList.length; i++)
        {
            var roomItem : Room = sfs.roomList[i] as Room;
            trace(roomItem.name, roomItem.id, roomItem.groupId, roomItem.capacity, roomItem.isGame);
            if(roomItem.groupId == "game" && roomItem.userCount < roomItem.maxUsers) {
                room = roomItem;
//                sfs.send( new JoinRoomRequest( "Game" ) );
                break;
            }
//            if ((sfs.roomList[i] as Room).name == name_ti.text)
//            {
//                break;
//            }
        }

        if(room)
        {
            sfs.send( new JoinRoomRequest( room.name ) );
        }
        else
        {
            var roomName : String = "Game " + uint(Math.random() * uint.MAX_VALUE);
            roomName = roomName.substr(0, 32);
            trace("CREATE ROOM NAMED", roomName);

            var settings = new SFSGameSettings(roomName);
//            var settings = new SFSGameSettings("Game");
            settings.groupId = "game";
//            settings.isGame = true;
            settings.maxUsers = 2;
            settings.maxSpectators = 0;
            settings.isPublic = true;
            settings.minPlayersToStartGame = 2;
            settings.notifyGameStarted = true;

            sfs.send( new CreateSFSGameRequest( settings ) );
//            sfs.send( new CreateRoomRequest( rs, true) );
        }
//         sfs.send( new JoinRoomRequest((sfs.roomList[0] as Room).name) );
//        var data : String =


    }

    private function onExtensionResponse(event : SFSEvent) : void
    {

    }

    private function onUserVarsUpdate(event : SFSEvent) : void
    {

    }

    private function onUserExitRoom(event : SFSEvent) : void
    {

    }

    private function onRoomJoinError(event : SFSEvent) : void
    {
        trace(event.params.errorMessage, event.params.errorCode);
    }

    private function onRoomJoin(event : SFSEvent) : void
    {
        var room : Room = event.params.room;
        trace(room.name, room.id, room.userList);



    }

    private function onPingPong(event : SFSEvent) : void
    {

    }

    private function onLoginError(event : SFSEvent) : void
    {

    }

    private function onLogin(event : SFSEvent) : void
    {
        trace(event.toString());
        _btn.visible = true;
    }

    private function onConnectionLost(event : SFSEvent) : void
    {

    }

    private function onConnection(event : SFSEvent) : void
    {
        sfs.send(new LoginRequest(""));
    }
}
}
