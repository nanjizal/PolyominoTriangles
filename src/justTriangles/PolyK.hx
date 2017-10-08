// Haxe version only tested triangulate so far


/*
    PolyK library
    url: http://polyk.ivank.net
    Released under MIT licence.
    
    Copyright (c) 2012 - 2014 Ivan Kuckir
    Permission is hereby granted, free of charge, to any person
    obtaining a copy of this software and associated documentation
    files (the "Software"), to deal in the Software without
    restriction, including without limitation the rights to use,
    copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following
    conditions:
    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
    OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
    HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
    OTHER DEALINGS IN THE SOFTWARE.
    
    19. 5. 2014 - Problem with slicing fixed.
    27. 12. 2015 - Haxe port by user unknown
*/

package justTriangles;
typedef Rectangle = {
    var x:Float;
    var y:Float; 
    var width:Float; 
    var height:Float;
}
typedef PointK = {
    var x: Float;
    var y: Float;
    var flag: Bool;
}
// Ray returned by RayCast
// "dist" is the distance of the polygon point
// "edge" is the number of the edge, on which intersection occurs
// "norm" is the normal in that place
// "refl" is reflected direction.
typedef Ray = {
    var dist: Float;
    var edge: Float;
    var norm: { x: Float, y: Float };
    var refl: { x: Float, y: Float } ;
}
// Edge returned by ClosestEdge
// "dist" is the distance of the polygon point
// "edge" is the number of the closest edge 
// "point" is the closest point on that edge
// "norm" is the normal from "point" to [x,y].
typedef Edge = {
    var dist: Float;
    var edge: Float;
    var point: { x: Float, y: Float };
    var norm: { x: Float, y: Float };
}
abstract ArrayPairs<T>( Array<T> ) {
    public function new( arr: Array<T> ):Void this = arr;
    public var length( get, never ):Int;
    inline function get_length() return Std.int( this.length/2 );
    @:arrayAccess inline function access( key: Int ): { x: T, y: T } {
        var i: Int = Std.int( key*2 );
        return { x: this[ i ], y: this[ i + 1 ] };
    }
    public inline function reverse(): Array<T>{
        var arr = [];
        for( i in new ArrayPairs( this ) ){
            arr.unshift( i.y );
            arr.unshift( i.x );
        }
        this = arr;
        return arr;
    }
}
abstract ArrayTriple<T>( Array<T> ) {
    public function new( arr: Array<T> ):Void this = arr;
    public var length( get, never ):Int;
    inline function get_length() return Std.int( this.length/3 );
    @:arrayAccess inline function access( key: Int ): { a: T, b: T, c: T } {
        var i: Int = Std.int( key*3 );
        return { a: this[ i ], b: this[ i + 1 ], c: this[ i + 2] };
    }
    public inline function reverse(): Array<T>{
        var arr = [];
        for( i in new ArrayTriple( this ) ){
            arr.unshift( i.c );
            arr.unshift( i.b );
            arr.unshift( i.a );
        }
        this = arr;
        return arr;
    }
}
class PolyK{
    public static inline var small: Float = 0.0000000001;// 1e-10;
    public function new(){}
    
    // Checks, if polygon is simple. Polygon is simple, when its edges don't cross each other.
    public static inline function isSimple( p: Array<Float> ): Bool {
        var n = p.length>>1;
        if( n < 4 ) return true;
        var a1: PointK = { x: 0., y: 0., flag: false }; 
        var a2: PointK = { x: 0., y: 0., flag: false };
        var b1: PointK = { x: 0., y: 0., flag: false };
        var b2: PointK = { x: 0., y: 0., flag: false };
        var c: PointK = { x: 0., y: 0., flag: false };
        var ind: Int;
        for( i in 0...n ){
            ind = Std.int( 2*i );
            a1.x = p[ ind ];
            a1.y = p[ ind + 1 ];
            if( i == n - 1 ){ 
                a2.x = p[ 0 ];
                a2.y = p[ 1 ];
            } else { 
                a2.x = p[ ind + 2 ];
                a2.y = p[ ind + 3 ];
            }
            for( j in 0...n ){
                if( Math.abs( i - j ) < 2 ) continue;
                if( j == n - 1 && i == 0 ) continue;
                if( i == n - 1 && j == 0 ) continue;
                ind = 2*j;
                b1.x = p[ ind ];
                b1.y = p[ ind + 1 ];
                if( j == n - 1 ){ 
                    b2.x = p[ 0 ];
                    b2.y = p[ 1 ];
                } else { 
                    b2.x = p[ ind + 2 ];
                    b2.y = p[ ind + 3 ];
                }
                var c = getLineIntersection( a1, a2, b1, b2 );
                if( c != null ) return false;
            }
        }
        return true;
    }
    
    // Checks, if polygon is convex. Polygon is convex, when each inner angle is <= 180°.
    public static inline function isConvex( p: Array<Float> ): Bool {
        if( p.length < 6 ) return true;
        var l = p.length - 4;
        var l2: Int = Std.int( l/2 );
        var i: Int;
        for( k in 0...l2 ){ 
            i = k*2;
            if( !convex( p[ i ], p[ i + 1 ], p[ i + 2 ], p[ i + 3 ], p[ i + 4 ], p[ i + 5 ] ) ) return false;
        }
        if( !convex( p[ l ], p[ l + 1 ], p[ l + 2 ], p[ l + 3 ], p[ 0 ], p[ 1 ] ) ) return false;
        if( !convex( p[ l + 2 ], p[ l + 3 ], p[ 0 ], p[ 1 ], p[ 2 ], p[ 3 ] ) ) return false;
        return true;
    }
    
    // Returns the area of polygon.
    public static inline function getArea( p: Array<Float> ): Float {
        if( p.length < 6 ) return 0;
        var l = p.length - 2;
        var sum = 0.;
        var l2: Int = Std.int( l/2 );
        var i: Int;
        for( k in 0...l2 ){
            i = k*2;
            sum += ( p[ i + 2 ] - p[ i ] ) * ( p[ i + 1 ] + p[ i + 3 ] );
        }
        sum += ( p[ 0 ] - p[ l ] ) * ( p[ l + 1 ] + p[ 1 ] );
        return - sum * 0.5;
    }
    
    // Returns the Axis-aligned Bounding Box of polygon as Rectangle typedef
    public static inline function getAABB ( p : Array<Float> ) : Rectangle {
        var minx = Math.POSITIVE_INFINITY; 
        var miny = Math.POSITIVE_INFINITY;
        var maxx = Math.NEGATIVE_INFINITY;
        var maxy = Math.NEGATIVE_INFINITY;
        for( i in new ArrayPairs( p ) ){
            minx = Math.min( minx, i.x );
            maxx = Math.max( maxx, i.x );
            miny = Math.min( miny, i.y );
            maxy = Math.max( maxy, i.y );
        }
        return { x: minx, y: miny, width: maxx - minx, height: maxy - miny };
    }
    
    public static inline function reverse( p: Array<Float> ):Array<Float> {
        var ap = new ArrayPairs( p );
        return ap.reverse();
    }
    
    //Computes the triangulation. Output array is array of triangles (triangle = 3 indices of polygon vertices). E.g.:
    public static inline function triangulate( p: Array<Float> ): Array<Float> {
        var n = p.length>>1;
        if( n < 3 ) return [];
        var tgs = new Array<Float>();
        var avl = [];
        for( i in 0...n ) avl.push( i );
        var i = 0;
        var al: Int = n;
        var i0: Int;
        var i1: Int;
        var i2: Int;
        var vi: Int;
        var ax: Float;
        var ay: Float;
        var bx: Float;
        var by: Float;
        var cx: Float;
        var cy: Float;
        var earFound: Bool;
        while( al > 3 ){
            i0 = avl[ ( i + 0 )%al ];
            i1 = avl[ ( i + 1 )%al ];
            i2 = avl[ ( i + 2 )%al ];
            ax = p[ 2*i0 ];
            ay = p[ 2*i0 + 1 ];
            bx = p[ 2*i1 ];
            by = p[ 2*i1 + 1 ];
            cx = p[ 2*i2 ];  
            cy = p[ 2*i2 + 1 ];
            earFound = false;
            if( convex( ax, ay, bx, by, cx, cy ) ){
                earFound = true;
                for( j in 0...al ){
                    var vi = avl[ j ];
                    if( vi==i0 || vi==i1 || vi==i2 ) continue;
                    if( pointInTriangle( p[ 2*vi ], p[ 2*vi + 1 ], ax, ay, bx, by, cx, cy ) ){ 
                        earFound = false; 
                        break;
                    }
                }
            }
            if( earFound ){
                tgs.push( i0 );
                tgs.push( i1 );
                tgs.push( i2 );
                avl.splice( ( i + 1 )%al, 1);
                al--;
                i = 0;
            } else if( i++ > 3*al ) {
                break;        // no convex angles :(
            }
        }
        tgs.push( avl[ 0 ] );
        tgs.push( avl[ 1 ] );
        tgs.push( avl[ 2 ] );
        return tgs;
    }
    
    // Checks, if polygon contains [ax,ay].
    // Works with simple polygons only.
    // TODO: need to rearrange returns to allow inline?
    public static function containsPoint( p: Array<Float>, px: Float, py: Float ): Bool {
        var n = p.length>>1;
        var ax: Float;
        var ay = p[ 2*n - 3 ] - py; 
        var bx = p[2*n-2]-px;
        var by = p[2*n-1]-py;
        var twoi: Int;
        var lup: Bool = by > ay;
        var lx: Float;
        for( i in 0...n ){
            ax = bx;  
            ay = by;
            twoi = 2*i;
            bx = p[ twoi ] - px;
            by = p[ twoi + 1 ] - py;
            if( ay == by ) continue;
            lup = by > ay;
        }
        var depth = 0;
        for( i in 0...n ) {
            ax = bx;  
            ay = by;
            twoi = 2*i;
            bx = p[ twoi ] - px;
            by = p[ twoi + 1 ] - py;
            if( ay < 0 && by < 0 ) continue;    // both "up" or both "down"
            if( ay > 0 && by > 0 ) continue;    // both "up" or both "down"
            if( ax < 0 && bx < 0 ) continue;     // both points on the left
            if( ay == by && Math.min( ax, bx ) <= 0 ) return true;
            if( ay == by ) continue;
            lx = ax + ( bx - ax )*( -ay )/( by - ay );
            if( lx == 0 ) return true;            // point on edge
            if( lx > 0 ) depth++;
            if( ay == 0 &&  lup && by > ay ) depth--;    // hit vertex, both up
            if( ay == 0 && !lup && by < ay ) depth--; // hit vertex, both down
            lup = by > ay;
        }
        return ( depth & 1) == 1;
    }
    
    // Slices the polygon with line segment A-B, defined by [ax,ay] and [bx,by]. 
    // A, B must not lay inside a polygon. Returns an array of polygons.
    // TODO: can not inline as return not at end, is in easy to adjust?
    public static function slice( p: Array<Float>, ax: Float, ay: Float, bx: Float, by: Float ): Array<Array<Float>> {
        if( containsPoint( p, ax, ay ) || containsPoint( p, bx, by ) ) return [ p.slice( 0 ) ];
        var a = { x: ax, y: ay, flag: false };
        var b = { x: ax, y: ay, flag: false };
        var iscs = [];    // intersections
        var ps = [];    // points
        for( i in new ArrayPairs( p ) ) ps.push( { x: i.x, y: i.y, flag: false } );
        var l = ps.length;
        var isc: PointK;
        var skip: Bool = false;
        for( i in 0...l ){
            if( skip ) {
                skip = false;
                continue;
            }
            isc = getLineIntersection( a, b, ps[i], ps[ ( i + 1 )%ps.length ] );
            var fisc = iscs[ 0 ];
            var lisc = iscs[ iscs.length - 1 ];
            if( ( isc != null ) && (fisc == null || dist( isc, fisc ) > small ) && ( lisc == null || dist( isc, lisc ) > small ) )//&& (isc.x!=ps[i].x || isc.y!=ps[i].y) )
            {
                isc.flag = true;
                iscs.push( isc );
                ps.splice( i + 1, 0 );
                ps.insert( i + 1, isc );
                skip = true;
            }
        }
        if( iscs.length < 2 ) return [ p.slice( 0 ) ];
        var comp = function( u, v ): Int { 
            var val: Float = dist( a, u ) - dist( a, v ); 
            if( val > 0 ){
                return 1;
            }
            if( val < 0 ){
                return -1;
            }
            return 0;
        }
        iscs.sort( comp );
        var pgs = [];
        var dir = 0;
        while( iscs.length > 0 ) {
            var n = ps.length;
            var i0 = iscs[ 0 ];
            var i1 = iscs[ 1 ];
            //if(i0.x==i1.x && i0.y==i1.y) { iscs.splice(0,2); continue;}
            var ind0 = ps.indexOf( i0 );
            var ind1 = ps.indexOf( i1 );
            var solved = false;
            if( firstWithFlag( ps, ind0 ) == ind1 ) {
                solved = true;
            } else {
                i0 = iscs[ 1 ];
                i1 = iscs[ 0 ];
                ind0 = ps.indexOf( i0 );
                ind1 = ps.indexOf( i1 );
                if( firstWithFlag( ps, ind0 ) == ind1 ) solved = true;
            }
            if( solved ){
                dir--;
                var pgn = getPoints( ps, ind0, ind1 );
                pgs.push( pgn );
                ps = getPoints( ps, ind1, ind0 );
                i0.flag = i1.flag = false;
                iscs.splice( 0, 2 );
                if( iscs.length == 0 ) pgs.push( ps );
            } else {
                 dir++;
                 iscs.reverse(); 
            }
            if( dir > 1 ) break;
        }
        var result = new Array<Array<Float>>();
        var l = pgs.length;
        var l2: Int;
        for( i in 0...l ) {
            var pg = pgs[ i ];
            var npg = new Array<Float>();
            l2 = pg.length;
            for( j in 0...l2 ){ 
                npg.push( pg[ j ].x );
                npg.push( pg[ j ].y );
            }
            result.push( npg );
        }
        return result;
    }

    // Finds the closest point of polygon, which lays on ray defined by [x,y] (origin) and [dx,dy] (direction).
    // Returns a Ray typedef
    // Works with simple polygons only.
    public static inline function raycast( p: Array<Float>, x: Float, y: Float, dx: Float, dy: Float, isc: Ray ): Ray {
        var l = p.length - 2;
        var tp = new Array<PointK>();
        for( i in 0...10) tp.push( {x: 0., y: 0., flag: false } );
        var a1 = tp[ 0 ];
        var a2 = tp[ 1 ];
        var b1 = tp[ 2 ];
        var b2 = tp[ 3 ]; 
        var c = tp[ 4 ];
        a1.x = x; 
        a1.y = y;
        a2.x = x + dx;
        a2.y = y+dy;
        if( isc == null ) isc = { dist: 0, edge: 0, norm:{ x: 0, y: 0 }, refl:{ x: 0, y: 0 } };
        isc.dist = Math.POSITIVE_INFINITY;
        var l2: Int = Std.int( l/2 );
        var i: Int;
        for( k in 0...l2 ){
            i = k*2;
            b1.x = p[ i ];
            b1.y = p[ i + 1 ];
            b2.x = p[ i + 2 ];
            b2.y = p[ i + 3 ];
            var nisc = rayLineIntersection( a1, a2, b1, b2, c );
            if( nisc != null ) updateISC( dx, dy, a1, b1, b2, c, i/2, isc );
        }
        b1.x = b2.x;
        b1.y = b2.y;
        b2.x = p[ 0 ];
        b2.y = p[ 1 ];
        var nisc = rayLineIntersection( a1, a2, b1, b2, c );
        if( nisc != null ) updateISC( dx, dy, a1, b1, b2, c, ( p.length/2 ) - 1, isc );
        return ( isc.dist != Math.POSITIVE_INFINITY ) ? isc : null;
    }
    
    // Finds the point on polygon edges, which is closest to [x,y]. Returns an Edge typedef
    public static inline function closestEdge( p: Array<Float>, x: Float, y: Float, isc: Edge ): Edge {
        var l = p.length - 2;
        var tp = new Array<PointK>();
        for( i in 0...10) tp.push( {x: 0., y: 0., flag: false } );
        var a1 = tp[ 0 ];
        var b1 = tp[ 2 ];
        var b2 = tp[ 3 ];
        var c = tp[ 4 ];
        a1.x = x; 
        a1.y = y;
        if( isc == null ) isc = { dist: 0, edge: 0, point: { x: 0, y: 0 }, norm:{ x: 0, y: 0 } };
        isc.dist = Math.POSITIVE_INFINITY;
        var l2: Int = Std.int( l/2 );
        var i: Int;
        for( k in 0...l2 ){
            i = k*2;
            b1.x = p[ i ];
            b1.y = p[ i + 1 ];
            b2.x = p[ i + 2 ];
            b2.y = p[ i + 3 ];
            pointLineDist( a1, b1, b2, i >> 1, isc );
        }
        b1.x = b2.x;
        b1.y = b2.y;
        b2.x = p[ 0 ];
        b2.y = p[ 1 ];
        pointLineDist( a1, b1, b2, l >> 1, isc );
        var idst = 1/isc.dist;
        isc.norm.x = ( x - isc.point.x )*idst;
        isc.norm.y = ( y - isc.point.y )*idst;
        return isc;
    }
    
    private static inline function pointLineDist( p: PointK, a: PointK , b: PointK, edge: Float, isc: Edge ){
        var x = p.x; 
        var y = p.y;
        var x1 = a.x;
        var y1 = a.y; 
        var x2 = b.x;
        var y2 = b.y;
        var A = x - x1;
        var B = y - y1;
        var C = x2 - x1;
        var D = y2 - y1;
        var dot = A * C + B * D;
        var len_sq = C * C + D * D;
        var param = dot / len_sq;
        var xx;
        var yy;
        if( param < 0 || ( x1 == x2 && y1 == y2 ) ){
            xx = x1;
            yy = y1;
        } else if ( param > 1 ) {
            xx = x2;
            yy = y2;
        } else {
            xx = x1 + param * C;
            yy = y1 + param * D;
        }
        var dx = x - xx;
        var dy = y - yy;
        var dst = Math.sqrt( dx * dx + dy * dy );
        if( dst < isc.dist ){
            isc.dist = dst;
            isc.edge = edge;
            isc.point.x = xx;
            isc.point.y = yy;
        }
    }
    
    private static inline function updateISC( dx: Float, dy: Float, a1: PointK, b1: PointK, b2: PointK, c: PointK, edge: Float, isc: Ray ){
        var nrl = dist(a1, c);
        if( nrl < isc.dist ){
            var ibl = 1/dist( b1, b2 );
            var nx = -( b2.y - b1.y )*ibl;
            var ny =  ( b2.x - b1.x )*ibl;
            var ddot = 2*( dx*nx + dy*ny );
            isc.dist = nrl;
            isc.norm.x = nx;  
            isc.norm.y = ny; 
            isc.refl.x = -ddot*nx + dx;
            isc.refl.y = -ddot*ny + dy;
            isc.edge = edge;
        }
    }
        
    private static inline function getPoints( ps: Array<PointK>, ind0: Int, ind1: Int ): Array<PointK> {
        var n = ps.length;
        var nps = [];
        if( ind1 < ind0 ) ind1 += n;
        var l = ind1 + 1;
        for( i in ind0...l ) nps.push( ps[ i%n ] );
        return nps;
    }
    
    // can not inline return not final
    private static function firstWithFlag( ps: Array<PointK>, ind: Int ): Int {
        var n = ps.length;
        while( true ){
            ind = ( ind + 1 )%n;
            if( ps[ ind ].flag ) return ind;
        }
    }
    
    private static inline function pointInTriangle( px: Float, py: Float, ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float ): Bool {
        var v0x = cx - ax;
        var v0y = cy - ay;
        var v1x = bx - ax;
        var v1y = by - ay;
        var v2x = px - ax;
        var v2y = py - ay;
        var dot00 = v0x*v0x + v0y*v0y;
        var dot01 = v0x*v1x + v0y*v1y;
        var dot02 = v0x*v2x + v0y*v2y;
        var dot11 = v1x*v1x + v1y*v1y;
        var dot12 = v1x*v2x + v1y*v2y;
        var invDenom = 1 / ( dot00 * dot11 - dot01 * dot01 );
        var u = ( dot11 * dot02 - dot01 * dot12 ) * invDenom;
        var v = ( dot00 * dot12 - dot01 * dot02 ) * invDenom;
        // Check if point is in triangle
        return ( u >= 0 ) && ( v >= 0 ) && ( u + v < 1 );
    }
    
    private static inline function rayLineIntersection( a1: PointK, a2: PointK, b1: PointK, b2: PointK, c: PointK ): PointK {
        var dax = a1.x - a2.x; 
        var dbx = b1.x - b2.x;
        var day = a1.y - a2.y;
        var dby = b1.y - b2.y;
        var Den = dax*dby - day*dbx;
        if( Den == 0 ) return null;    // parallel
        var A = ( a1.x * a2.y - a1.y * a2.x );
        var B = ( b1.x * b2.y - b1.y * b2.x );
        var I = c;
        var iDen = 1/Den;
        I.x = ( A*dbx - dax*B ) * iDen;
        I.y = ( A*dby - day*B ) * iDen;
        if( !inRect( I, b1, b2 ) ) return null;
        if( ( day > 0 && I.y > a1.y ) || ( day < 0 && I.y < a1.y ) ) return null; 
        if( ( dax > 0 && I.x > a1.x ) || ( dax < 0 && I.x < a1.x ) ) return null; 
        return I;
    }
    
    private static inline function getLineIntersection( a1: PointK, a2: PointK, b1: PointK, b2: PointK ): PointK {
        var dax = (a1.x-a2.x), dbx = (b1.x-b2.x);
        var day = (a1.y-a2.y), dby = (b1.y-b2.y);
        var Den = dax*dby - day*dbx;
        if( Den == 0 ) return null;    // parallel
        var A = ( a1.x * a2.y - a1.y * a2.x );
        var B = (b1.x * b2.y - b1.y * b2.x);
        var I = { x: ( A*dbx - dax*B ) / Den, y:( A*dby - day*B ) / Den, flag: false };
        if( inRect( I, a1, a2 ) && inRect( I, b1, b2 ) ) return I;
        return null;
    }
    
    private static inline function inRect( a: PointK, b: PointK, c: PointK ): Bool {// a in rect (b,c)
        var minx = Math.min( b.x, c.x );
        var maxx = Math.max( b.x, c.x );
        var miny = Math.min( b.y, c.y );
        var maxy = Math.max( b.y, c.y );
        if( minx == maxx ) return ( miny <= a.y && a.y <= maxy );
        if( miny == maxy ) return ( minx <= a.x && a.x <= maxx);
        //return (minx <= a.x && a.x <= maxx && miny <= a.y && a.y <= maxy)
        return ( minx <= a.x + small && a.x - small <= maxx && miny <= a.y + small && a.y - small <= maxy );        
    }
    
    private static inline function convex( ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float ): Bool { 
        return ( ay - by )*( cx - bx ) + ( bx - ax )*( cy - by ) >= 0;
    }
    
    // calculates distance between points
    private static inline function dist( a: PointK, b: PointK ): Float {
        var dx = b.x - a.x;
        var dy = b.y - a.y;
        return Math.sqrt( dx*dx + dy*dy );
    }
    
}
