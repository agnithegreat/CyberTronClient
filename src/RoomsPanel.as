/**
 * Created by desktop on 01.03.2015.
 */
package {
import assets.gui.RoomsPanelView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Button;

public dynamic class RoomsPanel extends AbstractComponent {

    public static const INIT: String = "init";
    public static const LOGGED: String = "logged";
    public static const JOINED: String = "joined";

    public function get quickGame():Button {
        return this.btn_quickGame;
    }

    public function RoomsPanel() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(RoomsPanelView, "gui");

        quickGame.label.text = "Quick Game";
    }

    public function setState(state: String):void {
        quickGame.visible = state == LOGGED;
    }
}
}
