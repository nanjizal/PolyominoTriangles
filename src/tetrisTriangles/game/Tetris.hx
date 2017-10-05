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
    var count              = 0.;
    var toggle             = true;
    var wide               = 21;//30;
    var hi                 = 15;//20;
    var noBlocks           = 30;//1
    var fallSpeed          = 0.01;
    var rotationSpeed      = 100;
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
            controller.randomShape( { x: dx + randX, y: dy - i * sy }, m , m + 1 );
        }
        controller.createBottom( { x: dx, y: dy + dia * hi }, wide, 8, 9 );
    }
    public inline 
    function update(){
        controller.hitBottom();
        if( count % rotationSpeed == 0 ) toggle = !toggle; 
        count += 1.;
        if( toggle ) {
            count += 1.;
            controller.rotate( Math.PI/ rotationSpeed );
        }
        controller.moveDelta( 0.0, fallSpeed );
        controller.hitBottom();
    }
}