package tetrisTriangles;
import js.Browser;
import khaMath.Matrix4;
import justTrianglesWebGL.Drawing;
import justTriangles.Triangle;
import justTriangles.Draw;
import justTriangles.Point;
import tetrisTriangles.game.TetrisTriangles;
/*
import justTriangles.PathContext;
import justTriangles.ShapePoints;
import justTriangles.QuickPaths;
import htmlHelper.tools.CSSEnterFrame;
import justTriangles.SvgPath;
import justTriangles.PathContextTrace;
using justTriangles.QuickPaths;
*/
@:enum
abstract GameColors( Int ) to Int from Int {
    var Violet = 0x9400D3;
    var Indigo = 0x4b0082;
    var Blue   = 0x0000FF;
    var Green  = 0x00ff00;
    var Yellow = 0xFFFF00;
    var Orange = 0xFF7F00;
    var Red    = 0xFF0000;
    var Black  = 0x000000;
    var LightGrey = 0x444444;
    var MidGrey = 0x333333;
    var DarkGrey = 0x0c0c0c;
    var NearlyBlack = 0x111111;
}
class TetrisTrianglesWebGL {
    var tetrisTriangles: TetrisTriangles;
    var webgl: Drawing;
    var gameColors: Array<GameColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet, LightGrey, MidGrey, DarkGrey, NearlyBlack ];   
    public static function main(){
        new TetrisTrianglesWebGL();
    }
    public function new(){
        webgl = Drawing.create( 570*2 );
        tetrisTriangles = new TetrisTriangles( 0.5 );
        webgl.setTriangles( Triangle.triangles, cast gameColors );
        webgl.modelViewProjection = Matrix4.rotationZ( Math.PI / 4 );
        webgl.transformationFunc = updateTetris;
    }
    // TODO: Rethink?
    @:access( justTrianglesWebGL.Drawing )
    inline function updateTetris(): Matrix4 {
        tetrisTriangles.update();
        webgl.vertices = new Array<Float>();
        webgl.indices = new Array<Int>();
        webgl.colors = new Array<Float>();
        webgl.setTriangles( Triangle.triangles, cast gameColors );
        return Matrix4.identity();
        //return spin();
    }
    
    var theta: Float = 0;
    inline function spin(): Matrix4{
        return Matrix4.rotationZ( theta += Math.PI/100 ).multmat( Matrix4.rotationY( theta ) );
    }
}