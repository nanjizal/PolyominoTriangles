package tetrisTriangles.visual;
import justTriangles.Point;
import justTriangles.Triangle;
class Square {
    var t0: Triangle;
    var t1: Triangle;
    var id: Int;
    var col0_id: Int;
    var col1_id: Int;
    var dia: Float; // diameter
    var gap: Float;
    var dirtyX: Bool = false;
    var dirtyY: Bool = false;
    var _x: Float;
    var _y: Float;
    var _x2: Float;
    var _y2: Float;
    public function new(    id: Int
                        ,   triangles:      Array<Triangle>
                        ,   x_: Float,      y_: Float
                        ,   col0_id_: Int,  col1_id_: Int
                        ,   dia_: Float,    gap_: Float ){
        gap_ = 0.;
        _x = x_ + gap_;
        _y = y_ + gap_;
        col0_id = col0_id_;
        col1_id = col1_id_;
        dia = dia_;
        gap = gap_;
        _x2 = x_ + dia_ - 2*gap_; 
        _y2 = y_ + dia_ - 2*gap_;
        var x2 = _x2;
        var y2 = _y2;
        var l = triangles.length;
        // top left
        t0 = new Triangle( id
                        , true
                        , { x: x_, y: y_ }
                        , { x: x2, y: y_ }
                        , { x: x_, y: y2 }
                        , 0
                        , col0_id );
        // bottom right
        t1 = new Triangle( id
                        , true
                        , { x: x_, y: y2 }
                        , { x: x2, y: y_ }
                        , { x: x2, y: y2 }
                        , 0
                        , col1_id );
        triangles[ l++ ] = t0;
        triangles[ l++ ] = t1;
    }
    // consider Array<Float>
    public function getPoints( arr: Array<Point> ){
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
    // refactor to Triangles?
    @:access( justTriangles.Triangle.moveDelta )
    public inline function rotateTriangle( t: Triangle, p: Point, cos: Float, sin: Float ){
        dirtyX = true;
        dirtyY = true;
        t.moveDelta( -p.x, -p.y );
        t.moveDelta( -p.x, -p.y );
        var x: Float;
        var y: Float;
        x = t.ax;
        y = t.ay;
        t.ax = x * cos - y * sin;
        t.ay = x * sin + y * cos; 
        x = t.bx;
        y = t.by;
        t.bx = x * cos - y * sin;
        t.by = x * sin + y * cos; 
        x = t.cx;
        y = t.cy;
        t.cx = x * cos - y * sin;
        t.cy = x * sin + y * cos;
        t.moveDelta( p.x, p.y );
        t.moveDelta( p.x, p.y );
        // don't calculate just save that x, y coordinates are dirty.
        dirtyX = true;
        dirtyY = true;
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
        return ( dirtyX )? Math.min( t0.x, t1.x ): _x;
    }
    function set_x( x: Float ): Float {
        var x0 = t0.x;
        var x1 = t1.x;
        if( x0 < x1 ){
            var dx = x0 - x;
            t0.x = x;
            t1.x = x + dx;
        } else {
            var dx = x1 - x;
            t0.x = x + dx;
            t1.x = x;
        }
        _x = x;
        dirtyX = false;
        return x;
    }
    public var y( get, set ): Float;
    function get_y() {
        return ( dirtyY )? Math.min( t0.y, t1.y ): _y;
    }
    function set_y( y: Float ): Float {
        var y0 = t0.y;
        var y1 = t1.y;
        if( y0 < y1 ){
            var dy = y0 - y;
            t0.y = y;
            t1.y = y + dy;
        } else {
            var dy = y1 - y;
            t0.y = y + dy;
            t1.y = y;
        }
        dirtyY = false;
        _y = y;
        return y;
    }
    public function hitTest( p: Point ){
        return t0.hitTest( p ) || t1.hitTest( p );
    }
}