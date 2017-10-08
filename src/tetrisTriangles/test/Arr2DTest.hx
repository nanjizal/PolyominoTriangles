package tetrisTriangles.test;
import tetrisTriangles.game.Arr2D;
class Arr2DTest extends haxe.unit.TestCase {
	var filledArr2D: 	Arr2D;
	var emptyArr2D: 	Arr2D;
	public static function UnitTest(){
		var r = new haxe.unit.TestRunner();
		trace( 'Running unit test');
		r.add( new Arr2DTest() );
		r.run();
		trace( r );
	}
    public function testClear(){
		filledArr2D.clear();
		assertTrue( filledArr2D.toString() == emptyArr2D.toString() );
	}
	public function testFill(){
		emptyArr2D.fill();
		assertTrue( filledArr2D.toString() == emptyArr2D.toString() );
	}
    public function testAddOne(){ 
		emptyArr2D.addOne( 0, 0 );
		assertTrue( emptyArr2D.isOne( 0, 0 ) );
		assertFalse( emptyArr2D.isOne( 0, 1 ) );
    }
    public function testAddZero(){
		filledArr2D.addZero( 0, 0 );
		assertTrue( filledArr2D.isZero( 0, 0 ) );
		assertFalse( filledArr2D.isZero( 0, 1 ) );
    }
	public function testIsZero(){
		for( iy in 0...3 ){
            for( ix in 0...3 ){
				assertTrue( emptyArr2D.isZero( ix, iy ) );
				assertFalse( filledArr2D.isZero( ix, iy ) );
			}
		}
	}
	public function testIsOne(){
		for( iy in 0...3 ){
            for( ix in 0...3 ){
				assertFalse( emptyArr2D.isOne( ix, iy ) );
				assertTrue( filledArr2D.isOne( ix, iy ) );
			}
		}
	}
	public function testLength(){
		assertTrue( filledArr2D.length == 3 * 3 + 2 );
	}
	public function testRowFull(){
		for( iy in 0...3 ){
			emptyArr2D.addOne( 0, iy );
			emptyArr2D.addOne( 1, iy );
			emptyArr2D.addOne( 2, iy );
			assertTrue( emptyArr2D.rowFull( iy ) );
			setup();
		}
		for( iy in 0...3 ){
			filledArr2D.addZero( 0, iy );
			filledArr2D.addZero( 1, iy );
			filledArr2D.addZero( 2, iy );
			assertFalse( filledArr2D.rowFull( iy ) );
			setup();
		}
	}
	public function testClash(){
		emptyArr2D.addOne( 0, 0 );
		emptyArr2D.addOne( 0, 1 );
		emptyArr2D.addOne( 0, 2 );
		var a2 = [ { x: 1, y: 0 }, { x: 1, y: 1 }, { x: 1, y: 2 } ];
		assertFalse( emptyArr2D.clash( a2 ) );
		emptyArr2D.addOne( 0, 0 );
		emptyArr2D.addOne( 0, 1 );
		emptyArr2D.addOne( 0, 2 );
		var a2 = [ { x: 0, y: 0 }, { x: 0, y: 1 }, { x: 0, y: 2 } ];
		assertTrue( emptyArr2D.clash( a2 ) );
	}
	public function testAddPoints(){
		var a2 = [ { x: 0, y: 1 }, { x: 1, y: 1 }, { x: 2, y: 1 } ];
		emptyArr2D.addPoints( a2 );
		assertFalse( emptyArr2D.rowFull( 0 ) );
		assertTrue(  emptyArr2D.rowFull( 1 ) );
		assertFalse( emptyArr2D.rowFull( 2 ) );
	}
	public function testOverlap(){
       assertFalse( Arr2D.overlap( filledArr2D, emptyArr2D ) );
    }
	public function testID(){
		var str = '4,3,0,0,0,0,1,0,0,0,1,0,0,0';
		var a0 = new Arr2D( 4, 3 );
		a0.addOne( 0, 2 );
		a0.addOne( 0, 1 );
		assertTrue( a0.toString() == str );
		var count = 2;
		var w = 3;
		var h = 4;
        for( y in 0...h ){
            for( x in 0...w ){// x
                assertTrue( Arr2D.id( x, y, w, h ) == count );
                count++;
            }
        }
	}
	public function testMerge( b: Arr2D ){
		emptyArr2D.addOne( 0, 1 );
		emptyArr2D.addOne( 1, 1 );
		emptyArr2D.addOne( 2, 1 );
		assertTrue( emptyArr2D.rowFull( 1 ) );
		var a0 = new Arr2D( 3, 3 );
		a0.addOne( 0, 2 );
		a0.addOne( 1, 2 );
		a0.addOne( 2, 2 );
		assertTrue( a0.rowFull( 2 ) );
		assertFalse( Arr2D.overlap( emptyArr2D, a0 ) );
		assertTrue( emptyArr2D.merge( a0 ) );
		assertFalse( emptyArr2D.rowFull( 0 ) );
		assertTrue(  emptyArr2D.rowFull( 1 ) );
		assertTrue(  emptyArr2D.rowFull( 2 ) );
	}
	public function testRowToString(){
		var str = '\n1  0  0  ';
		emptyArr2D.addOne( 0, 0 );
		assertTrue( emptyArr2D.rowToString(0) == str );
	}
	public function testPrettyString(){
		var str = 	'\n1  0  0  ' 
				+ 	'\n0  0  0  '
				+   '\n0  0  0  ';
		emptyArr2D.addOne( 0, 0 );
		assertTrue( emptyArr2D.prettyString() == str );
	}
  	override public function setup() {
    	createfilledArr2D();
		emptyArr2D = new Arr2D( 3, 3 );
  	}
	function createfilledArr2D(){
		filledArr2D = new Arr2D( 3, 3 );
		var i = 0;
        for( iy in 0...3 ){
            for( ix in 0...3 ){
                filledArr2D.addOne( ix, iy );
            }    
        }
	}
}