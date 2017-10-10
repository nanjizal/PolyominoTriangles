package tetrisTriangles.game;
import justTriangles.Point;
import justTriangles.Triangle;
// uses two triangles to help construct the visual shapes.
class Square {
    var t0:     Triangle;
    var t1:     Triangle;
    var id:     Int;
    var col0:   Int;
    var col1:   Int;
    var dia:    Float; // diameter
    var gap:    Float;
    var _x:     Float;
    var _y:     Float;
    var _x2:    Float;
    var _y2:    Float;
    var triangles: Array<Triangle>;
    public function new(    id:         Int
                        ,   triangles_:  Array<Triangle>
                        ,   x_:         Float,      y_:     Float
                        ,   dia_:       Float,      gap_:   Float 
                        ,   col0_:      Int,        col1_:  Int ){
        gap_    = 0.;
        _x      = x_ + gap_;
        _y      = y_ + gap_;
        col0    = col0_;
        col1    = col1_;
        dia     = dia_;
        gap     = gap_;
        _x2     = x_ + dia_ - 2 * gap_; 
        _y2     = y_ + dia_ - 2 * gap_;
        var rad = dia_/2;
        var x2  = _x2;
        var y2  = _y2;
        triangles = triangles_;
        var l   = triangles_.length;
        t0 = new Triangle( id                // top left
                        , true
                        , { x: x_, y: y_ }
                        , { x: x2, y: y_ }
                        , { x: x_, y: y2 }
                        , 0
                        , col0 );
        
        t1 = new Triangle( id               // bottom right
                        , true
                        , { x: x_, y: y2 }
                        , { x: x2, y: y_ }
                        , { x: x2, y: y2 }
                        , 0
                        , col1 );
        triangles[ l++ ] = t0;
        triangles[ l++ ] = t1;
    }
    public function removeTriangles(){
        triangles.remove( t0 );
        triangles.remove( t1 );
        //t0 = null;
        //t1 = null;
    }
    public inline
    function changeColor( col0_: Int, col1_: Int ){
        col0 = col0_;
        col1 = col1_;
        t0.colorID = col0_;
        t1.colorID = col1_;
        t0.colorA = col0_;
        t0.colorB = col0_;
        t0.colorC = col0_;
        t1.colorA = col1_;
        t1.colorB = col1_;
        t1.colorC = col1_;
    }
    public function getPoints( arr: Array<Point> ){ // TODO: consider Array<Float>
        var l = arr.length;
        arr[ l++ ] = { x: t0.ax, y: t0.ay };
        arr[ l++ ] = { x: t0.bx, y: t0.by };
        arr[ l++ ] = { x: t0.cx, y: t0.cy };
        arr[ l++ ] = { x: t1.ax, y: t1.ay };
        arr[ l++ ] = { x: t1.bx, y: t1.by };
        arr[ l++ ] = { x: t1.cx, y: t1.cy };
        return arr;
    }
    public function moveDelta( dx: Float, dy: Float ){
        t0.moveDelta( dx, dy );
        t1.moveDelta( dx, dy );
    } 
    // try to use rotateAround if rotating lots of squares
    inline function rotateAroundTheta( p: Point, theta ){
        var cos = Math.cos( theta );
        var sin = Math.sin( theta );
        rotateAround( p, cos, sin );
    }
    public inline function rotateAround( p: Point, cos: Float, sin: Float ){
        t0.rotateTrig( p, cos, sin );
        t1.rotateTrig( p, cos, sin );
    }
    public function hasTriangles():Bool{
        return ( t0 != null && t1 != null );
    }
    public inline function getCentre():{x: Float, y:Float}{
        var dx = t0.bx;
        var dy = t0.by;
        var ex = t0.cx;
        var ey = t0.cy;
        return { x: if( dx < ex ){ // dx is left
                        dx + ( ex - dx )/2;
                    } else {
                        ex + ( dx - ex )/2;
                    },
                y:  if( dy < ey ){ // dy is top
                        dy + ( ey - dy )/2;
                    } else {
                        dy + ( dy - ey )/2 - dia;
                    } };
    }
    // faster and more acurate?
    public function getCentreInt():{ x: Int, y: Int }{
        var c = getCentre();
        return { x: Std.int( c.x/dia ), y: Std.int( c.y/dia ) };
    }
    public var right( get, never ): Float;
    public function get_right(): Float {
        return Math.max( t0.right, t1.right );
    }
    public var bottom( get, never ): Float;
    public function get_bottom(): Float {
        return Math.max( t0.bottom, t1.bottom );
    }
    public var x( get, set ): Float;
    function get_x() {
        // dirtyX not working :( 
        // return ( dirtyX )? Math.min( t0.x, t1.x ): _x;
        return Math.min( t0.x, t1.x );
    }
    function set_x( x_: Float ): Float {
        var x0 = t0.x;
        var x1 = t1.x;
        if( x0 < x1 ){
            var dx  = x_ - x0;
            t0.x    = x_;
            t1.x    += dx;
        } else {
            var dx  = x_ - x1;
            t1.x    = x_;
            t0.x    += dx;
        }
        _x = x_;
        return x_;
    }
    public var y( get, set ): Float;
    function get_y() {
        return Math.min( t0.y, t1.y );
    }
    function set_y( y_: Float ): Float {
        var y0 = t0.y;
        var y1 = t1.y;
        if( y0 < y1 ){
            var dy  = y_ - y0;
            t0.y    = y_;
            t1.y    += dy;
        } else {
            var dy  = y_ - y1;
            t1.y    = y_;
            t0.y    += dy;
        }
        _y = y_;
        return y_;
    }
    public function hitTest( p: Point ){
        return t0.hitTest( p ) || t1.hitTest( p );
    }
    public inline static function squareClose( s0: Square, s1: Square, diaSq: Float ){ 
        var c0 = s0.getCentre();
        var c1 = s1.getCentre();
        var dx = c0.x - c1.x;
        var dy = c0.y - c1.y;
        var d0 = dx * dx + dy * dy;
        return d0 < diaSq;
    }

    /*
    // using centre is perhaps not ideal could be optimized.
    public function getCentre():{x:Float,y:Float}{
        return { x: centreX, y: centreY };
    }
    public var centreX( get, never ): Float;
    public function get_centreX(): Float{
        var x_ = x;
        return x_ + (right - x_)/2;
    }
    public var centreY( get, never ):Float;
    public function get_centreY():Float{
        var y_ = y;
        return y_ + (bottom - y_)/2;
    }
    */
}