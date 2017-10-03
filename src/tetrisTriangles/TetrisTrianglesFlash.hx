// OpenFL / NME version scales seem different in OpenFL and nme Jsprime but probably down to setup
package tetrisTriangles;
import flash.Lib;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import justTriangles.Triangle;
import tetrisTriangles.game.TetrisTriangles;
import justTriangles.Draw;
@:enum
abstract GameColors( Int ) to Int from Int {
    var Violet = 0xFF9400D3;
    var Indigo = 0xFF4b0082;
    var Blue   = 0xFF0000FF;
    var Green  = 0xFF00ff00;
    var Yellow = 0xFFFFFF00;
    var Orange = 0xFFFF7F00;
    var Red    = 0xFFFF0000;
    var Black  = 0xFF000000;
    var LightGrey = 0xFF444444;
    var MidGrey = 0xFF333333;
    var DarkGrey = 0xFF0c0c0c;
    var NearlyBlack = 0xFF111111;
}
  
class TetrisTrianglesFlash extends Sprite{ 
    var gameColors: Array<GameColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet, LightGrey, MidGrey, DarkGrey, NearlyBlack ]; 
    var tetrisTriangles: TetrisTriangles;
    var g: flash.display.Graphics;
    public static function main(): Void {
        Lib.current.addChild( new TetrisTrianglesFlash() );
    }
    public function new(){
        super();
        var viewSprite = new Sprite();
        g = viewSprite.graphics;
        addChild( viewSprite );
        Lib.current.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
        Draw.drawTri = Triangle.drawTri;
        var scale = 1.;
        #if jsprime 
        scale = 1.8;
        #end
        tetrisTriangles = new TetrisTriangles( scale );
        Lib.current.stage.addEventListener( Event.ENTER_FRAME, enterFrame );
    }
    
    inline function renderTriangles(){
        var tri: Triangle;
        var triangles = Triangle.triangles;
        var s = 300;
        var o = 400;
        g.clear();
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            //g.lineStyle( 0, 0xFF0000, 1 );
            g.moveTo( o + tri.ax * s, o + tri.ay * s );
            g.beginFill( gameColors[ tri.colorID ] );
            g.lineTo( o + tri.ax * s, o + tri.ay * s );
            g.lineTo( o + tri.bx * s, o + tri.by * s );
            g.lineTo( o + tri.cx * s, o + tri.cy * s );
            g.endFill();
        }
    }
    function enterFrame( evt: Event ) {
        tetrisTriangles.update();
        renderTriangles();
    }
    
    function onKeyDown( event: KeyboardEvent ): Void {
        if (event.keyCode == 27) { // ESC
            #if flash
                flash.system.System.exit(1);
            #elseif sys
                Sys.exit(1);
            #end
        }
    }
}