package tetrisTriangles.game;
// Rook Angle as in the castle in chess
abstract RookAngle( Float ) to Float {
    public inline 
    function new( angle: Float ){
        this = if( angle < 0 ){
            negativeRook0_2pi( limit0_2pi( -angle ) );
        } else {
            rook0_2pi( limit0_2pi( angle ) );
        }
    }
    @:from
    static public 
    function fromFloat(f:Float) {
        return new RookAngle( f );
    }
    @:from
    static public 
    function fromInt(i:Int) {
        return new RookAngle( i*1. );
    }
    public inline static 
    function limit0_2pi( angle: Float ): Float {
        return angle % ( 2 * Math.PI );
    }
    public inline static 
    function rook0_2pi( angle: Float ): Float { 
        return switch angle {               // work out angle closest to 0, 90, 180, 270
            case 0.:
                0.;
          case v if ( v < (Math.PI/4) ):                        // 0 -> 45 degrees
                0.;                         // output 0 
          case v if ( v < (Math.PI/2 + Math.PI/4) ):            // 45 -> 90+45 degrees
              Math.PI/2;                    // 90 degrees
          case v if ( v < (Math.PI + Math.PI/4) ):              // 90+45 -> 180+45 degrees
              Math.PI;                      // 180 degrees
          case v if ( v < Math.PI + Math.PI/2 + Math.PI/4 ):    // 180+45 -> 270+45
              ( Math.PI + Math.PI/2 );      // 270 degrees
          case _:
              0.;
        }
    }
    public inline static 
    function negativeRook0_2pi( angle: Float ): Float {
        return switch angle {               // work out angle closest to 0, 90, 180, 270
            case 0.:
                0.;
          case v if ( v < (Math.PI/4) ):    // 0 -> 45 degrees
                0.;                         // output 0 
          case v if ( v < (Math.PI/2 + Math.PI/4) ):            // 45 -> 90+45 degrees
              ( Math.PI + Math.PI/2 );      // 270 degrees
          case v if ( v < (Math.PI + Math.PI/4) ):              // 90+45 -> 180+45 degrees
              Math.PI;                      // 180 degrees
          case v if ( v < Math.PI + Math.PI/2 + Math.PI/4 ):    // 180+45 -> 270+45
              Math.PI/2;                    // 90 degrees
          case _:
              0.;
        }
    }
    public inline 
    function compassString(): String {
        return switch( this ){
            case 0.:
                'North';
            case v if( v == Math.PI/2 ):
                'East';
            case v if( v == Math.PI ):
                'South';
            case v if( v ==Math.PI+Math.PI/2):
                'West';
            default:
                'angle not found '+ this;
        }
    }
    public inline 
    function radiusString(): String {
        return switch( this ){
            case 0.:
                '0';
            case v if( v == Math.PI/2 ):
                'pi/2';
            case v if( v == Math.PI ):
                'pi';
            case v if( v == Math.PI+Math.PI/2):
                '3/4 pi';
            default:
                'angle not found '+ this;
        }
    }
    public inline 
    function degrees(): Float {
        return switch( this ){
            case 0.:
                0.;
            case v if( v == Math.PI/2 ):
                90.;
            case v if( v == Math.PI ):
                180.;
            case v if( v == Math.PI + Math.PI/2 ):
                270.;
            default:
                0;
        }
    }
    public inline 
    function clockRotate(): RookAngle {
        return this = new RookAngle( this + 90 );
    }
    public inline 
    function antiClockRotate(): RookAngle {
        return this = new RookAngle( this - 90 );
    }
    public inline 
    function upsideDown(): RookAngle {
        return this = new RookAngle( this + 180 );
    }
    @:op(A++) public 
    function pp(): RookAngle {
         return clockRotate();
    }
    @:op(A--) public 
    function mm(): RookAngle {
         return antiClockRotate();
    }
}