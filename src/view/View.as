/**
 * Created by kirillvirich on 13.03.15.
 */
package view {
import com.smartfoxserver.v2.entities.Room;

import controller.GameController;

import flash.ui.Mouse;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;

import view.screens.LobbyScreen;
import view.screens.MainMenu;
import view.screens.RoomScreen;

import view.field.AimView;

public class View extends Sprite {

    private var _mainMenu: MainMenu;
    private var _lobbyScreen: LobbyScreen;
    private var _roomScreen: RoomScreen;

    private var _cursor: AimView;

    private var _controller: GameController;

    public function View(controller: GameController) {
        _controller = controller;
        _controller.addEventListener(GameController.STATE_UPDATE, handleStateUpdate);
        _controller.addEventListener(GameController.ROOMS_UPDATE, handleRoomsUpdate);
        _controller.addEventListener(GameController.ROOM_UPDATE, handleRoomUpdate);
    }

    public function init():void {
        _mainMenu = new MainMenu();
        addChild(_mainMenu);

        _lobbyScreen = new LobbyScreen();
        addChild(_lobbyScreen);

        _roomScreen = new RoomScreen();
        addChild(_roomScreen);
        _roomScreen.field.init(_controller.game);

        _cursor = new AimView();
        addChild(_cursor);
        Starling.juggler.add(_cursor);
        Mouse.hide();
    }

    private function handleStateUpdate(e: Event):void {
        var state: String = e.data as String;
        switch (state) {
            case GameController.INIT:
                _mainMenu.visible = true;
                _lobbyScreen.visible = false;
                _roomScreen.visible = false;
                break;
            case GameController.LOGGED:
                _mainMenu.visible = false;
                _lobbyScreen.visible = true;
                _roomScreen.visible = false;
                break;
            case GameController.JOINED:
                _mainMenu.visible = false;
                _lobbyScreen.visible = false;
                _roomScreen.visible = true;
                break;
        }

    }

    private function handleRoomsUpdate(e: Event):void {
        _lobbyScreen.showRooms(e.data as Array);
    }

    private function handleRoomUpdate(e: Event):void {
        var room: Room = e.data as Room;
        _roomScreen.showRoom(room ? room.name : "");
        _roomScreen.showUsers(room ? room.userList : []);
    }
}
}
