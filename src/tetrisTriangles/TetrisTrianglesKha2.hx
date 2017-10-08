package tetrisTriangles;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Color;
import kha.Assets;
import kha.Font;
import kha.graphics2.Graphics;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.KeyCode;
import justTriangles.Triangle;
import justTriangles.Draw;
import tetrisTriangles.game.Tetris;
@:enum
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
class TetrisTrianglesKha2 {
    var gameColors:         Array<GameColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet
                                                , LightGrey, MidGrey, DarkGrey, NearlyBlack, White
                                                , BlueAlpha, GreenAlpha, RedAlpha ]; 
    var tetris:             Tetris;
    var droidSans:          Font;
    var leftDown:           Bool = false;
    var rightDown:          Bool = false;
    var downDown:           Bool = false;
    var upDown:             Bool = false;
    public function new() {
        Assets.loadEverything(loadAll);
    } 
    public function loadAll() {
        draw();
        droidSans = Assets.fonts.DroidSans; 
        System.notifyOnRender( render );
        Scheduler.addTimeTask( update, 0, 1 / 60 );
        Keyboard.get().notify( keyDown, keyUp );
        var mouse = Mouse.get();
        //Mouse.get().notify( onMouseDown, onMouseUp, onMouseMove, null );
    }
    public function draw(){
        Draw.drawTri = Triangle.drawTri;
        tetris = new Tetris();
    }
    public function keyDown( keyCode:Int ): Void {
        switch(keyCode){
            case KeyCode.Left:  
                leftDown    = true;
            case KeyCode.Right: 
                rightDown   = true;
            case KeyCode.Up:    
                upDown      = true;
            case KeyCode.Down:  
                downDown    = true;
            default: 
                
        }
    }
    public function keyUp( keyCode: Int  ): Void { 
        switch(keyCode){
            case KeyCode.Left:  
                leftDown    = false;
            case KeyCode.Right: 
                rightDown   = false;
            case KeyCode.Up:    
                upDown      = false;
            case KeyCode.Down:  
                downDown    = false;
            default: 
                
        }
    }
    // useful for debuging or... spinning 3D? :)
    //function mouseMove( x: Int, y: Int, movementX: Int, movementY: Int ): Void {
        //xPos = x - (ball.width / 2);
       // yPos = y - (ball.height / 2);
    //}
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
    function render( framebuffer: Framebuffer ): Void {
        tetris.update();
        var g = framebuffer.g2;
        g.begin( 0xFF181818 );
        renderTriangles( g );
        g.end();
    }
    inline function renderTriangles( g: kha.graphics2.Graphics ){
        var tri: Triangle;
        var triangles = Triangle.triangles;
        var s = 300;
        var ox = 35;//200;
        var oy = 20;
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            g.color = cast( gameColors[ tri.colorID ], kha.Color );
            g.fillTriangle( ox + tri.ax * s, oy + tri.ay * s
                        ,   ox + tri.bx * s, oy + tri.by * s
                        ,   ox + tri.cx * s, oy + tri.cy * s );
        }
    }
}
