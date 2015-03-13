/**
 * Created by kirillvirich on 05.03.15.
 */
package view.field {
import assets.gui.PersonagePlaceView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Picture;

import model.entities.Enemy;
import model.entities.GameItem;

import starling.events.Event;

public class EnemyView extends AbstractComponent {

    public function get dot():Picture {
        return getChild("dot") as Picture;
    }

    private var _enemy: Enemy;

    public function get color():int {
        return _enemy ? _enemy.color : 0;
    }

    public function EnemyView(enemy: Enemy) {
        _enemy = enemy;
    }

    override protected function initialize():void {
        createFromFlash(PersonagePlaceView, "gui");

        dot.color = color;

        _enemy.addEventListener(GameItem.UPDATE, handleUpdate);
    }

    private function handleUpdate(e: Event):void {
        x = _enemy.x;
        y = _enemy.y;
        dot.rotation = _enemy.direction;
    }

    override public function destroy():void {
        _enemy.removeEventListener(GameItem.UPDATE, handleUpdate);
        _enemy = null;

        super.destroy();
    }
}
}
