/**
 * Created by kirillvirich on 05.03.15.
 */
package view.field {
import assets.gui.BulletShotView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Picture;
import com.smartfoxserver.v2.entities.data.SFSObject;

import model.BulletProps;

import model.RequestProps;

import utils.TouchLogger;

public class BulletView extends AbstractComponent {

    public function get bullet():Picture {
        return getChild("bullet") as Picture;
    }

    private var _cleanId: int;
    public function get cleanId():int {
        return _cleanId;
    }

    public function BulletView() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(BulletShotView, "gui");

        touchable = false;
    }

    public function update(data: SFSObject, cleanId: int):void {
        x = data.getInt(BulletProps.POSX);
        y = data.getInt(BulletProps.POSY);
        rotation = data.getFloat(BulletProps.DIRECTION);

        _cleanId = cleanId;
    }
}
}
