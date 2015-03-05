/**
 * Created by desktop on 03.03.2015.
 */
package view {
import assets.gui.MainMenuScreenView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Button;
import com.agnither.utils.gui.components.Label;

public class MainMenu extends AbstractComponent {

    public function get console():Label {
        return getChild("console") as Label;
    }

    public function get connectButton():Button {
        return getChild("btn_connect") as Button;
    }

    public function MainMenu() {
    }

    override protected function initialize():void {
        createFromFlash(MainMenuScreenView, "gui");

        connectButton.label.text = "Connect";
    }

    public function traceToConsole(text: String):void {
        console.text += text + "\n";
    }
}
}
