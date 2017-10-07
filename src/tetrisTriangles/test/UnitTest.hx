package tetrisTriangles.test;
import tetrisTriangles.test.Arr2DTest;
class UnitTest {
	public function new(){
		var r = new haxe.unit.TestRunner();
		trace( 'Running unit test');
		r.add( new Arr2DTest() );
		r.run();
		trace( r );
	}
}