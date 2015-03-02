/**
 * Created by kirillvirich on 02.03.15.
 */
package view {
import assets.gui.UserNameView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Label;

public dynamic class UserNameTile extends AbstractComponent {

    public function get userName():Label {
        return this.userName_label;
    }

    override public function set width(value: Number):void {
        userName.width = value;
    }

    override public function get width():Number {
        return userName.width;
    }

    public function UserNameTile() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(UserNameView, "gui");
    }
}
}
