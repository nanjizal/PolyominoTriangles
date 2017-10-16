package polyominoTriangles.game;
import justTriangles.Triangle;
import polyominoTriangles.game.Controller;
import polyominoTriangles.game.Layout;
import polyominoTriangles.game.Rotation;
import polyominoTriangles.game.Movement;
import polyominoTriangles.test.UnitTest;
import polyominoTriangles.test.Arr2DTest;
import polyominoTriangles.game.Arr2D;
// this is the main game class it takes keyboard from the kha specific code.
// It set starts the controller and using layout helper adds shapes.
// it redirects keyboard control to movement x and y class and to rotation helper class
class Polyomino {
    var controller:         Controller;
    #if use_abc
    var dia                = 0.15/3;
    #else 
    var dia                = 0.15/2;//(0.15/1.6);// /2
    #end
    var edge               = 0.01; // disabled in code as gets in way of hitTest for momment, this is the spacing between squares.
    #if use_abc
    var wide               = 32*2;//     32;    //21; // dimensions of the grid
    var hi                 = 22*2;//15;
    #else
    var wide               = 8;//32;//     32;    //21; // dimensions of the grid
    var hi                 = 30;//22;//15;
    #end
    var offX               = 0; // visual offsets problematic now not need maybe remove..
    var offY               = 0;
    var layout:            Layout;
    var rotation:          Rotation;
    var movement:          Movement;
    var end:               Bool = false;
    public function new( scale: Float = 1 ){ // scale is used to help with rendering differences between toolkits.
        // Arr2DTest.UnitTest(); // unit test commented out
        scaleDimensions( scale );
        createPolyomino();  // create main controller class that is the core of creation and animation low level control.
        interaction();   // setup movement and rotation animation control
        startGame();     // layout visuals using controller and layout class.
    }
    function scaleDimensions( scale: Float ){
        dia = scale * dia;
        edge = scale * edge;
    }
    function setLeftRightStops(){
        movement.leftStop =  dia * offX;
        movement.rightStop = dia * offX + wide * dia;
    }
    function createPolyomino(){
        controller = new Controller( 0, Triangle.triangles, wide, hi, dia, edge, offX, offY - 4 );
    }
    function startGame(){
        var originP = { x: dia*offX, y: dia*offY };
        layout = new Layout( controller, originP, wide, hi, dia );
        controller.onPolyominoShapeLanded = newShape;
        controller.onGameEnd = gameEnd;
    }
    function newShape(){
        rotation.reset();
        movement.reset();
        layout.createTile();
    }
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