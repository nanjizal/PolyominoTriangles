package polyominoTriangles;
import luxe.Sprite;
import luxe.Color;
import phoenix.Batcher.PrimitiveType;
import phoenix.Vector;
import phoenix.geometry.Vertex;
import luxe.Input;
import luxe.Vector;
import lsystem.*;
import phoenix.geometry.Geometry;
import luxe.Color;
import justTriangles.Triangle;
import justTriangles.Point;

import polyominoTriangles.game.Polyomino;

//import khaMath.Vector2;
//import polyominoTriangles.target.BasicColors;
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
class PolyominoTrianglesLuxe extends luxe.Game {
    var polyomino: Polyomino;
    var gameColors:         Array<GameColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet
                                                , LightGrey, MidGrey, DarkGrey, NearlyBlack, White
                                                , BlueAlpha, GreenAlpha, RedAlpha ]; 
    var shape: Geometry;
    var leftDown:           Bool = false;
    var rightDown:          Bool = false;
    var downDown:           Bool = false;
    var upDown:             Bool = false;
    override function ready() {
        polyomino = new Polyomino();
    }
    inline function renderToTriangles(){
        if( shape != null ) shape.drop();
        shape = new Geometry({
                primitive_type:PrimitiveType.triangles,
                batcher: Luxe.renderer.batcher
        });
        //shape.lock = true; ??
        var tri: Triangle;
        var color: Color;
        var triangles = Triangle.triangles;
        var s = 320;
        var ox = 400;
        var oy = -10;
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            color =  new Color().rgb( cast gameColors[ tri.colorID ] );
            shape.add( new Vertex( new Vector( ox + tri.ax * s, oy + tri.ay * s ), color ) );
            shape.add( new Vertex( new Vector( ox + tri.bx * s, oy + tri.by * s ), color ) );
            shape.add( new Vertex( new Vector( ox + tri.cx * s, oy + tri.cy * s ), color ) );
        }
    }
    override function onmousemove( event:MouseEvent ) {
        // mousemove update
    }
    override function onkeyup( e:KeyEvent ) {
        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }
        var keyCode = e.keycode;
        switch(keyCode){
            case Key.left:  
                leftDown    = false;
            case Key.right: 
                rightDown   = false;
            case Key.up:    
                upDown      = false;
            case Key.down:  
                downDown    = false;
            default: 
                
        }
    }
    override function onkeydown( e:KeyEvent ) {
        var keyCode = e.keycode;
        switch(keyCode){
            case Key.left:  
                leftDown    = true;
            case Key.right: 
                rightDown   = true;
            case Key.up:    
                upDown      = true;
            case Key.down:  
                downDown    = true;
            default: 
                
        }
    }
    inline
    function updateMovement(): Void {
        if( upDown ){
            polyomino.rotate( 1 );
        } else if( downDown ){
            polyomino.move(  0, 1 );
        }
        if( leftDown ) {
            polyomino.move( -1, 0 );
        } else if( rightDown ) {
            polyomino.move(  1, 0 );
        }
        leftDown    = false;
        rightDown   = false;
        downDown    = false;
        upDown      = false;
    }
    
    override function update( delta:Float ) {
        updateMovement();
        polyomino.update();
        renderToTriangles();
    }
    override function config( config:luxe.GameConfig ) {
        config.window.width = 1024;
        config.window.height = 768;
        config.render.antialiasing = 4;
        return config;
    }
}