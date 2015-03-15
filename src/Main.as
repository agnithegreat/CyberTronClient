/**
 * Created by kirillvirich on 26.02.15.
 */
package {

[SWF (frameRate=60, width=1000, height=800)]
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
