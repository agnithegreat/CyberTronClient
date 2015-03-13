/**
 * Created by kirillvirich on 05.03.15.
 */
package view.field {
import assets.gui.AimPlaceView;

import com.agnither.utils.gui.components.AbstractComponent;

import flash.geom.Point;

import starling.animation.IAnimatable;

import utils.TouchLogger;

public class AimView extends AbstractComponent implements IAnimatable{

    public function AimView() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(AimPlaceView, "gui");

        touchable = false;
    }

    public function advanceTime(time:Number):void {
        var touch: Point = TouchLogger.getTouchByTarget(parent);
        x = touch.x;
        y = touch.y;
    }
}
}
