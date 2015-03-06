/**
 * Created by desktop on 02.03.2015.
 */
package view.field {
import assets.gui.FieldContainerView;

import com.agnither.utils.gui.components.AbstractComponent;
import com.agnither.utils.gui.components.Scale9Picture;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.SFSObject;

import flash.utils.Dictionary;

import model.BulletProps;
import model.MonsterProps;

import model.RequestProps;

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

    private var _personages: Dictionary = new Dictionary(true);
    private var _bullets: Dictionary = new Dictionary(true);
    private var _monsters: Dictionary = new Dictionary(true);

    private var _localPersonage: PersonageView;
    public function get localPersonage():PersonageView {
        return _localPersonage;
    }

    private var _container: AbstractComponent;

    private var _bulletCleans: int = 0;
    private var _monsterCleans : int = 0;

    public function FieldView() {
        super();
    }

    override protected function initialize():void {
        createFromFlash(FieldContainerView, "gui");

        _container = new AbstractComponent();
        addChild(_container);
    }

    public function showUsers(list: Array /* of User */):void {
        for (var user: User in _personages) {
            if (list.indexOf(user) < 0) {
                _personages[user].destroy();
                delete _personages[user];
            }
        }
    }

    public function updateUser(user: User):void {
        if (!_personages[user]) {
            _personages[user] = new PersonageView(user);
            _container.addChild(_personages[user]);

            if (user.isItMe) {
                _localPersonage = _personages[user];
            }
        }
        (_personages[user] as PersonageView).update();
    }

    public function updateBullet(bullet: SFSObject, user: User):void {
        var id: int = bullet.getInt(BulletProps.ID);

        if (!_bullets[id]) {
            _bullets[id] = new BulletView();
            _container.addChild(_bullets[id]);
            _bullets[id].bullet.color = _personages[user].color;
        }
        (_bullets[id] as BulletView).update(bullet, _bulletCleans);
    }

    public function cleanBullets():void {
        for (var key: int in _bullets) {
            if (_bullets[key].cleanId < _bulletCleans) {
                _bullets[key].destroy();
                delete _bullets[key];
            }
        }
        _bulletCleans++;
    }

    public function updateMonster(monster : SFSObject) : void
    {
        var id: int = monster.getInt(MonsterProps.ID);

        if (!_monsters[id]) {
            _monsters[id] = new MonsterView();
            _container.addChild(_monsters[id]);
//            _monsters[id].bullet.color = _personages[user].color;
        }
        (_monsters[id] as MonsterView).update(monster, _monsterCleans);
    }

    public function cleanMonsters() : void
    {
        for (var key: int in _monsters) {
            if (_monsters[key].cleanId < _monsterCleans) {
                _monsters[key].destroy();
                delete _monsters[key];
            }
        }
        _monsterCleans++;
    }
}
}
