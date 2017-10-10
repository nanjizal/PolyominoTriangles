package tetrisTriangles.game;
import justTriangles.Triangle;
import justTriangles.Point;
import tetrisTriangles.game.Square;
import tetrisTriangles.game.RookAngle;
// the Tetris shape, either the animated shapes or the hitarea/bottom and also for background drawing.
// uses square that uses triangle for render.
enum Snapped {
    Always;
    Zero;
    Ninety;
    Fix;
}
class Shape {
    var start:              Point;                  // used to help with x position movement.
    var snapped:            Snapped;                // related to how center needs to be offset when rotated.
    var centre:             Point;                  // used for hitTesting
    public var blocks:             Array<Square>;   // squares making up the shape. 
    public var virtualBlocks:      Array<Square>;   // 'rook' resolved squares see rook below.
    var id:                 Int;                    // technical detail related to triangle render not critical.
    var triangles:          Array<Triangle>;        // render triangles
    public var col0:        Int;            // colors
    public var col1:        Int;
    var dia:                Float;          // diameter of square
    var gap:                Float;          // not currently used?
    var angle:              Float = 0.;      // current rotation
    var rook:               RookAngle = 0.;  // resolving angle to 0,90,270,0 degrees.
    var lastRook:           RookAngle = 0.;  // previous rook
    var offX:               Int;             // offsets now set to 0 and not really needed?
    var offY:               Int;
    public var locked:      Bool = false;    // locked if blocks added to bottom, ie no longer animating.
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
    public inline
    function changeColor( col0_: Int, col1_: Int ){
        for( b in blocks ){
            col0 = col0_;
            col1 = col1_;
            b.changeColor( col0_, col1_ );
        } 
    }
    public function addBlock( x_: Float, y_: Float, ?addVirtual: Bool = true, ?show: Bool = true ): Square {
        var x0 = x_ * dia + centre.x;
        var y0 = y_ * dia + centre.y;
        #if ( showVirtualBlocksAbove || showVirtualBlocksBelow ) 
            var temp = triangles;
        #else 
            var temp = [];
        #end
        //triangles; // TODO: make virtualBlocks non visual just for hitTest pass empty array.
        var tri = triangles;
        
        if( !show ) tri = [];
        #if showVirtualBoxAbove 
            // 
        #else 
            if( addVirtual ) virtualBlocks[ blocks.length ]  = new Square( id, temp, x0, y0, dia, gap, 13, 13 );
        #end
        var sq = new Square( id, tri, x0, y0, dia, gap, col0, col1 );
        #if showVirtualBlocksAbove
            if( addVirtual ) virtualBlocks[ blocks.length ]  = new Square( id, temp, x0, y0, dia, gap, 13, 13 );
        #end
        blocks[ blocks.length ] = sq; 
        
        return sq;
    }
    public function pushBlock( square: Square ){
        blocks[ blocks.length ] = square;
    }
    public function clearBlocks(){
        var newBlocks = [];
        for( i in 0...blocks.length ) newBlocks[ i ] = blocks[ i ];
        blocks          = new Array<Square>();
        virtualBlocks   = new Array<Square>(); // need to remove properly..
        locked = true;
        return newBlocks;
    }
    public function removeRow( r: Int ){
        var sq: Square;
        var posInt: {x: Int, y: Int };
        var removed = new Array<Square>();
        var lr = 0;
        for( i in 0...blocks.length ) {
            sq = blocks[ i ];
            if( sq != null ){
                if( sq.hasTriangles() ){
                    posInt = sq.getCentreInt();
                    trace( 'checking ' + posInt.y + '  ' + r );
                    if( posInt.y == r ) {
                        sq.removeTriangles();
                        removed[lr++] = sq;
                    }
                }
            }
        }
        for( sq in removed ){
            blocks.remove( sq );
            sq = null;
        }
    }
    public function moveRowsDown( end: Int, amount: Int ){
        var sq: Square;
        var posInt: {x: Int, y: Int };
        for( i in 0...blocks.length ) {
            sq = blocks[ i ];
            posInt = sq.getCentreInt();
            if( posInt.y < end ) sq.moveDelta( 0, amount*dia );
        }
        // TODO: update the Arr2D
    }
    public function rotate( theta: Float ){
        angle += theta;
        rook = angle;
        var l = blocks.length;
        var cos = Math.cos( theta );
        var sin = Math.sin( theta );
        rookSnapping( cos, sin );
        rotateVirtual( rook );
        // blocks.map( v -> v.rotateSquare( centre, cos, sin ) ); // future ...
        for( i in 0...l ) blocks[ i ].rotateAround( centre, cos, sin );
        lastRook = rook;
    }
    inline 
    function rotateVirtual( rook: Float ){
        var cos = Math.cos( Math.PI/2 );
        var sin = Math.sin( Math.PI/2 );
        if( rook != lastRook ){
            // virtualBlocks.map( v -> v.rotateSquare( centre, cos, sin ) ); // future ...
            var l = virtualBlocks.length;
            for( i in 0...l ) virtualBlocks[ i ].rotateAround( centre, cos, sin );
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
    function snap2(){
        var beta: Float;
        if( angle < 0 ){
            beta = -angle + 180;
        }
        beta = angle % ( 2 * Math.PI );
        var rookFloat: Float = rook;
        var offAngle:  Float = rookFloat - beta;
        rotate( offAngle );

        var newLoc: { x: Int, y: Int };
        for( i in 0...lastLocation.length ){
            newLoc = newLocation[i];
            blocks[i].x = newLoc.x*dia;
            blocks[i].y = (newLoc.y)*dia ;
            virtualBlocks[i].x = newLoc.x*dia;
            virtualBlocks[i].y = (newLoc.y)*dia ;
        }
    }
    /*
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

        var newLoc: { x: Int, y: Int };
        var lastLoc: { x: Int, y: Int };
        for( i in 0...lastLocation.length ){
            newLoc = newLocation[i];
            lastLoc = lastLocation[i];
            blocks[i].x = lastLoc.x*dia;
            blocks[i].y = lastLoc.y*dia;
            virtualBlocks[i].x = lastLoc.x*dia;
            virtualBlocks[i].y = lastLoc.y*dia ;
        }
    }
    */
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
            if( p2.x == p.x && p2.y == p.y  ){
                out = true;
                break;
            }
        }
        return out;
    }
    public var lastLocation: Array< { x: Int, y: Int} > = [];
    public var newLocation: Array< { x: Int, y: Int} > = [];
    public function getLocation(){
        lastLocation = newLocation;
        var arr = new Array< { x: Int, y: Int} >();
        newLocation = arr;
        if( locked ) return arr;
        return getVirtualCentreInt( newLocation );
    }
    public function getLocationNew(){
        lastLocation = newLocation;
        var arr = new Array< { x: Int, y: Int} >();
        newLocation = arr;
        if( locked ) return arr;
        return getCentreInt( newLocation );
    }
    public function getCentreInt(  centresInt: Array< { x: Int, y: Int} > ):Array< { x: Int, y: Int } >{
        var l = blocks.length;
        var lc = centresInt.length;
        if( locked ) return centresInt;
        for( i in 0...l ){
            centresInt[ i + lc ] = blocks[ i ].getCentreInt();
        }
        return centresInt;
    }
    public function getVirtualCentreInt( virtualInt: Array< { x: Int, y: Int} >):Array< { x: Int, y: Int } >{
        var l = virtualBlocks.length;
        if( locked ) return virtualInt;
        for( i in 0...l ){
            virtualInt[ i ] = virtualBlocks[ i ].getCentreInt();
        }
        
        return virtualInt;
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
    public static inline function shapeClose( sh0: Shape, sh1: Shape, diaSq ){
        var vb0 = sh0.virtualBlocks;
        var vb1 = sh1.blocks;
        var l0 = vb0.length;
        var l1 = vb1.length;
        var sq0: Square;
        var sq1: Square;
        var out = false;
        for( i in 0...l0 ){
            sq0 = vb0[i];
            for( j in 0...l1 ){
                sq1 = vb1[j];
                if( Square.squareClose( sq0, sq1, diaSq ) ){
                    out = true;
                    break;
                    break;
                }
            }
        }
        return out;
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