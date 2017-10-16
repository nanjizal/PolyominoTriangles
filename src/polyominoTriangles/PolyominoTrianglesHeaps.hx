package polyominoTriangles;
import justTriangles.Triangle;
import polyominoTriangles.game.Polyomino;
import h2d.Graphics;
import hxd.Key in K;
@:enum  // really not totally ideal needs more thought these are the triangle colors used as simple Ints see gameColors array.
    abstract GameColors( Int ) from Int to Int {
        var Violet      = 0xFF9400D3;
        var Indigo      = 0xFF4b0082;
        var Blue        = 0xFF0000FF;
        var Green       = 0xFF00ff00;
        var Yellow      = 0xFFFFFF00;
        var Orange      = 0xFFFF7F00;
        var Red         = 0xFFFF0000;
        var Black       = 0xFF000000;
        var LightGrey   = 0xFF444444;
        var MidGrey     = 0xFF333333;
        var DarkGrey    = 0xFF0c0c0c;
        var NearlyBlack = 0xFF111111;
        var White       = 0xFFFFFFFF;
        var BlueAlpha   = 0x660000FF;
        var GreenAlpha  = 0x3300FF00;
        var RedAlpha    = 0x66FF0000;
    }
class PolyominoTrianglesHeaps extends hxd.App {
        var gameColors:         Array<GameColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet
                                                , LightGrey, MidGrey, DarkGrey, NearlyBlack, White
                                                , BlueAlpha, GreenAlpha, RedAlpha ]; 
        var bmp : h2d.Bitmap;
        var polyomino: Polyomino;
        var g: h2d.Graphics; 
        override function init() {
            g = new h2d.Graphics(s2d);
            polyomino = new Polyomino();
        }
        inline function renderTriangles(){
            var tri: Triangle;
            var triangles = Triangle.triangles;
            var s = 600;
            var ox = 500;
            var oy = 100;
            g.clear();
            for( i in 0...triangles.length ){
                tri = triangles[ i ];
                g.beginFill( gameColors[ tri.colorID ] );
                g.lineTo( ox + tri.ax * s, oy + tri.ay * s );
                g.lineTo( ox + tri.bx * s, oy + tri.by * s );
                g.lineTo( ox + tri.cx * s, oy + tri.cy * s );
                g.endFill();
            }
        }
        override function update(dt:Float) {
            if( K.isDown( K.UP ) ){
                polyomino.rotate( 1 );
            }
            if( K.isDown( K.DOWN ) ){
                polyomino.move(  0, 1 );
            }
            if( K.isDown( K.LEFT ) ) {
                polyomino.move( -1, 0 );
            } else if( K.isDown( K.RIGHT ) ) {
                polyomino.move(  1, 0 );
            }
            polyomino.update();
            renderTriangles();
        }
        static function main() {
            new PolyominoTrianglesHeaps();
        }
    }