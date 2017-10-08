package justTriangles;
import justTriangles.Point;
class Triangle {
    public static var triangles = new Array<Triangle>();
    public static inline function drawTri(   id: Int, outline: Bool, p0: Point, p1: Point, p2: Point, colorID: Int ):Void {
        triangles.push( new Triangle( id, outline, p0, p1, p2, 0, colorID ) );
    };
    public var id: Int;
    public var colorID: Int;
    public var windingAdjusted: Bool;
    public var colorA: Int;
    public var colorB: Int;
    public var colorC: Int;
    
    public var outline: Bool;
    public var depth: Float;
    public var ax: Float;
    public var bx: Float;
    public var cx: Float;
    public var ay: Float;
    public var by: Float;
    public var cy: Float;
    public var x( get, set ): Float;
    function get_x() {
        return Math.min( Math.min( ax, bx ), cx );
    }
    function set_x( x: Float ): Float {
        var dx = x - get_x();
        ax = ax + dx;
        bx = bx + dx;
        cx = cx + dx;
        return x;
    }
    public var y( get, set ): Float;   
    function get_y(): Float {
        return Math.min( Math.min( ay, by ), cy );
    }
    function set_y( y: Float ): Float {
        var dy = y - get_y();
        ay = ay + dy;
        by = by + dy;
        cy = cy + dy;
        return y;
    }
    public var right( get, never ): Float;
    public function get_right(): Float {
        return Math.max( Math.max( ax, bx ), cx );
    }
    public var bottom( get, never ): Float;
    public function get_bottom(): Float {
        return Math.max( Math.max( ay, by ), cy );
    }
    function moveDelta( dx: Float, dy: Float ){
        ax += dx;
        ay += dy;
        bx += dx;
        by += dy;
        cx += dx;
        cy += dy;
    }   
    public function new(  id_: Int
                        , outline_: Bool
                        , A_: Point, B_: Point, C_: Point
                        , depth_: Float
                        , colorID_: Int
                        ){
        id = id_;
        outline = outline_;
        var adjust = adjustWinding( A_, B_, C_ );
        if( adjust ){
            ax = A_.x;
            ay = A_.y;
            bx = C_.x;
            by = C_.y;
            cx = B_.x;
            cy = B_.y;
        } else {
            ax = A_.x;
            ay = A_.y;
            bx = B_.x;
            by = B_.y;
            cx = C_.x;
            cy = C_.y;
        }
        windingAdjusted = adjust;
        depth = depth_;
        colorID = colorID_;
        colorA = colorID_;
        colorB = colorID_;
        colorC = colorID_;
    }
    // A B C, you can find the winding by computing the cross product (B - A) x (C - A)
    inline static function adjustWinding( A_: Point, B_: Point, C_: Point ): Bool{
        var val: Bool = !( cross( subtract( B_, A_ ), subtract( C_, A_ ) ) < 0 );
        return val;
    }
    // subtract
    inline static function subtract( p0:Point, p1:Point ) : Point {
        return { x: p0.x - p1.x, y: p0.y - p1.y };
    }
    // to get the cross product
    inline static function cross(p0:Point, p1:Point) : Float {
        return p0.x*p1.y - p0.y*p1.x;
    }
    //http://www.emanueleferonato.com/2012/06/18/algorithm-to-determine-if-a-point-is-inside-a-triangle-with-mathematics-no-hit-test-involved/
    public function hitTest( P: Point ): Bool {
        var px: Float = P.x;
        var py: Float = P.y;
        if( px > x && px < right && py > y && py < bottom ) return true;
        var planeAB = ( ax - px )*( by - py ) - ( bx - px )*( ay - py );
        var planeBC = ( bx - px )*( cy - py ) - ( cx - px )*( by - py );
        var planeCA = ( cx - px )*( ay - py ) - ( ax - px )*( cy - py );
        return sign( planeAB ) == sign( planeBC ) && sign( planeBC ) == sign( planeCA );
    }
    function sign( n: Float ): Int {
        return Std.int( Math.abs( n )/n );
    }
    // no bounds checking
    inline function liteHit( px: Float, py: Float ): Bool {
        var planeAB = ( ax - px )*( by - py ) - ( bx - px )*( ay - py );
        var planeBC = ( bx - px )*( cy - py ) - ( cx - px )*( by - py );
        var planeCA = ( cx - px )*( ay - py ) - ( ax - px )*( cy - py );
        return sign( planeAB ) == sign( planeBC ) && sign( planeBC ) == sign( planeCA );
    }
    // draws Triangle with horizontal strips 1px high.
    public function drawStrips( drawRect: Float->Float->Float->Float->Void ){
        var xi: Int         = Math.floor( x );
        var yi: Int         = Math.floor( y );
        var righti: Int     = Math.ceil( right );
        var bottomi: Int    = Math.ceil( bottom );
        var sx: Int = 0;
        var ex: Int = 0;
        var sFound: Bool;
        var eFound: Bool;
        // need to adjust for negative values thought required.
        for( y0 in yi...bottomi ){ // loop vertically
            sFound = false; // could remove if swapped floor and ceil on boundaries?
            eFound = false; // not needed perhaps just for safety at mo.
            for( x0 in xi...righti ){
                if( liteHit( x0, y0 ) ) { // start strip
                    sx = x0;
                    sFound = true;
                    break;
                }
            }
            if( sFound ){
                for( x0 in sx...righti ){ // end strip
                    if( !liteHit( x0, y0 ) ){
                        ex = x0;
                        eFound = true;
                        break;
                    }
                }
                if( eFound ) drawRect( sx, y0, ex - sx, 1 );
            }
        }
    }
    
}
