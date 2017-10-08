package tetrisTriangles.game;
import justTriangles.Triangle;
import tetrisTriangles.game.Controller;
import tetrisTriangles.game.Layout;
import tetrisTriangles.game.Rotation;
import tetrisTriangles.game.Movement;
import tetrisTriangles.test.UnitTest;
import tetrisTriangles.test.Arr2DTest;
import tetrisTriangles.game.Arr2D;
class Tetris {
    var controller:         Controller;
    var dia                = 0.15/1.6;// /2
    var edge               = 0.01; // disabled in code as gets in way of hitTest for momment, this is the spacing between squares.
    var wide               = 32;//32; // dimensions of the grid 21
    var hi                 = 22;//23; // 15
    var offX               = 0;//-4; // visual offsets
    var offY               = 0;//-4;
    var layout:           Layout;
    var rotation:          Rotation;
    var movement:          Movement;
    public function new( scale: Float = 1 ){ // scale is used to help with rendering differences between toolkits.
        // Arr2DTest.UnitTest();
        scaleDimensions( scale );
        createTetris();
        interaction();
        startGame();
        move( 0, 1 );
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
        controller = new Controller( 0, Triangle.triangles, wide, hi, dia, edge, offX, offY - 4 );
    }
    function startGame(){
        var originP = { x: dia*offX, y: dia*offY };
        layout = new Layout( controller, originP, wide, hi, dia );
        controller.onTetrisShapeLanded = layout.createTile;
        controller.onGameEnd = gameEnd;
    }
    var end: Bool = false;
    function gameEnd(){
        end = true;
    }
    function interaction(){
        rotation = new Rotation( controller );
        movement = new Movement( controller, dia );
        setLeftRightStops();
    }
    public inline 
    function update(){
        if( end ) return;
        if( !controller.hitBottom() ){ 
            rotation.update();
            movement.update();
            controller.hitBottom();
        }
    }
    public inline
    function rotate( i: Int ){
        rotation.rotate( i ); 
    }
    public inline
    function move( x: Int, y: Int ){
        movement.move( x, y );
    }
}