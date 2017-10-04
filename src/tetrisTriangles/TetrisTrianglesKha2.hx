package tetrisTriangles;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Color;
import kha.graphics2.Graphics;
import justTriangles.Triangle;
import justTriangles.Point;
import justTriangles.Draw;
import tetrisTriangles.game.TetrisTriangles;
import tetrisTriangles.game.Matrix2D;
import tetrisTriangles.game.RookAngle;

/*
import justTriangles.PathContext;
import justTriangles.ShapePoints;
import justTriangles.QuickPaths;
import justTriangles.SvgPath;
import justTriangles.PathContextTrace;
using justTriangles.QuickPaths;
*/
@:enum
    abstract GameColors( Int ) from Int to Int {
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
class TetrisTrianglesKha2 {
    var gameColors: Array<GameColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet, LightGrey, MidGrey, DarkGrey, NearlyBlack ]; 
    var tetrisTriangles: TetrisTriangles;
    public function new() {
        draw();
        var m = new Matrix2D<Int>();
        m.add( 1, 2, 10 );
        trace( m.checkerString() );
        m.clear();
        trace( m.checkerString() );
        trace( m );
        System.notifyOnRender(render);
        Scheduler.addTimeTask(update, 0, 1 / 60);
    }
    public function draw(){
        Draw.drawTri = Triangle.drawTri;
        tetrisTriangles = new TetrisTriangles();
    }
    function update(): Void {}
    function render(framebuffer: Framebuffer): Void {
        tetrisTriangles.update();
        var g = framebuffer.g2;
        g.begin();
        renderTriangles( g );
        g.end();
    }
    inline function renderTriangles( g: kha.graphics2.Graphics ){
        var tri: Triangle;
        var khaColor: Color;
        var triangles = Triangle.triangles;
        var s = 300;
        var o = 200;
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            g.color = cast( gameColors[ tri.colorID ], kha.Color );
            g.fillTriangle( o + tri.ax * s, o + tri.ay * s
                        ,   o + tri.bx * s, o + tri.by * s
                        ,   o + tri.cx * s, o + tri.cy * s );
        }
    }
}
