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
    function Z( p: Point ): Shape {
        var ts = createTetris( p, Snapped.Fix );
        #if hideBlocks
        ts.addBlock( -0.5, -1, true, false );
        ts.addBlock( 0.5, 0, true, false );
        ts.addBlock( 0.5, -1, true, false );
        ts.addBlock( 1.5, 0, true, false );
        #else
        ts.addBlock( -0.5, -1 );
        ts.addBlock( 0.5, 0 );
        ts.addBlock( 0.5, -1 );
        ts.addBlock( 1.5, 0 );
        #end
        return ts;
    }
    #if fullTetris
    public inline 
    function S( p: Point ): Shape {
        var ts = createTetris( p, Snapped.Fix );
        #if hideBlocks
        ts.addBlock( 0.5, -1, true, false );
        ts.addBlock( -0.5, 0, true, false );
        ts.addBlock( -0.5, -1, true, false );
        ts.addBlock( -1.5, 0, true, false );
        #else
        ts.addBlock( 0.5, -1 );
        ts.addBlock( -0.5, 0 );
        ts.addBlock( -0.5, -1 );
        ts.addBlock( -1.5, 0 );
        #end
        return ts;
    }
    #end
    public inline 
    function l( p: Point ): Shape {
        var ts = createTetris( p, Snapped.Zero );
        #if hideBlocks
        ts.addBlock( -0.5, -2, true, false );
        ts.addBlock( -0.5, -1, true, false );
        ts.addBlock( -0.5, 0, true, false );
        ts.addBlock( -0.5, 1, true, false );
        #else
        ts.addBlock( -0.5, -2 );
        ts.addBlock( -0.5, -1 );
        ts.addBlock( -0.5, 0 );
        ts.addBlock( -0.5, 1 );
        #end
        return ts;
    }
    public inline 
    function box( p: Point ): Shape {
        var ts = createTetris( p, Snapped.Always );
        #if hideBlocks
        ts.addBlock( -1, -1, true, false );
        ts.addBlock( 0, -1, true, false );
        ts.addBlock( -1, 0, true, false );
        ts.addBlock( 0, 0, true, false );
        #else
        ts.addBlock( -1, -1 );
        ts.addBlock( 0, -1 );
        ts.addBlock( -1, 0 );
        ts.addBlock( 0, 0 );
        #end
        return ts;
    }
    public inline 
    function L( p: Point ): Shape {
        var ts = createTetris( p, Snapped.Ninety );
        #if hideBlocks
        ts.addBlock( -1, -1.5, true, false );
        ts.addBlock( -1, -0.5, true, false );
        ts.addBlock( -1, 0.5, true, false );
        ts.addBlock( 0, 0.5, true, false );
        #else
        ts.addBlock( -1, -1.5 );
        ts.addBlock( -1, -0.5 );
        ts.addBlock( -1, 0.5 );
        ts.addBlock( 0, 0.5 );
        #end
        return ts;
    }
    #if fullTetris
    public inline 
    function rL( p: Point ): Shape {
        var ts = createTetris( p, Snapped.Fix );
        #if hideBlocks
        ts.addBlock( 1, -1.5, true, false );
        ts.addBlock( 1, -0.5, true, false );
        ts.addBlock( 1, 0.5, true, false );
        ts.addBlock( 0, 0.5, true, false );
        #else
        ts.addBlock( 1, -1.5 );
        ts.addBlock( 1, -0.5 );
        ts.addBlock( 1, 0.5 );
        ts.addBlock( 0, 0.5 );
        #end
        return ts;
    }
    #end
    public inline 
    function t( p: Point ): Shape {
        var ts = createTetris( p, Snapped.Ninety );
        #if
        ts.addBlock( -1, -1.5, true, false );
        ts.addBlock( -1, -0.5, true, false );
        ts.addBlock( -1, 0.5, true, false );
        ts.addBlock( 0, -0.5, true, false );
        #else
        ts.addBlock( -1, -1.5 );
        ts.addBlock( -1, -0.5 );
        ts.addBlock( -1, 0.5 );
        ts.addBlock( 0, -0.5 );
        #end
        return ts;
    }
    public inline  /** bottom row of tetris**/
    function bottom( p: Point, wide: Int ): Shape {
        var ts = createTetris( p, Snapped.Always );
        #if hideBottom 
            for( w in 0...wide ) ts.addBlock( w, 0, true, false );
        #else   
            for( w in 0...wide ) ts.addBlock( w, 0, false, true );
        #end
        return ts;
    }
}