package tetrisTriangles.game;
import justTriangles.Triangle;
import justTriangles.Point;
import tetrisTriangles.game.Square;
import tetrisTriangles.game.RookAngle;
enum Snapped {
    Always;
    Zero;
    Ninety;
    Fix;
}
class Shape {
    var start:              Point;
    var snapped:            Snapped;
    var centre:             Point;
    public var blocks:             Array<Square>;
    public var virtualBlocks:      Array<Square>;
    var id:                 Int;
    var triangles:          Array<Triangle>;
    public var col0:        Int;
    public var col1:        Int;
    var dia:                Float;
    var gap:                Float;
    var angle:              Float = 0.;
    var rook:               RookAngle = 0.;
    var lastRook:           RookAngle = 0.;
    var offX:               Int;
    var offY:               Int;
    public function new(    id_:        Int,        triangles_: Array<Triangle>
                        ,   centre_:    Point
                        ,   col0_:      Int,        col1_:  Int
                        ,   dia_:       Float,      gap_:   Float
                        ,   ?snapped_: Snapped
                        ,   ?offX_:     Int = 0,    ?offY_: Int = 0 )
    {
        if( snapped_ == Zero || snapped_ == Fix ) centre_.x -= dia_/2;// keep shapes with pivot between squares snapped.
        centre      = centre_;
        snapped     = snapped_;
        offX        = offX_;
        offY        = offY_;
        start       = { x: centre_.x, y: centre_.y };
        id          = id_;
        triangles   = triangles_;
        col0        = col0_;
        col1        = col1_;
        dia         = dia_;
        gap         = gap_;
        blocks      = new Array<Square>();
        virtualBlocks = new Array<Square>();
    }
    public function addBlock( x_: Float, y_: Float ){
        var x0 = x_ * dia + centre.x;
        var y0 = y_ * dia + centre.y;
        var temp = triangles; // TODO: make virtualBlocks non visual just for hitTest pass empty array.
        virtualBlocks[ blocks.length ]  = new Square( id, temp,      x0, y0,    13,    13, dia, gap );
        blocks[ blocks.length ]         = new Square( id, triangles, x0, y0, col0, col1, dia, gap );
    }
    public function pushBlock( square: Square ){
        blocks[ blocks.length ] = square;
    }
    public function clearBlocks(){
        var newBlocks = [];
        for( i in 0...blocks.length ) newBlocks[ i ] = blocks[ i ];
        blocks          = new Array<Square>();
        virtualBlocks   = new Array<Square>(); // need to remove properly..
        return newBlocks;
    }
    public function rotate( theta: Float ){
        angle += theta;
        rook = angle;
        var l = blocks.length;
        var cos = Math.cos( theta );
        var sin = Math.sin( theta );
        rookSnapping( cos, sin );
        rotateVirtual( rook );
        for( i in 0...l ){
            blocks[ i ].moveDelta( centre.x, centre.y );
            blocks[ i ].rotateAround( centre, cos, sin );
            blocks[ i ].moveDelta( -centre.x, -centre.y );
        }
        lastRook = rook;
    }
    inline 
    function rotateVirtual( rook: Float ){
        var cos = Math.cos( Math.PI/2 );
        var sin = Math.sin( Math.PI/2 );
        if( rook != lastRook ){
            var l = virtualBlocks.length;
            for( i in 0...l ){
                virtualBlocks[ i ].moveDelta( centre.x, centre.y );
                virtualBlocks[ i ].rotateAround( centre, cos, sin );
                virtualBlocks[ i ].moveDelta( -centre.x, -centre.y );
            }
        }
    }
    inline 
    function rookSnapping( cos: Float, sin: Float ){
        var offset: Float;
        if( snapped != null ){
            switch( snapped ){
                case Zero | Ninety:
                    offset = -( dia/2 ) * cos;
                    offsetX( offset );
                case Fix:
                    offset = ( dia/2 ) * cos;
                    offsetX( offset );
                case Always:
                    offsetX( 0 );
                default:
            }
        }
    }
    function offsetX( ox: Float ){ // cheat to allow column snapping on rotation.
        centre.x = start.x + ox;
    }
    public inline 
    function snap(){
        var beta: Float;
        if( angle < 0 ){
            beta = -angle + 180;
        }
        beta = angle % ( 2 * Math.PI );
        var rookFloat: Float = rook;
        var offAngle:  Float = rookFloat - beta;
        rotate( offAngle );
    }
    public function getPoints( points: Array<Point> ){
        var l = blocks.length;
        for( i in 0...l ){
            blocks[ i ].getPoints( points );
        }
        return points;
    }
    public function moveX( dx: Float ){
        start.x += dx;
        var l = blocks.length;
        for( i in 0...l ) blocks[ i ].moveDelta( dx, 0. );
        for( i in 0...l ) virtualBlocks[ i ].moveDelta( dx, 0. );
    }
    public function moveDelta( dx: Float, dy: Float ){// TODO: for sideways movement remember to create a new getter that updates start.x or something
        if( blocks.length == 0 ) return;
        if( blocks == null ) return;
        centre.x += dx;
        centre.y += dy;
        var l = blocks.length;
        for( i in 0...l ) blocks[ i ].moveDelta( dx, dy );
        for( i in 0...l ) virtualBlocks[ i ].moveDelta( dx, dy );
    }
    public function hitInt( p: { x: Int, y: Int } ): Bool {
        var out = false;
        var l = virtualBlocks.length;
        var p2: { x: Int, y: Int };
        for( i in 0...l ){
            p2 = virtualBlocks[ i ].getCentreInt();
            if( p2.x == p.x && p2.y == p.y ){
                out = true;
                break;
            }
        }
        return out;
    }
    var centresInt: Array< { x: Int, y: Int} >;
    public function getCentreInt():Array< { x: Int, y: Int } >{
        var l = blocks.length;
        centresInt = new Array< { x: Int, y: Int } >();
        for( i in 0...l ){
            centresInt[ i ] = blocks[ i ].getCentreInt();
        }
        return centresInt;
    }
    public static inline
    function getShapeBounds( sqr: Array<Square> ){
        return if( sqr == null ) {
            null;
        } else if( sqr.length == 0 ){
            null;
        } else {
            var l = sqr.length;
            var square = sqr[ 0 ];
            var bx = square.x;
            var by = square.y;
            var br = square.right;
            var bb = square.bottom;
            for( i in 1...l ){
                square = sqr[ i ];
                bx = Math.min( bx, square.x );
                by = Math.min( by, square.y );
                br = Math.max( br, square.right );
                bb = Math.max( br, square.bottom );
            }
            { x: bx, y: by, right: br, bottom: bb };
        }
    }
    // quite costly to get whole shape bounds so perhaps only left ( x ) and right;
    public static inline
    function getShapeSides( sqr: Array<Square> ){
        return if( sqr == null ) {
            null;
        } else if( sqr.length == 0 ){
            null;
        } else {
            var l = sqr.length;
            var square = sqr[ 0 ];
            var bx = square.x;
            var br = square.right;
            for( i in 1...l ){
                square = sqr[ i ];
                bx = Math.min( bx, square.x );
                br = Math.max( br, square.right );
            }
            { x: bx, right: br };
        }
    }
    // OLD hitTest code not currently required?
    /*
    public inline 
    function discretePosition( p:{x:Float,y:Float}):{x:Int,y:Int}{
        return {  x: Math.round( p.x / dia ) - offX
                , y: Math.round( p.y / dia ) - offY 
                };
    }*/
    /*
    var centres: Array< { x: Float, y: Float} >;
    public function getCentres():Array< { x: Float, y: Float }>{
        var l = blocks.length;
        var square: Square;
        centres = new Array< { x: Float, y: Float } >();
        for( i in 0...l ) centres[ i ] = blocks[ i ].getQuickCentre();
        return centres;
    }
    */
    /*public function getPosition(){
        var l = blocks.length;
        var square: Square;
        for( i in 0...l ){
            square = blocks[ i ];
            var sqrCentre = square.getCentre();
            gridPositionUpdate( Math.round( sqrCentre.x/dia ) - offX, Math.round( sqrCentre.y/dia ) - offY );
        }
    }*/
    /*
    public function hitTest( p: Point ): Bool {
        var out = false;
        var l = blocks.length;
        for( i in 0...l ){
            if( blocks[ i ].hitTest( { x: p.x, y: p.y } ) ){
                out = true;
                break;
            }
        }
        return out;
    }*/
    /*
    public inline function close( v0: { x: Float, y: Float }, v1: { x: Float, y: Float } ): Bool {
  		var dx = v0.x - v1.x;
  		var dy = v0.y - v1.y;
  		return ( ( dx * dx + dy * dy ) < ( dia * dia ) );
	}*/
}