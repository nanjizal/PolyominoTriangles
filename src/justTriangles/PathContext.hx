package justTriangles;
import justTriangles.Draw;
import justTriangles.Point;
import justTriangles.ShapePoints;
import justTriangles.PolyK;
enum LineType {
    TriangleJoinCurve; // arc- Default seems to work quite well, but WIP.
    TriangleJoinStraight; // straight 
    Poly;         // polygons
    Curves;       // curves
    Round;
    Isolated;
    Quad;
}
@:enum
abstract DrawDirection( Bool ){
    var clockwise = true;
    var counterClockwise = false;
}
@:enum
abstract PolySides( Int ) {
    var triangle        = 3;
    var quadrilateral   = 4;
    var square          = 4;
    var tetragon        = 4;
    var pentagon        = 5;
    var hexagon         = 6;
    var heptagon        = 7;
    var septagon        = 7;
    var octagon         = 8;
    var nonagon         = 9;
    var enneagon        = 9;
    var decagon         = 10;
    var hendecagon      = 11;
    var undecagon       = 11;
    var dodecagon       = 12;
    var triskaidecagon  = 13;
    var tetrakaidecagon = 14;
    var pentadecagon    = 15;
    var hexakaidecagon  = 16;
    var heptadecagon    = 17;
    var octakaidecagon  = 18;
    var enneadecagon    = 19;
    var icosagon        = 20;
    var triacontagon    = 30;
    var tetracontagon   = 40;
    var pentacontagon   = 50;
    var hexacontagon    = 60;
    var heptacontagon   = 70;
    var octacontagon    = 80;
    var enneacontagon   = 90;
    var hectagon        = 100;
    var chiliagon       = 1000;
    var myriagon        = 10000;
}
class PathContext implements IPathContext {
    public static var circleSides: PolySides = hexacontagon;
    public var fill: Bool = false;
    var dirty: Bool = true;
    var p0: Point;
    var pp: Array<Point>;
    var ppp: Array<Array<Point>>;
    var ppp_: Array<Array<Point>>;
    var thick: Float;
    var thicks: Array<Float>;
    var lineColors: Array<Int>;
    var fillColors: Array<Int>;
    var lineColor: Int;
    var fillColor: Int;
    var s: Float;
    var dw: Float;
    var tx: Float;
    var ty: Float;
    var minX: Float;
    var minY: Float;
    var maxX: Float;
    var maxY: Float;    
    public var id: Int;
    public var lineType: LineType = TriangleJoinCurve;
    public function new( id_: Int, width_: Float, ?tx_: Float = 0, ?ty_: Float = 0){
        id = id_;
        dw = width_/2;
        s = 1/width_;
        tx = tx_;
        ty = ty_;
        minX = 1;
        maxX = -1;
        minY = 1;
        maxY = -1;
        lineColors = new Array<Int>();
        fillColors = new Array<Int>();
        thicks = new Array<Float>();
        lineColor = Draw.colorId;
        fillColor = Draw.colorId;
        thick = Draw.thick;
        ppp = new Array<Array<Point>>();
        moveTo( dw, dw );
    }
    // only applies after next moveTo command
    public function setColor( lineColor_: Int, ?fillColor_: Int = -1 ): Void {
        if( fillColor_ != -1 ){
            fillColor = fillColor_;
        }
        lineColor = lineColor_;
    }
    public function setThickness( thick_: Float ): Float {
        thick = thick_;
        return thick;
    }
    public inline function pt( x: Float, y: Float ): Point {
        // default is between ±1
        var x0 = s*( x - dw + tx );
        var y0 = s*( y - dw + ty );
        if( x0 < minX ) minX = x0;
        if( x0 < minY ) minY = y0;
        if( x0 > maxX ) maxX = x0;
        if( y0 > maxY ) maxY = y0;
        return { x: x0, y: y0 }
    }
    public function withinBounds( x: Float, y: Float ){
        return ( x > minX && x < maxX && y > minY && y < maxY );
    }
    public function moveTo( x: Float, y: Float ): Void {
        dirty = true;
        p0 = pt( x, y );
        if( pp != null ) if( pp.length == 1 ) {
            ppp.pop(); // remove moveTo that don't have another drawing command after.
            lineColors.pop();
            fillColors.pop();
            thicks.pop();
        }
        pp = new Array();
        var pl = ppp.length;
        lineColors[ pl ] =  lineColor;
        fillColors[ pl ] = fillColor;
        thicks[ pl ] = thick;
        pp.push( p0 );
        ppp.push( pp );
        
        
    }
    function moveToPoint( p0: Point ): Void {
        dirty = true;
        if( pp != null ) if( pp.length == 1 ) {
            ppp.pop(); // remove moveTo that don't have another drawing command after.
            lineColors.pop();
            fillColors.pop();
            thicks.pop();
        }
        pp = new Array();
        var pl = ppp.length;
        lineColors[ ppp.length ] = lineColor;
        fillColors[ ppp.length ] = fillColor;
        thicks[ pl ] = thick;
        pp.push( p0 );
        ppp.push( pp );
        
    }
    public function lineTo( x: Float, y: Float ): Void {
        var p1: Point = pt( x, y );
        pp.push( p1 );
        p0 = p1;
    }
    public function quadTo( x1: Float, y1: Float, x2: Float, y2: Float ): Void {
        var p1: Point = pt( x1, y1 );
        var p2: Point = pt( x2, y2 );
        var pMore: Array<Point> = ShapePoints.quadCurve( p0, p1, p2 );
        var plen = pp.length;
        for( i in 1...( pMore.length ) ) pp[ plen++ ] = pMore[ i ];
        p0 = p2;
    }
    public function curveTo( x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float ): Void {
        var p1: Point = pt( x1, y1 );
        var p2: Point = pt( x2, y2 );
        var p3: Point = pt( x3, y3 );
        var pMore = ShapePoints.cubicCurve( p0, p1, p2, p3 );
        var plen = pp.length;
        for( i in 1...( pMore.length ) ) pp[ plen++ ] = pMore[ i ];
        p0 = p3;
    }
    public function rectangle( x: Float, y: Float, width: Float, height: Float ): Void {
        var p1: Point = pt( x, y );
        var pMore = ShapePoints.box( p1.x, p1.y, width*s, height*s );
        moveToPoint( pMore[0] );
        for( p in pMore  ) pp.push( p );
    }
    // working.
    public function arc_move( x: Float, y: Float, radius: Float, start: Float, dA: Float, ?direction: DrawDirection, ?sides: PolySides ):Void{
        if( direction == null ) direction = clockwise;
        if( sides == null ) sides = circleSides;
        var p1: Point = pt( x, y );
        if( direction == counterClockwise ) dA = -dA; //TODO: Check
        var pMore = ShapePoints.arcPoints( p1, radius*s, start, dA, cast sides );
        moveToPoint( pMore[0] );
        for( p in pMore  ) pp.push( p );
    }
    // working.
    public function arc( x: Float, y: Float, radius: Float, start: Float, dA: Float, ?direction: DrawDirection, ?sides: PolySides ):Void{
        if( direction == null ) direction = clockwise;
        if( sides == null ) sides = circleSides;
        var p1: Point = pt( x, y );
        if( direction == counterClockwise ) dA = -dA; //TODO: Check
        var pMore = ShapePoints.arcPoints( p1, radius*s, start, dA, cast sides );
        for( p in pMore  ) pp.push( p );
    }
    // TODO: issue with closing rounded rectangle and some polys with the last line - webgl specific?
    public function roundedRectangle( dx: Float, dy: Float, width: Float, height: Float, radius: Float ): Void {
        var pi = Math.PI;
        var pi_2 = Math.PI/2;
        var p_arc1x = dx + radius;  // TODO: excessive reduce temp var
        var p_arc1y = dy + radius;
        var p_arc2x = dx + width - radius;
        var p_arc2y = dy + radius;
        var p_arc3x = dx + width - radius;
        var p_arc3y = dy + height - radius;
        var p_arc4x = dx + radius;
        var p_arc4y = dy + height - radius;
        var p1x = dx + radius;
        var p1y = dy;
        var p2x = dx + width - radius;
        var p2y = dy;
        var p3x = dx + width;
        var p3y = dy + radius;
        var p4x = dx + width;
        var p4y = dy + height - radius;
        var p5x = dx + width - radius;
        var p5y = dy + height;
        var p6x = dx + radius;
        var p6y = dy + height;
        var p7x = dx;
        var p7y = dy + height - radius;
        var p8x = dx;
        var p8y = dy + radius;
        moveTo( p8x, p8y );
        arc_move( p_arc1x, p_arc1y, radius,    pi, pi_2, clockwise, hexacontagon );
        arc( p_arc2x, p_arc2y, radius, -pi_2, pi_2, clockwise, hexacontagon );
        arc( p_arc3x, p_arc3y, radius,     0, pi_2, clockwise, hexacontagon );
        arc( p_arc4x, p_arc4y, radius,  pi_2, pi_2,   clockwise, hexacontagon );
        lineTo( p8x, p8y );
    }
    // currently only use predefined sides to encourage use of PolySides names.
    public function regularPoly( sides: PolySides, x: Float, y: Float, radius: Float, ?rotation: Float = 0 ): Void {
        var p1: Point = pt( x, y );
        var pMore = ShapePoints.polyPoints( p1, radius*s, cast sides, rotation );
        moveToPoint( pMore[0] );
        for( p in pMore  ) pp.push( p );
    }
    public function fillTriangles(){
        //if( dirty ) reverseEntries();
        var p: Point;
        var l = ppp_.length;
        var j = 0;
        for( pp0 in ppp_ ){
            var poly = new Array();
            for( i in 0...pp0.length ){
                p = pp0[i];
                poly.push( p.x );
                poly.push( p.y );
            }
            Draw.colorId = fillColors[ j ]; 
            polyKFill( poly );
            j++;
        }
    } 
    
    public inline function polyKFill( poly: Array<Float> ){
        var tgs = PolyK.triangulate( poly ); 
        var triples = new ArrayTriple( tgs );
        var a: Point;
        var b: Point;
        var c: Point;
        var i: Int;
        for( tri in triples ){
            i = Std.int( tri.a*2 );
            a = { x: poly[ i ], y: poly[ i + 1 ] };
            i = Std.int( tri.b*2 );
            b = { x: poly[ i ], y: poly[ i + 1 ] };
            i = Std.int( tri.c*2 );
            c = { x: poly[ i ], y: poly[ i + 1 ] };
            var tgs = PolyK.triangulate( poly ); 
            var triples = new ArrayTriple( tgs );
            var a: Point;
            var b: Point;
            var c: Point;
            var i: Int;
            for( tri in triples ){
                i = Std.int( tri.a*2 );
                a = { x: poly[ i ], y: poly[ i + 1 ] };
                i = Std.int( tri.b*2 );
                b = { x: poly[ i ], y: poly[ i + 1 ] };
                i = Std.int( tri.c*2 );
                c = { x: poly[ i ], y: poly[ i + 1 ] };
                Draw.drawTri( id, false, a,b,c, Draw.colorId );
            }
        }
    }
    public function render( thick_: Float, ?outline: Bool = true ){
        // thick_ not used?
        //Draw.thick = thick;
        if( dirty ) reverseEntries();
        if( fill ) fillTriangles();
        var j = 0;
        var l = ppp_.length;
        for( pp0 in ppp_ ){
            switch( lineType ){
                // Currently best line drawing enum still under active development.
                case TriangleJoinCurve:
                    
                    var draw = new Draw();
                    Draw.colorId = lineColors[ j ];
                    Draw.thick = thicks[ j ];
                    for( i in 0...pp0.length ){
                       if( i%1 == 0 && i< pp0.length - 1) Draw.triangleJoin( id, draw, pp0[ i ], pp0[ i + 1 ], thick/800, true );
                    }
                case TriangleJoinStraight:
                    var draw = new Draw();
                    Draw.colorId = lineColors[ j ];
                    Draw.thick = thicks[ j ];
                    for( i in 0...pp0.length ){
                       if( i%1 == 0 && i< pp0.length - 1) Draw.triangleJoin( id, draw, pp0[ i ], pp0[ i + 1 ], thick/800, false );
                    }
                // Other alternates still keeping till have developed ideal solution.
                case Poly:
                    // fairly optimal but broken
                    Draw.colorId = lineColors[ j ];
                    Draw.poly( id, outline, pp0 );
                case Curves:
                    // Not quite working on round rectangle but working well otherwise
                    //Draw.isolatedSpecial( id, pp0[ 0 ], pp0[ 1 ], thick/800 );
                    Draw.colorId = lineColors[ j ];
                    for( i in 0...pp0.length ) {
                        if( i%1 == 0 && i< pp0.length - 2) Draw.quad( id, outline, pp0, i );
                    }
                case Round:
                    // Pretty perfect but over drawing
                    Draw.colorId = lineColors[ j ];
                    for( i in 0...pp0.length ){
                       if( i%1 == 0 && i< pp0.length - 2) Draw.isolatedLine( id, pp0[ i ], pp0[ i + 1 ], thick/800, true );
                    }
                case Isolated:
                    // similar to poly but more broken
                    Draw.colorId = lineColors[ j ];
                    for( i in 0...pp0.length ){
                       if( i%1 == 0 && i< pp0.length - 2) Draw.isolatedLine( id, pp0[ i ], pp0[ i + 1 ], thick/800, false );
                    }
                case Quad:
                    // very broken
                    Draw.colorId = lineColors[ j ];
                    for( i in 0...pp0.length ) {
                        if( i%1 == 0 && i< pp0.length - 2) Draw.quad( id, outline, pp0, i );
                    }
            }
            j++;
        }
    }
    inline function reverseEntries(){
        var p: Array<Point>;
        if( ppp_ == null ) ppp_ = new Array<Array<Point>>();
        var plen = ppp.length;
        var plen_ = ppp_.length;
        var pp0: Array<Point> = ppp[0];
        for( i in plen_...plen ){
            // only add ones new ones
            pp0 = ppp[ i ];
            p = pp0.copy(); // not sure why not allowed to do all this in one line?
            p.reverse();
            ppp_[ i ] = p;
        }
        dirty = false;
    }
    public function clear(){
        lineColors = new Array<Int>();
        fillColors = new Array<Int>();
        thicks = new Array<Float>();
        ppp = new Array<Array<Point>>();
        minX = 1;
        maxX = -1;
        minY = 1;
        maxY = -1;
        dirty = true;
        ppp_ = null;
        ppp = null;
        pp = null;
        p0 = null;
    }
}
