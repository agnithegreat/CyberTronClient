/**
 * Created by kirillvirich on 05.03.15.
 */
package view.field {
import assets.gui.BulletShotView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Picture;
import com.smartfoxserver.v2.entities.data.SFSObject;

import model.Properties;

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
        x = data.getInt(Properties.VAR_POSX);
        y = data.getInt(Properties.VAR_POSY);
        rotation = data.getFloat(Properties.VAR_DIRECTION);

        _cleanId = cleanId;
    }
}
}
