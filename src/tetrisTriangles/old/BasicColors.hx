package tetrisTriangles.target;
#if luxe
typedef Col = luxe.Color;
abstract BasicColors( Col ) from Col to Col {
    public static var Green(    default, never ): Col = fromInt( 0x00ff00 ); 
    public static var Blue(     default, never ): Col = fromInt( 0x0000ff );
    public static var Red(      default, never ): Col = fromInt( 0xff0000 );
    public static var Yellow(   default, never ): Col = fromInt( 0xFFFF00 );
    public static var White(    default, never ): Col = fromInt( 0xFFFFFF );
    public static var Grey(     default, never ): Col = fromInt( 0xcccccc );

    inline function new( col: Col ){
        this = col;
    }
    inline static public function fromInt( i: Int ){
        var bc: BasicColors = new Col().rgb( i );
        return bc;
    }
}
#elseif kha
typedef Col = kha.Color;
abstract BasicColors( Col ) from Col to Col {
    public static var Green(    default, never ): Col = fromInt( 0xFF00ff00 ); 
    public static var Blue(     default, never ): Col = fromInt( 0xFF0000ff );
    public static var Red(      default, never ): Col = fromInt( 0xFFff0000 );
    public static var Yellow(   default, never ): Col = fromInt( 0xFFFFFF00 );
    public static var White(    default, never ): Col = fromInt( 0xFFFFFFFF );
    public static var Grey(     default, never ): Col = fromInt( 0xFFcccccc );

    inline function new( col: Col ){
        this = col;
    }
    inline static public function fromInt( i: Int ){
        var bc: BasicColors = cast( i, Int );
        return bc;
    }
}
#end