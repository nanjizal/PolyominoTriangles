package tetrisTriangles.game;
import justTriangles.Triangle;
import tetrisTriangles.game.Controller;
class Tetris {
    var dia                = 0.15;// /2
    var edge               = 0.01; // disabled in code as gets in way of hitTest for momment, this is the spacing between squares.
    var x                  = -4;
    var y                  = -4;
    var right              = 10;
    var above              = 7;
    var controller:         Controller;
    var count              = 0.; // for rotation smoothing
    var toggle             = false;
    var wide               = 21;//30;
    var hi                 = 15;//20;
    var noBlocks           = 30;//1
    var fallSpeed          = 0.01;
    var rotationSpeed      = 20;
    var jumpSpeed          = 7;
    var jumpX               = .0;   // for movement smoothing
    var jumpY               = .0;
    var toggleX             = false;
    var toggleY             = false;    
    var jx                  = 0.;
    var jy                  = 0.;
    public function new( scale: Float = 1 ){
        dia = scale * dia;
        edge = scale * edge;
        var offX = -4;
        var offY = -8;
        controller = new Controller( 0, Triangle.triangles, dia, edge, offX, offY );
        var dx = dia*x;
        var dy = dia*y;
        var sy = dia*above;
        controller.createBg( { x: dx, y: dy }, wide, hi, 10, 0, 9, 0 );
        var randX: Float;
        for( i in 0...noBlocks ){
            var m = i % 6 + 1; // restart colors
            var randX = dia + dia * Math.round( Math.random() * ( wide - 0.5 ));
            controller.createShape( { x: dx + randX, y: dy - i * sy }, m , m + 1 );// , TetrisShape.tetris_L );  <- can choose on shape.
        }
        controller.createBottom( { x: dx, y: dy + dia * hi }, wide, 8, 9 );
    }
    public inline 
    function update(){
        controller.hitBottom();
        updateRotation();
        updateMove();
        controller.hitBottom();
    }
    public function rotate( i: Int ){
        if( toggle ) return;
        toggle = true;
        count = 1.0;
    }
    inline 
    function updateRotation(){
        if( toggle ) {
            controller.rotate( Math.PI/ rotationSpeed );
        }
        if( count % ( rotationSpeed/2 ) == 0. ) {
            count = 0.;
            toggle = false;
        }
        count += 1.;
    }
    public function move( x: Int, y: Int ){
        if( toggleX ) return;
        if( toggleY ) return;
        if( x != 0 ) toggleX = true;
        if( y != 0 ) toggleY = true;
        jumpX = x * dia;
        jumpY = y * dia;
    }
    inline 
    function updateMove(){ // variable names could be improved
        var djx = 0.;
        var djy = 0.;
        if( toggleX ){ // smooth x movement 
            if( jumpX > 0 ){
                djx = jumpX / jumpSpeed;
                jx += djx;
                if( jx > jumpX + djx/2 ){ // reset
                    toggleX = false;
                    jx = 0.;
                    djx = 0.;
                }
            } else {
                djx = jumpX / jumpSpeed;
                jx += djx;
                if( jx < jumpX + djx/2 ){ // reset
                    toggleX = false;
                    jx = 0.;
                    djx = 0.;
                }
            }
        }
        if( toggleY ){ // only one of these actually used the down movement smoothing
            if( jumpY > 0 ){
                djy = jumpY / jumpSpeed;
                jy += djy;
                if( jy > jumpY + djy/2 ){ // reset
                    toggleY = false;
                    jy = 0.;
                    djy = 0.;
                }
            } else {
                djy = jumpY / 10;
                jy += djx;
                if( jy < jumpY + djy/2 ){ // reset
                    toggleY = false;
                    jy = 0.;
                    djy = 0.;
                }
            }
        }
        if( toggleX ) controller.moveX( djx );
        controller.moveDelta( 0.0, fallSpeed + djy );

        /* Non smooth mouse movement alternative to above complexity
            controller.moveX( jumpX ); 
            controller.moveDelta( 0.0, fallSpeed + jumpY );

            // jumpX = 0.;
            // jumpY = 0.;
        }
        */
    }
}