package tetrisTriangles.game;
// Rook Angle as in the castle in chess
abstract RookAngle( Float ) to Float {
    public inline function new( angle: Float ){
        this = if( angle < 0 ){
            negativeRook0_2pi( limit0_2pi( -angle ) );
        } else {
            rook0_2pi( limit0_2pi( angle ) );
        }
    }
    @:from
    static public function fromFloat(f:Float) {
        return new RookAngle( f );
    }
    @:from
    static public function fromInt(i:Int) {
        return new RookAngle( i*1. );
    }
    public inline static function limit0_2pi( angle: Float ): Float {
        return angle%(2*Math.PI);
    }
    // work out if the angle is closest to 0, 90, 180, 270
    public inline static function rook0_2pi( angle: Float ): Float {
        return switch angle {
            case 0.:
                0.;
          // 0 -> 45 degrees
          // output 0 
          case v if ( v < (Math.PI/4) ): 
                0.;
          // 45 -> 90+45 degrees
          case v if ( v < (Math.PI/2 + Math.PI/4) ): 
              // 90 degrees
              Math.PI/2;
          // 90+45 -> 180+45 degrees
          case v if ( v < (Math.PI + Math.PI/4) ): 
              // 180 degrees
              Math.PI;
          // 180+45 -> 270+45
          case v if ( v < Math.PI + Math.PI/2 + Math.PI/4 ):
              // 270 degrees
              ( Math.PI + Math.PI/2 );
          case _:
              0.;
        }
    }
    // work out if the angle is closest to 0, 90, 180, 270
    public inline static function negativeRook0_2pi( angle: Float ): Float {
        return switch angle {
            case 0.:
                0.;
          // 0 -> 45 degrees
          // output 0 
          case v if ( v < (Math.PI/4) ): 
                0.;
          // 45 -> 90+45 degrees
          case v if ( v < (Math.PI/2 + Math.PI/4) ): 
              // 270 degrees
              ( Math.PI + Math.PI/2 );
          // 90+45 -> 180+45 degrees
          case v if ( v < (Math.PI + Math.PI/4) ): 
              // 180 degrees
              Math.PI;
          // 180+45 -> 270+45
          case v if ( v < Math.PI + Math.PI/2 + Math.PI/4 ):
              // 90 degrees
              Math.PI/2;
          case _:
              0.;
        }
    }
    
    public inline function compassString(): String {
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
    public inline function radiusString(): String {
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
    public inline function degrees(): Float {
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
    public inline function clockRotate(): RookAngle {
        this = new RookAngle( this + 90 );
        return this;
    }
    public inline function antiClockRotate(): RookAngle {
        this = new RookAngle( this - 90 );
        return this;
    }
    public inline function upsideDown(): RookAngle {
        return new RookAngle( this + 180 );
    }
    @:op(A++) public function pp(): RookAngle {
         return clockRotate();
    }
    @:op(A--) public function mm(): RookAngle {
         return antiClockRotate();
    }
    
}