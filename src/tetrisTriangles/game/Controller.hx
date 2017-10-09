package tetrisTriangles.game;
import tetrisTriangles.game.Shape;
import tetrisTriangles.game.Templates;
import tetrisTriangles.game.ShapeGenerator;
import tetrisTriangles.game.Arr2D;
import justTriangles.Triangle;
import justTriangles.Point;
class Controller {
    var inertArr:   Arr2D;
    var shapes      = new Array<Shape>();
    var shapeGenerator: ShapeGenerator;
    var bottom:     Shape;
    var background: Background;
    var id:         Int;
    var triangles:  Array<Triangle>;
    var col0        = 1;
    var col1        = 5;
    var dia:        Float;
    var gap:        Float;
    var offX:       Int;
    var offY:       Int;
    var wide:       Int;
    var hi:         Int;
    public var onTetrisShapeLanded: Void->Void;
    public var onGameEnd: Void -> Void;
    public function new(    id_:    Int,    triangles_: Array<Triangle>
                        ,   wide_:  Int,    hi_:        Int
                        ,   dia_:   Float,  gap_:       Float
                        ,   offX_:  Int,    offY_:      Int     ){
        id           = id_;
        inertArr     = new Arr2D( wide_ - 1, hi_ );
        wide         = wide_;
        hi           = hi_;
        triangles    = triangles_;
        dia          = dia_;
        gap          = gap_;
        offX         = offX_;
        offY         = offY_;
        shapeGenerator = new ShapeGenerator( createTetris );
    }
    public function createShape( p: Point, col0_: Int, col1_: Int, ?shapePreference: TetrisShape = tetris_random ){
        col0      = col0_;
        col1      = col1_;
        var shape = shapeGenerator.randomShape( p, col0_, col1_, shapePreference );
        shapes[ shapes.length ] = shape;
        return shape;
    }
    public inline function shapeLocations(): Array< { x: Int, y: Int } > {
        var l = shapes.length;
        var arr = new Array< { x: Int, y: Int} >();
        for( i in 0...l ) shapes[ i ].getCentreInt( arr );
        return arr;
    }
    public inline 
    function hitBottom(){
        // shapesOnBg();  // allow to see where block is in binary
        var l = shapes.length;
        var shape: Shape;
        var hit = false;
        for( i in 0...l ){
            shape = shapes[ i ];
            var clash = inertArr.clash( shape.getLocation(), 0, 0 );//-offX - 1, 4 );
            if( clash ){
                shapeKill( shape, i );
                hit = true;
            }
        }
        var end = !inertArr.rowEmpty(0);
        if( end ) onGameEnd();
        if( onTetrisShapeLanded != null && hit && !end ) onTetrisShapeLanded();
        return hit;
    }
    public inline
    function shapeKill( shape: Shape, count: Int ){
        shape.snap();
        var newBlocks = shape.clearBlocks();
        shape.changeColor( 8, 8 );
        var l = newBlocks.length;
        for( i in 0...l ) bottom.pushBlock( newBlocks[ i ] );
        addHitPointsInt( shape.lastLocation );
    }
    public inline 
    function shapesOnBg(){
        var shapeLocations = shapeLocations();
        background.drawTetris( shapeLocations, 0, 0 );
    }   
    public inline 
    function rotate( theta ){
        var l = shapes.length;
        for( i in 0...l ) shapes[ i ].rotate( theta );
    }
    public inline function moveX( x: Float, leftStop: Float, rightStop: Float ){
        var l = shapes.length;
        var shape: Shape;
        for( i in 0...l ) {
            shape = shapes[ i ];
            moveShapeX( shape, x, leftStop, rightStop );
        }
    }
    public inline function moveShapeX( shape: Shape, x: Float, leftStop: Float, rightStop: Float ){
        if( shape.blocks != null && shape.blocks.length != 0 ){
            var sides0 = Shape.getShapeSides( shape.blocks );  // does not fully account for rotation and bounds.
            var sides1 = Shape.getShapeSides( shape.virtualBlocks ); // but rotation his handled by shape :(
            var sides = { x: Math.min( sides0.x, sides1.x ), right: Math.max( sides0.right, sides1.right ) }
            if( sides != null ) { 
                if( x < 0 ){
                    if( sides.x + x > leftStop ){
                            shape.moveX( x );   
                    } else { // stopped by edges
                            shape.moveX( leftStop - sides.x );
                    }
                } else if( x > 0 ){
                    if( sides.right + x < rightStop ){
                        shape.moveX( x );
                    } else { // stopped by edges
                        shape.moveX( rightStop - sides.right );
                    }
                }
            }
        }
    }
    public inline function moveDelta( x: Float, y: Float ){
        var l = shapes.length;
        for( i in 0...l ) shapes[ i ].moveDelta( x, y );
    }
    public inline function createTetris( p: Point, ?snapped: Snapped ){
        return new Shape( id, triangles, p, col0, col1, dia, gap, snapped, offX, offY );
    }
    public function createBg( p:        Point
                            , wide:     Int,    hi:     Int
                            , col0_:    Int,    col1_:  Int
                            , col2_:    Int,    col3_:  Int ){
        var bg = createTetris( p );
        background = new Background( bg, wide, hi + 1, col0_, col1_, col0_, col1_ );//col2_, col3_ ); // allows cols to be differently colored for dev.
    }
    public inline
    function addHitPointsInt( arrP: Array<{ x: Int, y: Int }> ) { // adds points to the hitTest
        offSetAddPoints( inertArr, arrP );
        //trace( inertArr.prettyString() );
    }
    public inline
    function offSetAddPoints( arr2d: Arr2D, arrP: Array<{ x: Int, y: Int }> ){
        arr2d.addPoints( arrP, 0, 0 );
    }
    public function createBottom( p: Point, wide: Int , col0_: Int, col1_: Int ){
        var templates = new Templates( createTetris );
        col0   = col0_;
        col1   = col1_;
        bottom = templates.bottom( p, wide );
        var arr = new Array< { x: Int, y: Int} >();
        var bottomPositions = bottom.getCentreInt( arr );
        addHitPointsInt( bottomPositions );
    }


    //public inline function hitBottomOld(){
        //_points = bottom.getPoints( new Array<Point>() );
        //_points = bottom.getCentres();
        /*
        _pointInt = bottom.getCentreInt();
        var points = _pointInt;
        var pl = _pointInt.length;
        var tl = shapes.length;
        var count = -1;
        for( i in 0...tl ){
            for( p in 0...pl ){
                //if( tetrisShapes[ i ].hitTest( points[ p ] ) ){
                if( shapes[ i ].hitInt( points[ p ] ) ) {
                    count = i;
                    break;
                    break;
                }
            }
        }
        if( count != -1 ) {
            shapes[ count ].snap();
            var newBlocks = shapes[ count ].clearBlocks();
            var l = newBlocks.length;
            for( i in 0...l ) bottom.pushBlock( newBlocks[ i ] );
        }
        */
        //background.getPosition();
   // }
}