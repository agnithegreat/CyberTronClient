/**
 * Created by desktop on 03.03.2015.
 */
package view {
import assets.gui.MainMenuScreenView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Button;

public class MainMenu extends AbstractComponent {

    public function get connectButton():Button {
        return getChild("btn_connect") as Button;
    }

    public function MainMenu() {
    }

    override protected function initialize():void {
        createFromFlash(MainMenuScreenView, "gui");

        connectButton.label.text = "Connect";
    }
}
}
