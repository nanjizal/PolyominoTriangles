package tetrisTriangles;
import js.Browser;
import js.html.svg.SVGElement;
import htmlHelper.svg.SvgRoot;
import js.html.CanvasRenderingContext2D;
import justDrawing.Surface;
import justTriangles.Triangle;
import justTriangles.Point;
import justTriangles.Draw;
import tetrisTriangles.game.TetrisTriangles;
    //using testjustDrawing.Draw;
import htmlHelper.tools.AnimateTimer;    
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
class TetrisTrianglesSvg{
    var surface: Surface;
    var tetrisTriangles: TetrisTriangles;
    var gameColors: Array<GameColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet, LightGrey, MidGrey, DarkGrey, NearlyBlack ];  
    public static function main(){ new TetrisTrianglesSvg(); } public function new(){
        var svgRoot = new SvgRoot();
        svgRoot.width = 1024;
        svgRoot.height = 768;
        var svg: SVGElement = svgRoot;
        //Browser.document.body.appendChild( cast svg );
        surface = new Surface( svg );
        Draw.drawTri = Triangle.drawTri;
        tetrisTriangles = new TetrisTriangles( 1 );
        AnimateTimer.create();
        AnimateTimer.onFrame = render;
    }
    inline function render( i: Int ):Void{
        tetrisTriangles.update();
        renderTriangles();
    }
    inline function renderTriangles(){
        var tri: Triangle;
        var triangles = Triangle.triangles;
        var s = 300;
        var o = 200;
        var g = surface;
        g.beginFill( 0x000000, 1. );
        g.lineStyle( 0., 0x000000, 0. );
        g.drawRect( 1, 1, 1024-2, 768-2 );
        g.endFill();
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            g.beginFill( gameColors[ tri.colorID ] );
            g.drawTri( [   o + tri.ax * s, o + tri.ay * s
                        ,  o + tri.bx * s, o + tri.by * s
                        ,  o + tri.cx * s, o + tri.cy * s ] );
            g.endFill();
        }
    }
}