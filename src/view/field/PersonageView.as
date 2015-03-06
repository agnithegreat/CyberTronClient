/**
 * Created by desktop on 04.03.2015.
 */
package view.field {
import assets.gui.PersonagePlaceView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Label;
import com.agnither.utils.gui.components.Picture;
import com.smartfoxserver.v2.entities.User;

import model.PersonageProps;

import model.RequestProps;

public class PersonageView extends AbstractComponent {

    public function get label():Label {
        return getChild("label") as Label;
    }

    public function get dot():Picture {
        return getChild("dot") as Picture;
    }

    private var _user: User;

    private var _color: int;
    public function get color():int {
        return _color;
    }

    public function PersonageView(user: User) {
        _user = user;

        super();
    }

    override protected function initialize():void {
        createFromFlash(PersonagePlaceView, "gui");

        _color = _user.getVariable(PersonageProps.COLOR).getIntValue();

        label.text = _user.name;
        label.color = _color;
        dot.color = _color;
    }

    public function update():void {
        x = _user.getVariable(PersonageProps.POSX).getIntValue();
        y = _user.getVariable(PersonageProps.POSY).getIntValue();

        if (_user.getVariable(PersonageProps.DIRECTION)) {
            dot.rotation = _user.getVariable(PersonageProps.DIRECTION).getDoubleValue();
        }
    }
}
}
