/**
 * Created by kirillvirich on 26.02.15.
 */
package {

[SWF (frameRate=60, width=1024, height=768)]
public class Main extends StarlingMainBase {

    public function Main() {
        super(App);
    }

    override protected function initializeStarling():void {
        super.initializeStarling();

        showStats = true;
    }
}
}
