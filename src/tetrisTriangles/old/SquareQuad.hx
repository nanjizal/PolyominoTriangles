package tetrisTriangles.old;
import justTriangles.Point;
import justTriangles.Triangle;
// Test of feasiblity of 4 triangles instead of 2 but the x, y logic gets bit messy.
// Too much hassle to visually test properly works but to feed colors through lots of change.
class SquareQuad{
    var t0:         Triangle;
    var t1:         Triangle;
    var t2:         Triangle;
    var t3:         Triangle;
    var id:         Int;
    var col0:       Int;
    var col1:       Int;
    var col2:       Int;
    var col3:       Int;
    var dia:        Float; // diameter
    var gap:        Float;
    var dirtyX:     Bool = false;
    var dirtyY:     Bool = false;
    var _x:         Float;
    var _y:         Float;
    var _right:    Float;
    var _bottom:    Float;
    var cX:         Float;
    var cY:         Float;
    var notQuads: Bool = false;
    public function new(    id:         Int
                        ,   triangles:  Array<Triangle>
                        ,   x_:         Float,      y_:     Float
                        ,   dia_:       Float,      gap_:   Float
                        ,   col0_:      Int,        col1_:  Int
                        ,   ?col2_:      Int,       ?col3_:  Int
                        ){
        gap_    = 0.;
        _x      = x_ + gap_;
        _y      = y_ + gap_;
        col0    = col0_;
        col1    = col1_;
        if( col2 != null ) {
            notQuads = true;
            col2    = col2_;
            col3    = col3_;
        }
        dia     = dia_;
        gap     = gap_;
        _right     = x_ + dia_ - 2 * gap_; 
        _bottom     = y_ + dia_ - 2 * gap_;
        var rad = dia_/2;
        cX      = x_ + rad;
        cY      = y_ + rad;
        var l   = triangles.length;
        if( notQuads ){
            t0 = new Triangle( id                // top left
                            , true
                            , { x: x_, y: y_ }
                            , { x: _right, y: y_ }
                            , { x: x_, y: _bottom }
                            , 0
                            , col0 );
            
            t1 = new Triangle( id               // bottom right
                            , true
                            , { x: x_, y: _bottom }
                            , { x: _right, y: y_ }
                            , { x: _right, y: _bottom }
                            , 0
                            , col1 );
            triangles[ l++ ] = t0;
            triangles[ l++ ] = t1;
        } else {
            t0 = new Triangle( id                // left
                            , true
                            , { x: x_, y: y_ }
                            , { x: cX, y: cY }
                            , { x: x_, y: _bottom }
                            , 0
                            , col0 );
            t1 = new Triangle( id                // top
                            , true
                            , { x: x_, y: y_ }
                            , { x: _right, y: y_ }
                            , { x: cX, y: cY }
                            , 0
                            , col1 );
            
            t2 = new Triangle( id               // right
                            , true
                            , { x: cX, y: cY }
                            , { x: _right, y: y_ }
                            , { x: _right, y: _bottom }
                            , 0
                            , col2 );
            t3 = new Triangle( id               // bottom
                            , true
                            , { x: x_, y: _bottom }
                            , { x: cX, y: cY }
                            , { x: _right, y: _bottom }
                            , 0
                            , col3 );
               trace( t0 + '  ' + t1 + ' ' + t2 + '  ' + t3 );             
            triangles[ l++ ] = t0;
            triangles[ l++ ] = t1;
            triangles[ l++ ] = t2;
            triangles[ l++ ] = t3;
        }
    }
    public function getPoints( arr: Array<Point> ){ // TODO: consider Array<Float>
        var l = arr.length;
        arr[ l++ ] = { x: t0.ax, y: t0.ay };
        arr[ l++ ] = { x: t0.bx, y: t0.by };
        arr[ l++ ] = { x: t0.cx, y: t0.cy };
        arr[ l++ ] = { x: t1.ax, y: t1.ay };
        arr[ l++ ] = { x: t1.bx, y: t1.by };
        arr[ l++ ] = { x: t1.cx, y: t1.cy };
        if( !notQuads ){
            arr[ l++ ] = { x: t2.ax, y: t2.ay };
            arr[ l++ ] = { x: t2.bx, y: t2.by };
            arr[ l++ ] = { x: t2.cx, y: t2.cy };
            arr[ l++ ] = { x: t3.ax, y: t3.ay };
            arr[ l++ ] = { x: t3.bx, y: t3.by };
            arr[ l++ ] = { x: t3.cx, y: t3.cy };
        }
        return arr;
    }
    @:access( justTriangles.Triangle.moveDelta )
    public function moveDelta( dx: Float, dy: Float ){
        cX += dx;
        cY += dy;
        t0.moveDelta( dx, dy );
        t1.moveDelta( dx, dy );
        if( !notQuads ){
            t2.moveDelta( dx, dy );
            t3.moveDelta( dx, dy );
        }
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
        if( !notQuads ){
            rotateTriangle( t2, p, cos, sin );
            rotateTriangle( t3, p, cos, sin );
        }
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
        var r: Float;
        if( notQuads ){
            r = Math.max( t0.right, t1.right );
        } else {
            r = Math.max( Math.max( t0.right, t1.right ), Math.max( t2.right, t3.right ) );
        }
        return r;
    }
    public var bottom( get, never ): Float;
    public function get_bottom(): Float {
        var b: Float;
        if( notQuads ){
            b = Math.max( t0.bottom, t1.bottom );
        } else {
            b = Math.max( Math.max( t0.bottom, t1.bottom ), Math.max( t2.bottom, t3.bottom ));
        }
        return b;
    }
    public var x( get, set ): Float;
    function get_x() {
        // dirtyX not working :( 
        // return ( dirtyX )? Math.min( t0.x, t1.x ): _x;
        var l;
        if( notQuads ){
            l = Math.min( t0.x, t1.x );
        } else {
            l = Math.min( Math.min( t0.x, t1.x ),Math.min( t2.x, t3.x ));
        }
        return l;
    }
    function set_x( x_: Float ): Float {
        cX = x_ + dia/2;
        var x0 = t0.x;
        var x1 = t1.x;
        if( notQuads ){
            if( x0 < x1 ){
                var dx  = x0 - x_;
                t0.x    = x_;
                //t1.x    = x_ + dx;
                t1.x += dx;
            } else {
                var dx  = x1 - x_;
                //t0.x    = x_ + dx;
                t0.x += dx;
                t1.x    = x_;
            }
        } else {
            var x2 = t2.x;
            var x3 = t3.x;
            var x4 = get_x();
            if( x4 == x0 ){
                var dx  = x0 - x_;
                t0.x    = x_;
                t1.x    += dx;
                t2.x    += dx;
                t3.x    += dx;
            } else if( x4 == x1 ){
                var dx  = x1 - x_;
                t1.x    = x_;
                t0.x    += dx;
                t2.x    += dx;
                t3.x    += dx;
            } else if( x4 == x2 ){
                var dx  = x2 - x_;
                t2.x    = x_;
                t0.x    += dx;
                t1.x    += dx;
                t3.x    += dx;
            } else if( x4 == x3 ){
                var dx  = x3 - x_;
                t3.x    = x_;
                t0.x    += dx;
                t1.x    += dx;
                t2.x    += dx;
            }
        }
        _x = x_;
        dirtyX = false;
        return x_;
    }
    public var y( get, set ): Float;
    function get_y() {
        //return ( dirtyY )? Math.min( t0.y, t1.y ): _y;
        var t: Float;
        if( notQuads ){
            t = Math.min( t0.y, t1.y );
        } else {
            t = Math.min( Math.min( t0.y, t1.y ), Math.min( t2.y, t3.y ));
        }
        return t;
    }
    function set_y( y_: Float ): Float {
        cY = y_ + dia/2;
        var y0 = t0.y;
        var y1 = t1.y;
        if( notQuads ){
            if( y0 < y1 ){
                var dy  = y0 - y_;
                t0.y    = y_;
                //t1.y    = y_ + dy;
                t1.y += dy;
            } else {
                var dy  = y1 - y_;
                //t0.y    = y_ + dy;
                t0.y += dy;
                t1.y    = y_;
            }
        } else {
            var y2 = t2.y;
            var y3 = t3.y;
            var y4 = get_y();
            if( y4 == y0 ){
                var dy  = y0 - y_;
                t0.y    = y_;
                t1.y    += dy;
                t2.y    += dy;
                t3.y    += dy;
            } else if( y4 == y1 ){
                var dy  = y1 - y_;
                t1.y    = y_;
                t0.y    += dy;
                t2.y    += dy;
                t3.y    += dy;
            } else if( y4 == y2 ){
                var dy  = y2 - y_;
                t2.y    = y_;
                t0.y    += dy;
                t1.y    += dy;
                t3.y    += dy;
            } else if( y4 == y3 ){
                var dy  = y3 - y_;
                t3.y    = y_;
                t0.y    += dy;
                t1.y    += dy;
                t2.y    += dy;
            }
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