package justTriangles;
class Bezier {
    public inline static function quadratic(  t: Float
                                                ,   arr: Array<{ x: Float, y: Float }>
                                                ): { x: Float,y: Float } {
                                                    return {  x: _quadratic( t, arr[ 0 ].x, arr[ 1 ].x, arr[ 2 ].x )
                                                            , y: _quadratic( t, arr[ 0 ].y, arr[ 1 ].y, arr[ 2 ].y ) };
    }
    private inline static function _quadratic ( t: Float
                                                    , startPoint: Float
                                                    , controlPoint: Float
                                                    , endPoint: Float
                                                    ): Float {
        var u = 1 - t;
        return Math.pow( u, 2 ) * startPoint + 2 * u * t * controlPoint + Math.pow( t, 2 ) * endPoint;
    }
    public inline static function cubic(  t: Float
                                                ,   arr: Array<{ x: Float, y: Float }>
                                                ): { x: Float,y: Float } {
                                                    return {  x: _cubic( t, arr[ 0 ].x, arr[ 1 ].x, arr[ 2 ].x, arr[ 3 ].x )
                                                            , y: _cubic( t, arr[ 0 ].y, arr[ 1 ].y, arr[ 2 ].y, arr[ 3 ].y ) };
    }
    public inline static function _cubic( t:                Float
                                , startPoint:       Float
                                , controlPoint1:    Float
                                , controlPoint2:    Float
                                , endPoint:         Float 
                                ): Float {
        var u = 1 - t;
        return  Math.pow( u, 3 ) * startPoint + 3 * Math.pow( u, 2 ) * t * controlPoint1 +
                3* u * Math.pow( t, 2 ) * controlPoint2 + Math.pow( t, 3 ) * endPoint;
    }
}
