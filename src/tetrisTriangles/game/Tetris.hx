package tetrisTriangles.game;
import justTriangles.Triangle;
import tetrisTriangles.game.Controller;
import tetrisTriangles.game.Layout;
import tetrisTriangles.game.Rotation;
import tetrisTriangles.game.Movement;
class Tetris {
    var dia                = 0.15;// /2
    var edge               = 0.01; // disabled in code as gets in way of hitTest for momment, this is the spacing between squares.
    var above              = 7;
    var controller:         Controller;
    var wide               = 21; // dimensions of the grid
    var hi                 = 15;
    var offX               = -4; // visual offsets
    var offY               = -4;
    var rotation:          Rotation;
    var movement:          Movement;
    public function new( scale: Float = 1 ){ // scale is used to help with rendering differences between toolkits.
        scaleDimensions( scale );
        createTetris();
        layout();
        interaction();
    }    
    function scaleDimensions( scale: Float ){
        dia = scale * dia;
        edge = scale * edge;
    }
    function setLeftRightStops(){
        movement.leftStop =  dia * offX;
        movement.rightStop = dia * offX + wide * dia;
    }
    function createTetris(){
        controller = new Controller( 0, Triangle.triangles, dia, edge, offX, offY - 4 );
    }
    function layout(){
        var sy = dia*above;
        var originP = { x: dia*offX, y: dia*offY };
        new Layout( controller, originP, wide, hi, dia, sy );
    }
    function interaction(){
        rotation = new Rotation( controller );
        movement = new Movement( controller, dia );
        setLeftRightStops();
    }
    public inline 
    function update(){
        controller.hitBottom();
        rotation.update();
        movement.update();
        controller.hitBottom();
    }
    public function rotate( i: Int ){
        rotation.rotate( i ); 
    }
    public function move( x: Int, y: Int ){
        movement.move( x, y );
    }
}