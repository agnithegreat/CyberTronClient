/**
 * Created by kirillvirich on 26.02.15.
 */
package {
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.requests.LoginRequest;

import starling.display.Sprite;

public class App extends Sprite implements IStartable {

    private var _sfs: SmartFox;

    public function start():void {
        initConnection();
    }

    private function initConnection():void {
        _sfs = new SmartFox();
        _sfs.addEventListener(SFSEvent.CONNECTION, onConnection);
        _sfs.addEventListener(SFSEvent.LOGIN, onLogin);
        _sfs.loadConfig();
    }

    private function doLogin():void {
        _sfs.send(new LoginRequest());
    }

    private function onConnection(e:SFSEvent):void {
        if (e.params.success) {
            doLogin();
        }
    }

    private function onLogin(e:SFSEvent):void {
    }
}
}
