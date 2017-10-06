package tetrisTriangles.game;
import tetrisTriangles.game.Shape;
import tetrisTriangles.game.Templates;
import tetrisTriangles.game.Controller;
import justTriangles.Triangle;
import justTriangles.Point;
@:enum
    abstract TetrisShape( String ) to String from String {
    var tetris_S = 'tetris_S';
    var tetris_L = 'tetris_L';
    var tetris_box = 'tetris_box';
    var tetris_t = 'tetris_t';
    var tetris_l = 'tetris_l';
    var tetris_random = 'tetris_random';
}
class Controller {
    var shapes      = new Array<Shape>();
    var bottom:     Shape;
    var background: Shape;
    var id:         Int;
    var triangles:  Array<Triangle>;
    var col0        = 1;
    var col1        = 5;
    var dia:        Float;
    var gap:        Float;
    var offX:       Int;
    var offY:       Int;
    var last        = -1;
    var random      = 0;
    //var _points: Array<Point>;
    var _pointInt: Array<{x:Int,y:Int}>;
    
    public function new(    id_:    Int,    triangles_: Array<Triangle>
                        ,   dia_:   Float,  gap_:       Float
                        ,   offX_:  Int,    offY_:      Int     ){
        id           = id_;
        triangles    = triangles_;
        dia          = dia_;
        gap          = gap_;
        offX         = offX_;
        offY         = offY_;
    }
    public function createShape( p: Point, col0_: Int, col1_: Int, ?shape: TetrisShape = tetris_random ){
        var templates = new Templates( createTetris );
        col0      = col0_;
        col1      = col1_;
        switch( shape ){ // normally works as random tetris shape
            case tetris_random:
                var random  = Std.int( 4*Math.random() );
                if( random == last ) {
                    createShape( p, col0_, col1_ );
                    return;
                }
                shapes[ shapes.length ] = switch( random ){
                        case 0:
                            templates.S( p );
                        case 1:
                            templates.L( p );
                        case 2:
                            templates.box( p );
                        case 3:
                            templates.t( p );
                        case 4: 
                            templates.l( p );
                        default:
                            templates.S( p );
                    }
            default: 
                shapes[ shapes.length ] = switch( shape ){ // used to allow testing of only one shape ( add TetrisShape in the method call );
                    case tetris_S:
                        templates.S( p );
                    case tetris_L:
                        templates.L( p );
                    case tetris_box:
                        templates.box( p );
                    case tetris_t:
                        templates.l( p );
                    default:
                        templates.box( p );
                }
        } 
        last = random;
    }
    public inline function hitBottom(){
        //_points = bottom.getPoints( new Array<Point>() );
        //_points = bottom.getCentres();
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
            for( i in 0...l ) bottom.pushBlock( newBlocks[i] );
        }
        //background.getPosition();
    }
    public inline function rotate( theta ){
        var l = shapes.length;
        for( i in 0...l ) shapes[i].rotate( theta );
    }
    public inline function moveX( x: Float ){
        var l = shapes.length;
        for( i in 0...l ) shapes[i].moveX( x );
    }
    public inline function moveDelta( x: Float, y: Float ){
        var l = shapes.length;
        for( i in 0...l ) shapes[i].moveDelta( x, y );
    }
    public inline function createTetris( p: Point, ?snapped: Snapped ){
        var ts = new Shape( id, triangles, p, col0, col1, dia, gap, snapped, offX, offY );
        return ts;
    }
    public function createBg( p:        Point
                            , wide:     Int,    hi:     Int
                            , col0_:    Int,    col1_:  Int
                            , col2_:    Int,    col3_:  Int ){
        col0   = col0_;
        col1   = col1_;
        var ts = createTetris( p );
        var toggle = false;
        for( w in 0...wide ){
            if( toggle ) { // color rows bottomly differently - should say horizontally the joys of replace! :)
                ts.col0     = col0_;
                ts.col1     = col1_;
            } else {
                ts.col0     = col2_;
                ts.col1     = col3_;
            }
            toggle = !toggle;
            for( h in 0...hi ) ts.addBlock( w, h );
        }
        background = ts;
    }
    public function createBottom( p: Point, wide: Int , col0_: Int, col1_: Int ){
        var templates = new Templates( createTetris );
        col0   = col0_;
        col1   = col1_;
        bottom = templates.bottom( p, wide );
    }
}