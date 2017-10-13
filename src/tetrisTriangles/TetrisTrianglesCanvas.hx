package tetrisTriangles;
import js.Browser;
import htmlHelper.canvas.CanvasWrapper;
import js.html.CanvasRenderingContext2D;
import justDrawing.Surface;
import justTriangles.Triangle;
import justTriangles.Point;
import justTriangles.Draw;
import tetrisTriangles.game.Tetris;
import htmlHelper.tools.AnimateTimer; 
import js.html.Event;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
@:enum
abstract GameColors( Int ) to Int from Int {
    var Violet      = 0x9400D3;
    var Indigo      = 0x4b0082;
    var Blue        = 0x0000FF;
    var Green       = 0x00ff00;
    var Yellow      = 0xFFFF00;
    var Orange      = 0xFF7F00;
    var Red         = 0xFF0000;
    var Black       = 0x000000;
    var LightGrey   = 0x444444;
    var MidGrey     = 0x333333;
    var DarkGrey    = 0x0c0c0c;
    var NearlyBlack = 0x111111;
    var White       = 0xFFFFFF;
    var BlueAlpha   = 0x0000FF;
    var GreenAlpha  = 0x00FF00;
    var RedAlpha    = 0xFF0000;
}
class TetrisTrianglesCanvas {
    var surface: Surface;
    var tetris: Tetris;
    var gameColors:         Array<GameColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet
                                            , LightGrey, MidGrey, DarkGrey, NearlyBlack, White
                                            , BlueAlpha, GreenAlpha, RedAlpha ]; 
    var leftDown:           Bool = false;
    var rightDown:          Bool = false;
    var downDown:           Bool = false;
    var upDown:             Bool = false;
    public static function main(){ new TetrisTrianglesCanvas(); } public function new(){
        var canvas = new CanvasWrapper();
        canvas.width = 1024;
        canvas.height = 768;
        Browser.document.body.appendChild( cast canvas );
        surface = new Surface( canvas.getContext2d() );
        Draw.drawTri = Triangle.drawTri;
        tetris = new Tetris( 1 );
        AnimateTimer.create();
        AnimateTimer.onFrame = render;
        Browser.document.onkeydown = keyDown;
        Browser.document.onkeyup = keyUp;
    }
    
    function render( i: Int ):Void{
        //update();
        tetris.update();
        renderTriangles();
    }
    inline function renderTriangles(){
        var tri: Triangle;
        var triangles = Triangle.triangles;
        var s = 300;
        var ox = 300;
        var oy = 20;
        var g = surface;
        g.beginFill( 0x181818, 1. );
        g.lineStyle( 0., 0x000000, 0. );
        g.drawRect( 1, 1, 1024-2, 768-2 );
        g.endFill();
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            g.beginFill( gameColors[ tri.colorID ] );
            g.drawTri( [   ox + tri.ax * s, oy + tri.ay * s
                        ,  ox + tri.bx * s, oy + tri.by * s
                        ,  ox + tri.cx * s, oy + tri.cy * s ] );
            g.endFill();
        }
    }
    inline
    function keyDown( e: KeyboardEvent ) {
        e.preventDefault();
        var keyCode = e.keyCode;
        switch( keyCode ){
            case KeyboardEvent.DOM_VK_LEFT:
                leftDown    = true;
            case KeyboardEvent.DOM_VK_RIGHT:
                rightDown   = true;
            case KeyboardEvent.DOM_VK_UP:
                upDown      = true;
            case KeyboardEvent.DOM_VK_DOWN:
                downDown    = true;
            default: 
        }
        update(); // not sure if this ideal?
    }
    inline
    function keyUp( e: KeyboardEvent ) {
        e.preventDefault();
        var keyCode = e.keyCode;
        switch(keyCode){
            case KeyboardEvent.DOM_VK_LEFT:
                leftDown    = false;
            case KeyboardEvent.DOM_VK_RIGHT:
                rightDown   = false;
            case KeyboardEvent.DOM_VK_UP:
                upDown      = false;
            case KeyboardEvent.DOM_VK_DOWN:
                downDown    = false;
            default: 
        }
    }
    inline
    function update(): Void {
        if( upDown ){
            tetris.rotate( 1 );
        } else if( downDown ){
            tetris.move(  0, 1 );
        }
        if( leftDown ) {
            tetris.move( -1, 0 );
        } else if( rightDown ) {
            tetris.move(  1, 0 );
        }
        leftDown    = false;
        rightDown   = false;
        downDown    = false;
        upDown      = false;
    }
}