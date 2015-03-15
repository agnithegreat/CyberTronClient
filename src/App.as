/**
 * Created by kirillvirich on 26.02.15.
 */
package {
import controller.GameController;

import starling.display.Sprite;

public class App extends Sprite implements IStartable {

    private var _gameController: GameController;

    public function start():void {
        _gameController = new GameController();
        _gameController.init(this);
    }
}
}