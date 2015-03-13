/**
 * Created by desktop on 04.03.2015.
 */
package view.field {
import assets.gui.PersonagePlaceView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Label;
import com.agnither.utils.gui.components.Picture;

import model.entities.GameItem;
import model.entities.Hero;

import starling.events.Event;

public class HeroView extends AbstractComponent {

    public function get label():Label {
        return getChild("label") as Label;
    }

    public function get dot():Picture {
        return getChild("dot") as Picture;
    }

    private var _hero: Hero;

    public function get color():int {
        return _hero ? _hero.color : 0;
    }

    public function HeroView(hero: Hero) {
        _hero = hero;

        super();
    }

    override protected function initialize():void {
        createFromFlash(PersonagePlaceView, "gui");

        label.text = _hero.name;
        label.color = color;
        dot.color = color;

        _hero.addEventListener(GameItem.UPDATE, handleUpdate);
    }

    private function handleUpdate(e: Event):void {
        x = Math.round(_hero.x);
        y = Math.round(_hero.y);

        dot.rotation = _hero.direction;
    }

    override public function destroy():void {
        _hero.removeEventListener(GameItem.UPDATE, handleUpdate);
        _hero = null;

        super.destroy();
    }
}
}
