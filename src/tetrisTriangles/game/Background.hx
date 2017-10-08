package tetrisTriangles.game;
import tetrisTriangles.game.Shape;
import tetrisTriangles.game.Square;
// used for creating and controlling background colored blocks.
class Background {
	var shape:  	Shape;
	var wide: 		Int;
	var hi: 		Int;
	var bgCol0: 	Int;
    var bgCol1: 	Int;
    var bgCol2: 	Int;
    var bgCol3: 	Int;
	var bgSquares: 	Array<Square>;
    public function new( 	shape_:	  Shape
                    	, 	wide_:     Int,   hi_:    Int
                        , 	col0_:    Int,    col1_:  Int
                        , 	col2_:    Int,    col3_:  Int ){
		shape  = shape_;
		wide   = wide_;
		hi	   = hi_; 
        bgCol0 = col0_;
        bgCol1 = col1_;
        bgCol2 = col2_;
        bgCol3 = col3_;
        bgSquares = new Array<Square>();
        var toggle = false;
        for( w in 0...wide ){
            if( toggle ) { // color rows bottomly differently - should say horizontally the joys of replace! :)
                shape_.col0     = col0_;
                shape_.col1     = col1_;
            } else {
                shape_.col0     = col2_;
                shape_.col1     = col3_;
            }
            toggle = !toggle;
            for( h in 0...hi ) {
                bgSquares[ Arr2D.id( w, h, wide, hi ) ] = shape_.addBlock( w, h, false );
            }
        }
    }
	public inline
    function drawTetris( shapePositions: Array< { x: Int, y: Int } >, offX: Int, offY: Int ){
        resetBgColor();
        var ls = shapePositions.length;
        var pos: { x: Int, y: Int };
        var indx = 0;
        var dx = 0;
        var dy = 0;
        for( i in 0...ls ){
            pos = shapePositions[ i ];
            dx = pos.x + offX ;
            dy = pos.y + offY;
            if( dx > 0 && dx < wide && dy > 0 && dy < hi ){
                indx = Arr2D.id( dx, dy, wide, hi  );
                bgSquares[ indx ].changeColor( 14, 14 );
            }
        }
    }
    public inline 
    function resetBgColor(){
        var col0_ = bgCol0;
        var col1_ = bgCol1;
        var col2_ = bgCol2;
        var col3_ = bgCol3;
        var c0;
        var c1;
        var toggle = false;
        var indx = 0;
        // reset background colors
        for( w in 0...wide ){
            if( toggle ) { // color rows bottomly differently - should say horizontally the joys of replace! :)
                c0     = col0_;
                c1     = col1_;
            } else {
                c0     = col2_;
                c1     = col3_;
            }
            toggle = !toggle;
            for( h in 0...hi ) {
                indx = Arr2D.id( w, h, wide, hi  );
                bgSquares[ indx ].changeColor( c0, c1 );
            }
        }
    }
	public function locations( arr: Array< { x: Int, y: Int } > ): Array< { x: Int, y: Int } > {
		return shape.getCentreInt( arr );
	}
}