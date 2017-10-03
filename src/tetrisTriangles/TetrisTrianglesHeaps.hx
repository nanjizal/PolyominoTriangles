package tetrisTriangles;
import justTriangles.Triangle;
import tetrisTriangles.game.TetrisTriangles;
import h2d.Graphics;
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
class TetrisTrianglesHeaps extends hxd.App {
        var gameColors: Array<GameColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet, LightGrey, MidGrey, DarkGrey, NearlyBlack ]; 
        var bmp : h2d.Bitmap;
        var tetrisTriangles: TetrisTriangles;
        var g: h2d.Graphics; 
        override function init() {
            g = new h2d.Graphics(s2d);
            tetrisTriangles = new TetrisTriangles();
        }
        inline function renderTriangles(){
            var tri: Triangle;
            var triangles = Triangle.triangles;
            var s = 300*2;
            var o = 200*2;
            g.clear();
            for( i in 0...triangles.length ){
                tri = triangles[ i ];
                g.beginFill( gameColors[ tri.colorID ] );
                g.lineTo( o + tri.ax * s, o + tri.ay * s );
                g.lineTo( o + tri.bx * s, o + tri.by * s );
                g.lineTo( o + tri.cx * s, o + tri.cy * s );
                g.endFill();
            }
        }
        override function update(dt:Float) {
            tetrisTriangles.update();
            renderTriangles();
        }
        static function main() {
            new TetrisTrianglesHeaps();
        }
    }