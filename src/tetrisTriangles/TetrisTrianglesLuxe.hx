package tetrisTriangles;
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

import tetrisTriangles.game.TetrisTriangles;

//import khaMath.Vector2;
//import tetrisTriangles.target.BasicColors;
@:enum
    abstract GameColors( Int ) from Int to Int {
        var Violet = 0x9400D3;
        var Indigo = 0x4b0082;
        var Blue   = 0x0000FF;
        var Green  = 0x00ff00;
        var Yellow = 0xFFFF00;
        var Orange = 0xFF7F00;
        var Red    = 0xFF0000;
        var Black  = 0x000000;
        var White  = 0xFFFFFF;
        var LightGrey = 0x444444;
        var MidGrey = 0x333333;
        var DarkGrey = 0x0c0c0c;
        var NearlyBlack = 0x111111;
}
class TetrisTrianglesLuxe extends luxe.Game {
    var tetrisTriangles: TetrisTriangles;
    var gameColors: Array<GameColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet, LightGrey, MidGrey, DarkGrey, NearlyBlack ];
    var shape: Geometry;
    
    override function ready() {
        tetrisTriangles = new TetrisTriangles();
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
        var s = 300;
        var o = 200;
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            color =  new Color().rgb( cast gameColors[ tri.colorID ] );
            shape.add( new Vertex( new Vector( o + tri.ax * s, o + tri.ay * s ), color ) );
            shape.add( new Vertex( new Vector( o + tri.bx * s, o + tri.by * s ), color ) );
            shape.add( new Vertex( new Vector( o + tri.cx * s, o + tri.cy * s ), color ) );
        }
    }
    override function onmousemove( event:MouseEvent ) {
        // mousemove update
    }
    override function onkeyup( e:KeyEvent ) {
        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }
    }
    override function update( delta:Float ) {
        tetrisTriangles.update();
        renderToTriangles();
    }
    override function config( config:luxe.GameConfig ) {
        config.window.width = 1024;
        config.window.height = 768;
        config.render.antialiasing = 4;
        return config;
    }
}