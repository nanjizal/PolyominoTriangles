package justTriangles;
import justTriangles.Point;
import justTriangles.Triangle;
class SevenSeg{
    public var width:  Float = 0.10;
    public var height: Float = 0.18;
    public var unit: Float   = 0.01;
    public var colorID: Int  = 0;
    public var id: Int;
    public var outline: Bool = true;
    public var x: Float;
    public var y: Float;
    public var gap: Float;
    public var spacing: Float;
    public var triangles: Array<Triangle>;
    // example use, for simple LED type number display.
    // var sevenSeg = new justTriangles.SevenSeg( 1, 1, 0.050, 0.080 );
    // sevenSeg.addDigit( 0, 0, 0 );
    // sevenSeg.addNumber( 123456780, 0, 0 );
    // sevenSeg.addString( '0123456789', -0.5, -0.5 );
    //
    public function new( id_: Int, colorID_: Int
                        ,  width_: Float, height_: Float ){
        id = id_;
        colorID = colorID_;
        height = height_;
        width  = width_;
        unit = width_ * (1/10);
        gap = unit/5;
        spacing = width + unit*1.5;
        triangles = new Array<Triangle>();
    } 
    
    public inline function numberWidth( val: Int ): Float {
        var str = Std.string( val );
        return stringWidth( str );
    }
    public inline function stringWidth( str: String ): Float {
        var l = str.length;
        var space = 0.;
        for( i in 0...l ){
            space += spacing;
        }
        return space;
    }
    public inline function addNumber( val: Int, x_: Float, y_: Float, ?centre: Bool = false ){
        var str = Std.string( val );
        addString( str, x_, y_, centre );
    }
    public inline function addString( str: String, x_: Float, y_: Float, ?centre: Bool = false ){
        var l = str.length;
        var space = 0.;
        if( centre ){
            for( i in 0...l ){
                space += spacing;
            }
            space -= unit*1.5;// centreX makes assumption for simplicity see spacing in constructor.
            space = -space/2;
            y_ = y_ - height/2;
        }
        for( i in 0...l ){
            addDigit( Std.parseInt( str.substr( i, 1 ) ), x_ + space, y_ );
            space += spacing;
        }
    }
    
    public inline function addDigit( hexCode: Int, x_: Float, y_: Float ){
        x = x_;
        y = y_;
        switch( hexCode ){
            case 0:
                a();
                b();
                c();
                d();
                e();
                f();
            case 1:
                b();
                c();
            case 2:
                a();
                b();
                g();
                e();
                d();
            case 3:
                a();
                b();
                g();
                c();
                d();
            case 4:
                f();
                g();
                b();
                c();
            case 5:
                a();
                f();
                g();
                c();
                d();
            case 6:
                a();
                f();
                g();
                c();
                d();
                e();
            case 7:
                a();
                b();
                c();
            case 8:
                a();
                b();
                c();
                d();
                e();
                f();
                g();
            case 9: 
                g();
                f();
                a();
                b();
                c();
            case 10: // A
                e();
                f();
                a();
                b();
                c();
                g();
            case 11: // b
                f();
                g();
                c();
                d();
                e();
            case 12: // C
                a();
                f();
                e();
                d();
            case 13: // d
                b();
                g();
                e();
                d();
                c();
            case 14: // E
                a();
                f();
                g();
                e();
                d();
            case 15: // F
                a();
                f();
                g();
                e();
        }
    }
    
    inline function a(){
        horiSeg( x, y );
    }
    inline function b(){
        vertSeg( x + width - 2*unit, y );
    }
    inline function c(){
        var hi = height/2;
        vertSeg( x + width - 2*unit, y + hi - unit );
    }
    inline function d(){
        horiSeg( x, y + height - 2*unit );
    }
    inline function e(){
        var hi = height/2;
        vertSeg( x, y + hi - unit );
    }
    inline function f(){
        vertSeg( x, y );
    }
    inline function g(){
        var hi = height/2;
        horiSeg( x, y + hi - unit );
    }
    inline function dp(){
        // not implemented
    }
    inline function horiSeg( x_, y_ ){
        var tri = triangles;
        var l = tri.length;
        tri[ l ] = new Triangle( id
                        , outline
                        , { x: x_ + unit + gap, y: y_ + unit }
                        , { x: x_ + 2*unit, y: y_ }
                        , { x: x_ + width - unit - gap, y: y_ + unit }
                        , 0
                        , colorID );
        l++;
        tri[ l ] = new Triangle( id
                        , outline
                        , { x: x_ + 2*unit, y: y_ }
                        , { x: x_ + width - 2*unit, y: y_ }
                        , { x: x_ + width - unit - gap, y: y_ + unit }
                        , 0
                        , colorID );
        l++;
        tri[ l ] = new Triangle( id
                        , outline
                        , { x: x_ + unit + gap, y: y_ + unit }
                        , { x: x_ + width - unit - gap, y: y_  + unit }
                        , { x: x_ + width - 2*unit, y: y_ + 2*unit }
                        , 0
                        , colorID );
        l++;
        tri[ l ] = new Triangle( id
                        , outline
                        , { x: x_ + unit + gap, y: y_ + unit }
                        , { x: x_ + width - 2*unit, y: y_  + 2*unit }
                        , { x: x_ + 2*unit, y: y_ + 2*unit }
                        , 0
                        , colorID );
    }
    inline function vertSeg( x_, y_ ){
        var tri = triangles;
        var l = tri.length;
        var hi = height/2;
        tri[ l ] = new Triangle( id
                        , outline
                        , { x: x_, y: y_ + 2*unit }
                        , { x: x_ + unit, y: y_ + hi - gap }
                        , { x: x_, y: y_ + hi - unit + gap }
                        , 0
                        , colorID );
        l++;
        tri[ l ] = new Triangle( id
                        , outline
                        , { x: x_, y: y_ + 2*unit }
                        , { x: x_ + unit, y: y_ + unit + gap }
                        , { x: x_ + unit, y: y_ + hi - gap }
                        , 0
                        , colorID );
        l++;
        tri[ l ] = new Triangle( id
                        , outline
                        , { x: x_ + unit, y: y_ + unit + gap }
                        , { x: x_ + 2*unit, y: y_  + hi - unit }
                        , { x: x_ + unit, y: y_ + hi - gap }
                        , 0
                        , colorID );
        l++;
        tri[ l ] = new Triangle( id
                        , outline
                        , { x: x_ + unit, y: y_ + unit + gap }
                        , { x: x_ + 2*unit, y: y_  + 2*unit }
                        , { x: x_ + 2*unit, y: y_ + hi - unit }
                        , 0
                        , colorID );
    }
    public inline function render(){
        var tri = triangles;
        var l = tri.length;
        var l2 = Triangle.triangles.length;
        for( i in 0...l ) Triangle.triangles[l2+i] = tri[i];
    }
    public inline function clear(){
        /*var tri = triangles;
        var l = tri.length;
        for( i in 0...l ) triangles[i] = null;*/
        triangles = new Array<Triangle>();
    }
}
