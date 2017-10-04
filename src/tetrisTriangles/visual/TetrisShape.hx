package tetrisTriangles.visual;
import justTriangles.Triangle;
import justTriangles.Point;
import tetrisTriangles.visual.Square;
import tetrisTriangles.game.RookAngle;

enum Snapped {
    Always;
    Zero;
    Ninety;
}

class TetrisShape{
    var start:      Point;
    var snapped:    Snapped;
    var centre:     Point;
    var blocks:     Array<Square>;
    var id:         Int;
    var triangles:  Array<Triangle>;
    public var col0_id:    Int;
    public var col1_id:    Int;
    var dia:        Float;
    var gap:        Float;
    var angle:      Float = 0.;
    var rook:       RookAngle = 0.;
    var lastRook:   RookAngle = 0.;
    public function new(    id_: Int, triangles_: Array<Triangle>
                        ,   centre_: Point
                        ,   col0_id_: Int, col1_id_: Int
                        ,   dia_: Float, gap_: Float, ?snapped_: Snapped ){
        if( snapped_ == Zero ) centre_.x -= dia_/2;// keep shapes with pivot between squares snapped.
        centre      = centre_;
        snapped     = snapped_;
        start       = { x: centre_.x, y: centre_.y };
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
        angle += theta;
        rook = angle;
        trace( rook.compassString() );
        var l = blocks.length;
        var cos = Math.cos( theta );
        var sin = Math.sin( theta );
        rookSnapping( cos );
        for( i in 0...l ){
            blocks[ i ].moveDelta( centre.x, centre.y );
            blocks[ i ].rotateAround( centre, cos, sin );
            blocks[ i ].moveDelta( -centre.x, -centre.y );
        }
        lastRook = rook;
    }
    inline function rookSnapping( cos: Float ){
        var offset: Float;
        if( snapped!=null){
            switch( snapped ){
                case Zero | Ninety:
                    offset = -(dia/2)*cos;
                    offsetX( offset );
                case Always:
                default:
            }
        }
    }
    public function snap(){
        // assumes positive only rotation for moment
        var angle = angle%(2*Math.PI);
        var rookFloat: Float = rook;
        var offAngle: Float = rookFloat - angle;
        rotate( offAngle );
    }
    public function getPoints( points: Array<Point> ){
        var l = blocks.length;
        for( i in 0...l ){
            blocks[i].getPoints( points );
        }
        return points;
    }
    public function moveDelta( dx: Float, dy: Float ){
        centre.x += dx;
        centre.y += dy;
        //trace( 'centre.x ' + centre.x/dia + '  centre.y ' + centre.y/dia );
        var l = blocks.length;
        for( i in 0...l ){
            blocks[ i ].moveDelta( dx, dy );
        }
        
    }
    public function offsetX( ox: Float ){
        centre.x = start.x + ox;
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