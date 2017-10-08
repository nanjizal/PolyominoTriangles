package tetrisTriangles.game;
import tetrisTriangles.game.Shape;
import justTriangles.Point;
// Tetris Shape factories ( if that's the right word ).
class Templates { // predefined tetris shapes relative to centre
	public var createTetris: Point -> Snapped -> Shape;
	public function new( createTetris_: Point -> Snapped -> Shape ){
		createTetris = createTetris_;
	}
    public inline 
    function S( p: Point ): Shape {
        var ts = createTetris( p, Snapped.Fix );
        ts.addBlock( -0.5, -1 );
        ts.addBlock( 0.5, 0 );
        ts.addBlock( 0.5, -1 );
        ts.addBlock( 1.5, 0 );
        return ts;
    }
    public inline 
    function l( p: Point ): Shape {
        var ts = createTetris( p, Snapped.Zero );
        ts.addBlock( -0.5, -2 );
        ts.addBlock( -0.5, -1 );
        ts.addBlock( -0.5, 0 );
        ts.addBlock( -0.5, 1 );
        return ts;
    }
    public inline 
    function box( p: Point ): Shape {
        var ts = createTetris( p, Snapped.Always );
        ts.addBlock( -1, -1 );
        ts.addBlock( 0, -1 );
        ts.addBlock( -1, 0 );
        ts.addBlock( 0, 0 );
        return ts;
    }
    public inline 
    function L( p: Point ): Shape {
        var ts = createTetris( p, Snapped.Ninety );
        ts.addBlock( -1, -1.5 );
        ts.addBlock( -1, -0.5 );
        ts.addBlock( -1, 0.5 );
        ts.addBlock( 0, 0.5 );
        return ts;
    }
    public inline 
    function t( p: Point ): Shape {
        var ts = createTetris( p, Snapped.Ninety );
        ts.addBlock( -1, -1.5 );
        ts.addBlock( -1, -0.5 );
        ts.addBlock( -1, 0.5 );
        ts.addBlock( 0, -0.5 );
        return ts;
    }
    public inline  /** bottom row of tetris**/
    function bottom( p: Point, wide: Int ): Shape {
        var ts = createTetris( p, Snapped.Always );
        for( w in 0...wide ) ts.addBlock( w, 0, false, true );
        return ts;
    }
}