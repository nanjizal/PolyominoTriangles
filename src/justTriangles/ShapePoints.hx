package justTriangles;
import justTriangles.Point;
import justTriangles.Bezier;
class ShapePoints {
    // Create Rectangular Box Points
    public static inline function boxPoints( p: Point, wid: Float, hi: Float ): Array<Point>{
        var p: Array<Point> = [     { x: p.x, y: p.y }
                                ,   { x: p.x+wid, y: p.y }
                                ,   { x: p.x+wid, y: p.y+hi }
                                ,   { x: p.x, y: p.y+hi }
                                ,   { x: p.x, y: p.y }
                                ,   { x: p.x+wid, y: p.y }
                                ,   { x: p.x+wid, y: p.y+hi }
                                ];
        return p;
    }
    // Create Rectangular Box Points
    public static inline function box( x: Float,y: Float, wid: Float, hi: Float ): Array<Point>{
        var p: Array<Point> = [     { x: x, y: y }
                                ,   { x: x+wid, y: y }
                                ,   { x: x+wid, y: y+hi }
                                ,   { x: x, y: y+hi }
                                ,   { x: x, y: y }
                                ,   { x: x+wid, y: y }
                                ,   { x: x+wid, y: y+hi }
                                ];
        p.reverse();
        return p;
    }
    // Create Equalatrial Triangle points
    public static inline function equalTri( dx: Float, dy: Float
                                                , radius: Float, ?rotation: Float = 0 ):Array<Point>{
        var p: Array<Point> = new Array<Point>();
        var angle: Float = 0;
        var offset: Float = - 2.5*Math.PI*2/6 - Math.PI + rotation;
        for( i in 0...6 ){
            angle = i*( Math.PI*2 )/3 - offset; 
            p.push( { x: dx + radius * Math.cos( angle ), y: dy + radius * Math.sin( angle ) });
        } 
        p.reverse();
        return p;
    }
    // Create Polygon Points
    public static inline function polyPoints( d: Point, radius: Float, sides: Int, ?rotation: Float = 0 ):Array<Point>{
        var p: Array<Point> = new Array<Point>();
        var angle: Float = 0;
        var angleInc: Float = ( Math.PI*2 )/sides;
        var offset: Float = rotation - Math.PI/2;
        var tot = sides + 3;
        for( i in 0...tot ){
            angle = i*angleInc;
            angle = angle + offset; // ?  to test!
            p[ tot - i - 1 ] = { x: d.x + radius * Math.cos( angle ), y: d.y + radius * Math.sin( angle ) }
        }
        return p;
    }
    // Create Polygon Points
    public static inline function poly( dx: Float, dy: Float
                                      , radius: Float, sides: Int ):Array<Point>{
        var p: Array<Point> = new Array<Point>();
        var angle: Float = 0;
        var angleInc: Float = ( Math.PI*2 )/sides;
        for( i in 0...( sides + 3 ) ){
            angle = i*angleInc; 
            p.push( { x: dx + radius * Math.cos( angle ), y: dy + radius * Math.sin( angle ) });
        } 
        p.reverse();
        return p;
    }
    // Create Horizontal Wave Points
    public static inline function horizontalWave( x_: Float, dx_: Float, y_: Float
                                                , amplitude: Float, sides: Int, repeats: Float ):Array<Point>{
        var p: Array<Point> = new Array<Point>(); 
        var dx: Float = 0;
        var angleInc: Float = ( Math.PI*2 )/sides;
        var len: Int = Std.int( sides*repeats );
        for( i in 0...len ) p.push( { x: x_ + (dx+=dx_), y: y_ + amplitude * Math.sin( i*angleInc ) });
        return p;
    }
    // Create Vertical Wave Points
    public static inline function verticalWave( x_: Float, y_: Float, dy_: Float
                                              , amplitude: Float, sides: Int, repeats: Float ):Array<Point>{
        var p: Array<Point> = new Array<Point>(); 
        var dy: Float = 0;
        var angleInc: Float = ( Math.PI*2 )/sides;
        var len: Int = Std.int( sides*repeats );
        for( i in 0...len ) p.push( { y: y_ + (dy+=dy_), x: x_ + amplitude * Math.sin( i*angleInc ) });
        return p;
    }
    // Create Arc Points
    public static inline function arcPoints( d: Point, radius: Float, start: Float, dA: Float, sides: Int ):Array<Point>{
        var p: Array<Point> = new Array<Point>();
        var dx = d.x;
        var dy = d.y;
        var angle: Float = 0;
        var angleInc: Float = ( Math.PI*2 )/sides;
        var sides = Math.round( sides );
        var nextAngle: Float;
        if( dA < 0 ){
            var i = -1;
            while( true ){
                angle = i*angleInc;
                nextAngle = angle + start; 
                i--;
                if( angle <= dA ) break; 
                p.push( { x: dx + radius * Math.cos( nextAngle ), y: dy + radius * Math.sin( nextAngle ) });
            } 
        } else {
            var i = -1;
            while( true ){
                angle = i*angleInc;
                i++;
                nextAngle = angle + start; 
                if( angle >= ( dA + angleInc ) ) break; 
                p.push( { x: dx + radius * Math.cos( nextAngle ), y: dy + radius * Math.sin( nextAngle ) });
            } 
        }
        return p;
    }
    
    // Create Arc Points
    public static inline function arc_internal( dx: Float, dy: Float
                                     , radius: Float, start: Float, dA: Float, sides: Int ):Array<Point>{
        var p: Array<Point> = new Array<Point>();         
        var angle: Float = 0;
        var angleInc: Float = ( Math.PI*2 )/sides;
        var sides = Math.round( sides );
        var nextAngle: Float;
        if( dA < 0 ){
            var i = -1;
            while( true ){
                angle = i*angleInc;
                i--;
                nextAngle = angle + start; 
                if( angle <= ( dA ) ) break; //dA
                p.push( { x: dx + radius * Math.cos( nextAngle ), y: dy + radius * Math.sin( nextAngle ) });
            } 
        } else {
            var i = -1;
            while( true ){
                angle = i*angleInc;
                i++;
                nextAngle = angle + start; 
                if( angle >=  ( dA + angleInc ) ) break; 
                p.push( { x: dx + radius * Math.cos( nextAngle ), y: dy + radius * Math.sin( nextAngle ) });
            } 
            p.reverse();
        }
        return p;
    }
    
    
    
    // Create Arc Points
    public static inline function arc( dx: Float, dy: Float
                                     , radius: Float, start: Float, dA: Float, sides: Int ):Array<Point>{
        var p: Array<Point> = new Array<Point>();         
        var angle: Float = 0;
        var angleInc: Float = ( Math.PI*2 )/sides;
        var sides = Math.round( sides );
        var nextAngle: Float;
        if( dA < 0 ){
            var i = -1;
            while( true ){
                angle = i*angleInc;
                i--;
                nextAngle = angle + start; 
                if( angle <= ( dA ) ) break; //dA
                p.push( { x: dx + radius * Math.cos( nextAngle ), y: dy + radius * Math.sin( nextAngle ) });
            } 
        } else {
            var i = -1;
            while( true ){
                angle = i*angleInc;
                i++;
                nextAngle = angle + start; 
                if( angle >=  ( dA + angleInc ) ) break; 
                p.push( { x: dx + radius * Math.cos( nextAngle ), y: dy + radius * Math.sin( nextAngle ) });
            } 
            
        }
        p.reverse();
        return p;
    }
    public static var quadStep: Float = 0.03;
    // Create Quadratic Curve
    public static inline function quadCurve( p0, p1, p2 ): Array<Point> {
        var p: Array<Point> = new Array<Point>(); 
        var approxDistance = distance( p0, p1 ) + distance( p1, p2 );
        var v: { x: Float, y: Float };
        if( approxDistance == 0 ) approxDistance = 0.000001;
        var step = Math.min( 1/( approxDistance*0.707 ), quadStep );
        var arr = [ p0, p1, p2 ];
        var t = 0.0;
        /*
        v = Bezier.quadratic( 0.0, arr );
        p.push( { x: v.x, y: v.y } );*/
        p.push( p0 );
        t += step;
        while( t < 1 ){
            v = Bezier.quadratic( t, arr );
            p.push( { x: v.x, y: v.y } );
            t += step;
        }
        /*
        v = Bezier.quadratic( 1.0, arr );
        p.push( { x: v.x, y: v.y } );
        */
        p.push( p2 );
        return p;
    }
    public static var cubicStep: Float = 0.03;
    // Create Cubic Curve
    public static inline function cubicCurve( p0, p1, p2, p3 ): Array<Point> {
        var p: Array<Point> = new Array<Point>(); 
        var approxDistance = distance( p0, p1 ) + distance( p1, p2 ) + distance( p2, p3 );
        var v: { x: Float, y: Float };
        if( approxDistance == 0 ) approxDistance = 0.000001;
        var step = Math.min( 1/( approxDistance*0.707 ), cubicStep );
        var arr = [ p0, p1, p2, p3 ];
        var t = 0.0;
        v = Bezier.cubic( 0.0, arr );
        p.push( { x: v.x, y: v.y } );
        t += step;
        while( t < 1 ){
            v = Bezier.cubic( t, arr );
            p.push( { x: v.x, y: v.y } );
            t += step;
        }
        v = Bezier.cubic( 1.0, arr );
        p.push( { x: v.x, y: v.y } );
        return p;
    }
    public static inline function distance(     p0: { x: Float, y: Float }
                                            ,   p1: { x: Float, y: Float }
                                            ): Float {
        var x = p0.x - p1.x;
        var y = p0.y - p1.y;
        return Math.sqrt( x*x + y*y );
    }
    public inline static function quadraticBezier(  t: Float
                                                ,   arr: Array<{ x: Float, y: Float }>
                                                ): { x: Float,y: Float } {
                                                    return {  x: _quadraticBezier( t, arr[ 0 ].x, arr[ 1 ].x, arr[ 2 ].x )
                                                            , y: _quadraticBezier( t, arr[ 0 ].y, arr[ 1 ].y, arr[ 2 ].y ) };
    }
    private inline static function _quadraticBezier ( t: Float
                                                    , startPoint: Float
                                                    , controlPoint: Float
                                                    , endPoint: Float
                                                    ): Float {
        var u = 1 - t;
        return Math.pow( u, 2 ) * startPoint + 2 * u * t * controlPoint + Math.pow( t, 2 ) * endPoint;
    }
}
