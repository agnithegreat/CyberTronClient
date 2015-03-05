/**
 * Created by desktop on 02.03.2015.
 */
package view.field {
import assets.gui.FieldContainerView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Scale9Picture;
import com.smartfoxserver.v2.entities.User;

import flash.utils.Dictionary;

public class FieldView extends AbstractComponent {

    public function get back():Scale9Picture {
        return getChild("back") as Scale9Picture;
    }

    override public function set width(value: Number):void {
        back.width = value;
    }
    override public function get width():Number {
        return back.width;
    }

    override public function set height(value: Number):void {
        back.height = value;
    }
    override public function get height():Number {
        return back.height;
    }

    private var _dict: Dictionary = new Dictionary(true);

    private var _localPersonage: PersonageView;
    public function get localPersonage():PersonageView {
        return _localPersonage;
    }

    private var _container: AbstractComponent;

    public function FieldView() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(FieldContainerView, "gui");

        _container = new AbstractComponent();
        addChild(_container);
    }

    public function updateUser(user: User):void {
        if (!_dict[user]) {
            _dict[user] = new PersonageView(user);
            _container.addChild(_dict[user]);

            if (user.isItMe) {
                _localPersonage = _dict[user];
            }
        }
        (_dict[user] as PersonageView).update();
    }
}
}
