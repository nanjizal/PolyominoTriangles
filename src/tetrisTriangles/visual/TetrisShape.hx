package tetrisTriangles.visual;
import justTriangles.Triangle;
import justTriangles.Point;
import tetrisTriangles.visual.Square;

class TetrisShape{
    var centre: Point;
    var blocks: Array<Square>;
    var id:         Int;
    var triangles:  Array<Triangle>;
    var col0_id:    Int;
    var col1_id:    Int;
    var dia:        Float;
    var gap:        Float;
    public function new(    id_: Int, triangles_: Array<Triangle>
                        ,   centre_: Point
                        ,   col0_id_: Int, col1_id_: Int
                        ,   dia_: Float, gap_: Float ){
        centre      = centre_;
        id          = id_;
        triangles   = triangles_;
        col0_id     = col0_id_;
        col1_id     = col1_id_;
        dia         = dia_;
        gap         = gap_;
        blocks      = new Array<Square>();
    }
    public function addBlock( x_: Float, y_: Float ){
        var x0 = x_*dia + centre.x;
        var y0 = y_*dia + centre.y;
        blocks[ blocks.length ] = new Square( id, triangles, x0, y0, col0_id, col1_id, dia, gap );
    }
    public function pushBlock( square: Square ){
        blocks[ blocks.length ] = square;
    }
    public function clearBlocks(){
        var newBlocks = [];
        for( i in 0...blocks.length ) newBlocks[ i ] = blocks[ i ];
        blocks = new Array<Square>();
        return newBlocks;
    }
    public function rotate( theta: Float ){
        var l = blocks.length;
        var cos = Math.cos( theta );
        var sin = Math.sin( theta );
        for( i in 0...l ){
            blocks[ i ].moveDelta( centre.x, centre.y );
            blocks[ i ].rotateAround( centre, cos, sin );
            blocks[ i ].moveDelta( -centre.x, -centre.y );
        }
    }
    public function getPoints( points: Array<Point> ){
        var l = blocks.length;
        for( i in 0...l ){
            blocks[i].getPoints( points );
        }
        return points;
    }
    //@:access( justTriangles.Triangle )
    public function moveDelta( dx: Float, dy: Float ){
        centre.x += dx;
        centre.y += dy;
        var l = blocks.length;
        for( i in 0...l ){
            blocks[ i ].moveDelta( dx, dy );
        }
    }
    public function hitTest( p: Point ): Bool {
        var out: Bool = false;
        var l = blocks.length;
        for( i in 0...l ){
            if( blocks[ i ].hitTest( p ) ){
                out = true;
            }
        }
        return out;
    }
}