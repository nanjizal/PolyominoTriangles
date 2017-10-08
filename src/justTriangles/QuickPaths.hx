package justTriangles;
import justTriangles.QuickPaths;
// Class to fill with useful PathContext drawings, mostly for testing.
class QuickPaths {
    public function new(){}
        
    // quadTo quadratic curve test
    public static inline function speechBubble( ctx:  PathContext
                                            ,   sX:   Float,   sY:   Float
                                            ,   offX: Float,   offY: Float ): Void {
        var x0 = sX*75 + offX;
        var y0 = sY*25 + offY;
        var x1 = sX*25 + offX;
        var y1 = sY*25 + offY;
        var x2 = sX*25 + offX;
        var y2 = sY*62.5 + offY;
        var x3 = sX*25 + offX;
        var y3 = sY*100 + offY;
        var x4 = sX*50 + offX;
        var y4 = sY*100 + offY;
        var x5 = sX*50 + offX;
        var y5 = sY*120 + offY;
        var x6 = sX*30 + offX;
        var y6 = sY*125 + offY;
        var x7 = sX*60 + offX;
        var y7 = sY*120 + offY;
        var x8 = sX*65 + offX;
        var y8 = sY*100 + offY;
        var x9 = sX*125 + offX;
        var y9 = sY*100 + offY;
        var x10 = sX*125 + offX;
        var y10 = sY*62.5 + offY;
        var x11 = sX*125 + offX;
        var y11 = sY*25 + offY;
        ctx.moveTo( x0, y0 );
        ctx.quadTo( x1, y1, x2, y2 );
        ctx.quadTo( x3, y3, x4, y4 );
        ctx.quadTo( x5, y5, x6, y6 );
        ctx.quadTo( x7, y7, x8, y8 );
        ctx.quadTo( x9, y9, x10, y10 );
        ctx.quadTo( x11, y11, x0, y0);
    }
    // curveTo cubic curve test
    public static inline function heart( ctx: PathContext
                                    ,    sX:   Float,   sY:   Float
                                    ,    offX: Float,   offY: Float ):Void {
        var x0 = sX*75 + offX;
        var y0 = sY*40 + offY;
        var x1 = sX*75 + offX;
        var y1 = sX*37 + offY;
        var x2 = sX*70 + offX;
        var y2 = sY*25 + offY;
        var x3 = sX*50 + offX; 
        var y3 = sY*25 + offY;
        var x4 = sX*20 + offX;
        var y4 = sY*25 + offY;
        var x5 = sX*20 + offX; 
        var y5 = sY*62.5 + offY;
        var x6 = sX*20 + offX;
        var y6 = sY*62.5 + offY;
        var x7 = sX*20 + offX; 
        var y7 = sY*80 + offY;
        var x8 = sX*40 + offX;
        var y8 = sY*102 + offY;
        var x9 = sX*75 + offX;
        var y9 = sY*120 + offY;
        var x10 = sX*110 + offX;
        var y10 = sY*102 + offY;
        var x11 = sX*130 + offX;
        var y11 = sY*80 + offY;
        var x12 = sX*130 + offX;
        var y12 = sY*62.5 + offY;
        var x13 = sX*130 + offX;
        var y13 = sY*62.5 + offY;
        var x14 = sX*130 + offX; 
        var y14 = sY*25 + offY;
        var x15 = sX*100 + offX;
        var y15 = sY*25 + offY;
        var x16 = sX*85 + offX;
        var y16 = sY*25 + offY;
        var x17 = sX*75 + offX;
        var y17 = sY*37 + offY;
        ctx.moveTo( x0, y0 );
        ctx.curveTo( x1, y1, x2, y2, x3, y3 );
        ctx.curveTo( x4, y4, x5, y5, x6, y6 );
        ctx.curveTo( x7, y7, x8, y8, x9, y9 );
        ctx.curveTo( x10, y10, x11, y11, x12, y12 );
        ctx.curveTo( x13, y13, x14, y14, x15, y15 );
        ctx.curveTo( x16, y16, x17, y17, x0, y0 );
    }
}
