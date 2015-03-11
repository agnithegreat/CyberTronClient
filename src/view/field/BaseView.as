/**
 * Created by desktop on 02.03.2015.
 */
package view.field {
import assets.gui.BasePlaceView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Scale9Picture;

public class BaseView extends AbstractComponent {

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

    public function BaseView() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(BasePlaceView, "gui");
    }
}
}
