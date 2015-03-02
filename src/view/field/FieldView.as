/**
 * Created by desktop on 02.03.2015.
 */
package view.field {
import assets.gui.FieldContainerView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Scale9Picture;

public class FieldView extends AbstractComponent {

    public function get field():Scale9Picture {
        return _children.field_back;
    }

    override public function set width(value: Number):void {
        field.width = value;
    }
    override public function get width():Number {
        return field.width;
    }

    override public function set height(value: Number):void {
        field.height = value;
    }
    override public function get height():Number {
        return field.height;
    }

    public function FieldView() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(FieldContainerView, "gui");
    }
}
}
