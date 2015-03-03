/**
 * Created by desktop on 04.03.2015.
 */
package view.field {
import assets.gui.PersonagePlaceView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Label;
import com.agnither.utils.gui.components.Picture;
import com.smartfoxserver.v2.entities.User;

public class PersonageView extends AbstractComponent {

    public function get label():Label {
        return getChild("label") as Label;
    }

    public function get dot():Picture {
        return getChild("dot") as Picture;
    }

    private var _user: User;

    public function PersonageView(user: User) {
        _user = user;

        super();
    }

    override protected function initialize():void {
        createFromFlash(PersonagePlaceView, "gui");

        label.text = _user.name;
        label.color = _user.getVariable("color").getIntValue();
        dot.color = _user.getVariable("color").getIntValue();
    }

    public function update():void {
        x = _user.getVariable("posX").getIntValue() * 2;
        y = _user.getVariable("posY").getIntValue() * 2;
    }
}
}
