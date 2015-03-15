/**
 * Created by desktop on 03.03.2015.
 */
package view.screens {
import assets.gui.MainMenuScreenView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Button;

import controller.GameController;

import starling.events.Event;

public class MainMenu extends AbstractComponent {

    public function get connectButton():Button {
        return getChild("btn_connect") as Button;
    }

    public function MainMenu() {
    }

    override protected function initialize():void {

        createFromFlash(MainMenuScreenView, "gui");

        connectButton.label.text = "Connect";
        connectButton.addEventListener(Event.TRIGGERED, handleConnect);
    }

    private function handleConnect(e: Event):void {
        dispatchEventWith(GameController.COMMAND, true, {type:GameController.CONNECT});




    }
}
}
