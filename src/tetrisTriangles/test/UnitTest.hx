package tetrisTriangles.test;
import tetrisTriangles.game.Arr2D;
class UnitTest {
	public function new(){
		//
	}
// Test Arr2D unit tests not setup yet! Just put here for later.. ?
    function testArr2D(){
        var a0 = new Arr2D(3,3);
        var i = 0;
        for( iy in 0...3 ){
            for( ix in 0...3 ){
                a0.addOne( ix, iy );
            }    
        }
        var a1 = new Arr2D( 3, 3 );
        trace( Arr2D.overlap( a0, a1 ) );
    }
}