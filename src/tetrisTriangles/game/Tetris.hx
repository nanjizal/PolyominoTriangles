package tetrisTriangles.game;
import justTriangles.Triangle;
import tetrisTriangles.game.Controller;
import tetrisTriangles.game.Layout;
import tetrisTriangles.game.Rotation;
import tetrisTriangles.game.Movement;
import tetrisTriangles.test.UnitTest;
import tetrisTriangles.test.Arr2DTest;
import tetrisTriangles.game.Arr2D;
// this is the main game class it takes keyboard from the kha specific code.
// It set starts the controller and using layout helper adds shapes.
// it redirects keyboard control to movement x and y class and to rotation helper class
class Tetris {
    var controller:         Controller;
    #if use_abc
    var dia                = 0.15/3;
    #else 
    var dia                = 0.15/1.6;// /2
    #end
    var edge               = 0.01; // disabled in code as gets in way of hitTest for momment, this is the spacing between squares.
    #if use_abc
    var wide               = 32*2;//     32;    //21; // dimensions of the grid
    var hi                 = 22*2;//15;
    #else
    var wide               = 32;//     32;    //21; // dimensions of the grid
    var hi                 = 22;//15;
    #end
    var offX               = 0; // visual offsets problematic now not need maybe remove..
    var offY               = 0;
    var layout:           Layout;
    var rotation:          Rotation;
    var movement:          Movement;
    public function new( scale: Float = 1 ){ // scale is used to help with rendering differences between toolkits.
        Arr2DTest.UnitTest(); // unit test commented out
        var filledArr2D = new Arr2D( 4, 4 );
        filledArr2D.fill();
        trace( filledArr2D.prettyString() );
        filledArr2D.addZero( 1, 2 );
        filledArr2D.addZero( 1, 1 );
        trace( filledArr2D.prettyString() );
		filledArr2D.removeRowsUnshift0( 1, 3 );
        trace( filledArr2D.prettyString());

        scaleDimensions( scale );
        createTetris();  // create main controller class that is the core of creation and animation low level control.
        interaction();  // setup movement and rotation animation control
        startGame();  // layout visuals using controller and layout class.
        move( 0, 1 ); // kind of hacky not sure if useful, it was perhaps to help with getting y position on square.
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
        controller.onTetrisShapeLanded = newShape;
        controller.onGameEnd = gameEnd;
    }
    function newShape(){
        rotation.reset();
        movement.reset();
        layout.createTile();
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
            //if(!controller.hitBottom()){
                movement.update();
            //}
            //controller.hitBottom();
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