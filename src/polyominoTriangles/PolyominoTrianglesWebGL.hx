package polyominoTriangles;
import js.Browser;
import khaMath.Matrix4;
import htmlHelper.webgl.WebGLSetup;
import justTriangles.Triangle;
import justTriangles.Draw;
import justTriangles.Point;
import polyominoTriangles.game.Polyomino;
import js.html.Event;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
import htmlHelper.tools.AnimateTimer; 
import justTriangles.Draw;
using htmlHelper.webgl.WebGLSetup;
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
class PolyominoTrianglesWebGL extends WebGLSetup {
    var webgl: WebGLSetup;
    var polyomino: Polyomino;
    var gameColors:         Array<GameColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet
                                            , LightGrey, MidGrey, DarkGrey, NearlyBlack, White
                                            , BlueAlpha, GreenAlpha, RedAlpha ]; 
    var leftDown:           Bool = false;
    var rightDown:          Bool = false;
    var downDown:           Bool = false;
    var upDown:             Bool = false; 
    public static inline var vertex: String =
        'attribute vec3 pos;' +
        'attribute vec4 color;' +
        'varying vec4 vcol;' +
        'uniform mat4 modelViewProjection;' +
        'void main(void) {' +
            ' gl_Position = modelViewProjection * vec4(pos, 1.0);' +
            ' vcol = color;' +
        '}';
    public static inline var fragment: String =
        'precision mediump float;'+
        'varying vec4 vcol;' +
        'void main(void) {' +
            ' gl_FragColor = vcol;' +
        '}';
    public static function main(){ new PolyominoTrianglesWebGL(); }
    public function new(){
        super(570*2, 570*2 );
        polyomino = new Polyomino( 0.6 );
        Draw.drawTri = Triangle.drawTri;
        bgRed = 0x18/256;
        bgGreen = 0x18/256;
        bgBlue = 0x18/256;
        setupProgram( vertex, fragment );
        modelViewProjection = Matrix4.identity();
        AnimateTimer.create();
        AnimateTimer.onFrame = render_;
        Browser.document.onkeydown = keyDown;
        Browser.document.onkeyup = keyUp;
    }
    
    public function setTriangles( triangles: Array<Triangle>, triangleColors:Array<UInt> ) {
        var rgb: RGB;
        var colorAlpha = 1.0;
        var tri: Triangle;
        var count = 0;
        var i: Int = 0;
        var c: Int = 0;
        var j: Int = 0;
        var ox: Float = -0.5;
        var oy: Float = 0.5 + 0.55;
        for( tri in triangles ){
            vertices[ i++ ] = tri.ax + ox;
            vertices[ i++ ] = -tri.ay + oy ;
            vertices[ i++ ] = tri.depth;
            vertices[ i++ ] = tri.bx + ox;
            vertices[ i++ ] = -tri.by + oy;
            vertices[ i++ ] = tri.depth;
            vertices[ i++ ] = tri.cx + ox;
            vertices[ i++ ] = -tri.cy + oy;
            vertices[ i++ ] = tri.depth;
            rgb = WebGLSetup.toRGB( triangleColors[ tri.colorID ] );
            for( k in 0...3 ){
                colors[ c++ ] = rgb.r;
                colors[ c++ ] = rgb.g;
                colors[ c++ ] = rgb.b;
                colors[ c++ ] = colorAlpha;
                indices[ j++ ] = count++;
            }
        } 
        gl.uploadDataToBuffers( program, vertices, colors, indices );
    }
    inline function render_( i: Int ):Void{
        render();
    }
    override public function render(){
        polyomino.update();
        vertices = new Array<Float>();
        indices = new Array<Int>();
        colors = new Array<Float>();
        setTriangles( Triangle.triangles, cast gameColors );
        super.render();
    }
    var theta: Float = 0;
    inline function spin(): Matrix4{
        return Matrix4.rotationZ( theta += Math.PI/100 ).multmat( Matrix4.rotationY( theta ) );
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
}