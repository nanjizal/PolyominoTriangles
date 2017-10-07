package tetrisTriangles.game;
import justTriangles.Point;
import justTriangles.Triangle;
class Square {
    var t0:     Triangle;
    var t1:     Triangle;
    var id:     Int;
    var col0:   Int;
    var col1:   Int;
    var dia:    Float; // diameter
    var gap:    Float;
    var dirtyX: Bool = false;
    var dirtyY: Bool = false;
    var _x:     Float;
    var _y:     Float;
    var _x2:    Float;
    var _y2:    Float;
    var cX:     Float;
    var cY:     Float;
    public function new(    id:         Int
                        ,   triangles:  Array<Triangle>
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
        cX      = x_ + rad;
        cY      = y_ + rad;
        var x2  = _x2;
        var y2  = _y2;
        var l   = triangles.length;
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
    @:access( justTriangles.Triangle.moveDelta )
    public function moveDelta( dx: Float, dy: Float ){
        cX += dx;
        cY += dy;
        t0.moveDelta( dx, dy );
        t1.moveDelta( dx, dy );
    } 
    // try to use rotateAround if rotating lots of squares
    public inline function rotateAroundTheta( p: Point, theta ){
        var cos = Math.cos( theta );
        var sin = Math.sin( theta );
        rotateAround( p, cos, sin );
    }
    public inline function rotateAround( p: Point, cos: Float, sin: Float ){
        rotateTriangle( t0, p, cos, sin );
        rotateTriangle( t1, p, cos, sin );
    }
    // TODO: refactor to Triangles?
    @:access( justTriangles.Triangle.moveDelta )
    public inline function rotateTriangle( t: Triangle, p: Point, cos: Float, sin: Float ){
        dirtyX = true;
        dirtyY = true;
        cX -= p.x;
        cY -= p.y;
        t.moveDelta( -p.x, -p.y );
        t.moveDelta( -p.x, -p.y );
        var x: Float;
        var y: Float;
        x       = cX;
        y       = cY;
        cX      = x * cos - y * sin;
        cY      = x * sin + y * cos; 
        x       = t.ax;
        y       = t.ay;
        t.ax    = x * cos - y * sin;
        t.ay    = x * sin + y * cos; 
        x       = t.bx;
        y       = t.by;
        t.bx    = x * cos - y * sin;
        t.by    = x * sin + y * cos; 
        x       = t.cx;
        y       = t.cy;
        t.cx    = x * cos - y * sin;
        t.cy    = x * sin + y * cos;
        t.moveDelta( p.x, p.y );
        t.moveDelta( p.x, p.y );
        cX += p.x;
        cY += p.y;
        dirtyX = true; // don't calculate just save that x, y coordinates are dirty.
        dirtyY = true;
    }
    // faster and more acurate?
    public function getQuickCentre():{ x: Float, y: Float }{
        return { x: cX, y: cY };
    }
    public function getCentreInt():{ x: Int, y: Int }{
        return { x: Std.int( cX/dia ), y: Std.int( cY/dia ) };
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
        cX = x_ + dia/2;
        var x0 = t0.x;
        var x1 = t1.x;
        if( x0 < x1 ){
            var dx  = x0 - x_;
            t0.x    = x_;
            t1.x    = x_ + dx;
        } else {
            var dx  = x1 - x_;
            t0.x    = x_ + dx;
            t1.x    = x_;
        }
        _x = x_;
        dirtyX = false;
        return x_;
    }
    public var y( get, set ): Float;
    function get_y() {
        return ( dirtyY )? Math.min( t0.y, t1.y ): _y;
    }
    function set_y( y_: Float ): Float {
        cY = y_ + dia/2;
        var y0 = t0.y;
        var y1 = t1.y;
        if( y0 < y1 ){
            var dy  = y0 - y_;
            t0.y    = y_;
            t1.y    = y_ + dy;
        } else {
            var dy  = y1 - y_;
            t0.y    = y_ + dy;
            t1.y    = y_;
        }
        dirtyY = false;
        _y = y_;
        return y_;
    }
    public function hitTest( p: Point ){
        return t0.hitTest( p ) || t1.hitTest( p );
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