# trilateral3base

Provides a base WebGL Main 'TrilateralBase' as an abstract class for use with Trilateral3.

```Haxe
function main(){
    // flower is defined in Flower.hx as
    // inline var png: String = " data:image/jpeg;base64...
    // this allows local testing.
    new Main( 1000, 1000, Flower.png );
}
class Main extends TrilateralBase {
    public
    function new( width: Int, height: Int, flower: String ){
        super( width, height, flower );
    }
    function firstDraw(){
        // draw stuff //
        /*
        var posMin = 0;
        sketchColor.moveTo(0,0);
        var range = posMin...Std.int( penColor.pos - 1 );
        */
        // add it to the shapes //
        /*
        draw_Shape[ draw_Shape.length ] = { textured: false
                                           , range:    range
                                           , bgColor:  RED };
        */
    }
    function renderAnimate(){
        // adjust stuff every frame
    }
}
```
