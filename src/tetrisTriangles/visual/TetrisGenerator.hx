package tetrisTriangles.visual;
import tetrisTriangles.visual.TetrisShape;
import justTriangles.Triangle;
import justTriangles.Point;
class TetrisGenerator {
    var tetrisShapes: Array<TetrisShape> = new Array();
    var horizontal: TetrisShape;
    var background: TetrisShape;
    var id:         Int;
    var triangles:  Array<Triangle>;
    var col0_id:    Int = 1;
    var col1_id:    Int = 5;
    var dia:        Float;
    var gap:        Float;
    public function new(    id_: Int, triangles_: Array<Triangle>
                        ,   dia_: Float, gap_: Float ){
        id           = id_;
        triangles    = triangles_;
        dia          = dia_;
        gap          = gap_;
    }
    // perhaps move to logic
    /* generates a Tetris shape at point p */
    var last: Int = -1;
    public function generateRandom( p: Point, col0_id_: Int, col1_id_: Int ){
        col0_id      = col0_id_;
        col1_id      = col1_id_;
        var random: Int = Math.round( 4*Math.random() );
        if( random == last ) {
            generateRandom( p, col0_id, col1_id );
            return;
        }
        tetrisShapes[ tetrisShapes.length ] = 
            switch( random ){
                case 0:
                    generate_S( p );
                case 1: 
                    generate_l( p );
                case 2:
                    generate_box( p );
                case 3:
                    generate_L( p );
                case 4: 
                    generate_t( p );
                default:
                    generate_l( p );
            }
        last = random;
    }
    var _points: Array<Point>;
    public inline function hitBottom(){
        _points = horizontal.getPoints( new Array<Point>() );
        var points = _points;
        var pl = points.length;
        var tl = tetrisShapes.length;
        var count = -1;
        for( i in 0...tl ){
            for( p in 0...pl ){
                if( tetrisShapes[ i ].hitTest( points[ p ] ) ){
                    count = i;
                }
            }
        }
        if( count != -1 ) {
            var newBlocks = tetrisShapes[ count ].clearBlocks();
            for( i in 0...newBlocks.length ){
                horizontal.pushBlock( newBlocks[i] );
            }
        }
    }
    public inline function rotate( theta ){
        for( i in 0...tetrisShapes.length ){
            tetrisShapes[i].rotate( theta );
        }
    }
    public inline function moveDelta( x: Float, y: Float ){
        for( i in 0...tetrisShapes.length ){
            tetrisShapes[i].moveDelta( x, y );
        }
    }
    public inline function createTetris( p: Point ){
        var ts = new TetrisShape( id, triangles, p, col0_id, col1_id, dia, gap );
        return ts;
    }
    // predefined tetris shapes relative to centre
    function generate_S( p: Point ): TetrisShape {
        var ts = createTetris( p );
        ts.addBlock( -0.5, -1 );
        ts.addBlock( 0.5, 0 );
        ts.addBlock( 0.5, -1 );
        ts.addBlock( 1.5, 0 );
        return ts;
    }
    function generate_l( p: Point ): TetrisShape {
        var ts = createTetris( p );
        ts.addBlock( -0.5, -2 );
        ts.addBlock( -0.5, -1 );
        ts.addBlock( -0.5, 0 );
        ts.addBlock( -0.5, 1 );
        return ts;
    }
    function generate_box( p: Point ): TetrisShape {
        var ts = createTetris( p );
        ts.addBlock( -1, -1 );
        ts.addBlock( 0, -1 );
        ts.addBlock( -1, 0 );
        ts.addBlock( 0, 0 );
        return ts;
    }
    function generate_L( p: Point ): TetrisShape {
        var ts = createTetris( p );
        ts.addBlock( -1, -1.5 );
        ts.addBlock( -1, -0.5 );
        ts.addBlock( -1, 0.5 );
        ts.addBlock( 0, 0.5 );
        return ts;
    }
    function generate_t( p: Point ): TetrisShape {
        var ts = createTetris( p );
        ts.addBlock( -1, -1.5 );
        ts.addBlock( -1, -0.5 );
        ts.addBlock( -1, 0.5 );
        ts.addBlock( 0, -0.5 );
        return ts;
    }
    public function generateBackground( p: Point, wide: Int , hi: Int, col0_id_: Int, col1_id_: Int ){
        col0_id      = col0_id_;
        col1_id      = col1_id_;
        var ts = createTetris( p );
        for( w in 0...wide ){
            for( h in 0...hi ){
                ts.addBlock( w, h );
            }
        }
        background = ts;
    }
    /** bottom row of tetris**/
    public function generateHoriz( p: Point, wide: Int , col0_id_: Int, col1_id_: Int ){
        col0_id      = col0_id_;
        col1_id      = col1_id_;
        var ts = createTetris( p );
        for( w in 0...wide ){
            ts.addBlock( w, 0 );
        }
        horizontal = ts;
    }

}