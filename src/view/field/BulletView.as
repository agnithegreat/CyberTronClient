/**
 * Created by kirillvirich on 05.03.15.
 */
package view.field {
import assets.gui.BulletShotView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Picture;

import model.entities.Bullet;
import model.entities.GameItem;

import starling.events.Event;

public class BulletView extends AbstractComponent {

    public function get bullet():Picture {
        return getChild("bullet") as Picture;
    }

    private var _bullet: Bullet;

    public function BulletView(bullet: Bullet) {
        _bullet = bullet;
    }

    override protected function initialize():void {
        createFromFlash(BulletShotView, "gui");

        bullet.color = _bullet.color;

        _bullet.addEventListener(GameItem.UPDATE, handleUpdate);
    }

    private function handleUpdate(e: Event):void {
        x = _bullet.x;
        y = _bullet.y;
        bullet.rotation = _bullet.direction;
    }
}
}
