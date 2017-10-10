package tetrisTriangles.game;
// second attempt at Array 2D but last one was bit slow, so switching to emulation of 2D array.
// will use first two positions to store w, h, and the other positions to store 0, 1 in other places.
// use the abstracts methods to set values don't set directly.
// might be a good class to unit test!
@:forward
abstract Arr2D(Array<Int>) from Array<Int> to Array<Int> {
    inline public 
    function new<T>( ?w: Int = 100, ?h: Int = 100, ?v: Array<Int> ) {
        // init
        if( v == null ) {
            if( w == null ) w = 100;
            if( h == null ) h = 100;
            v = getEmpty( w, h );
        }
        this = v;
    }
    inline static 
    function getEmpty( w, h ){
		var l = w * h + 2;
		var arr = [ for( e in 0...l ) 0 ];
		arr[ 0 ] = w;
		arr[ 1 ] = h;
        return new Arr2D( w, h, arr );
    }
    public inline
    function clear(){
		var w = this[ 0 ];
		var h = this[ 1 ];
        this = new Arr2D( w, h );
    }
	public inline
	function fill(){
		var i = 2;
		var l = this.length; 
		while( i < l ){
			this[ i ] = 1;
			i++;
		}
	}
	public inline
    function addOne( x: Int, y: Int ){ // use this to add entries.
		var w = this[ 0 ];
		var h = this[ 1 ];
        this[ id( x, y, w, h) ] = 1; 
    }
	public inline
    function addZero( x: Int, y: Int ){ // use this to add entries.
		var w = this[ 0 ];
		var h = this[ 1 ];
        this[ id( x, y, w, h) ] = 0; 
    }
	//public inline
	//function get_width(
	public inline static 
	function id( x: Int, y: Int, w: Int, h: Int ){
		return Std.int( 2 + ( w * y ) + x );
	}
	//   Thinking Test example
	//
	//   w = 3  h = 4    x = 0  y = 2   target 8
	//   0 0 0      2  3  4
	//   1 0 0      5  6  7
	//   1 0 0      8  9 10
	//   1 0 0     11 12 13
	//
	//
	public inline
	function getW(){
		return this[0];
	}
	public inline
	function getH(){
		return this[1];
	}
	public inline
	function isZero( x: Int, y: Int ){
		var w = this[ 0 ];
		var h = this[ 1 ];
		return this[ id( x, y, w, h ) ] == 0; 
	}
	public inline
	function isOne( x: Int, y: Int ): Bool {
		var w = this[ 0 ];
		var h = this[ 1 ];
		return this[ id( x, y, w, h ) ] == 1; 
	}
	public inline
	function rowFull( y: Int ): Bool {
		var w = this[ 0 ];
		var h = this[ 1 ];
		var s = id( 0, y, w, h );
		var e = s + w;
		//if( e < this.length ) return true;
		var ful = true;
		for( i in s...e ){
			if( this[ i ] == 0 ){
				ful = false;
				break;
			}
		}
		return ful;
	}
	public inline
	function rowEmpty( y: Int ): Bool {
		var w = this[ 0 ];
		var h = this[ 1 ];
		var s = id( 0, y, w, h );
		var e = s + w;
		//if( e < this.length ) return true;
		var emp = true;
		for( i in s...e ){
			if( this[ i ] == 1 ){
				emp = false;
				break;
			}
		}
		return emp;
	}
	public inline
	function rowToString( y: Int ): String{
		var w = this[ 0 ];
		var h = this[ 1 ];
		var s = id( 0, y, w, h );
		var e = s + w;
		//if( e < this.length ) return true;
		var str = '\n';
		for( i in s...e ){
			str = str + this[ i ] + '  ';
		}
		return str;
	}
	public inline 
	function clash( arrP: Array<{x: Int,y: Int }> , ?offX: Int = 0, ?offY: Int = 0 ): Bool {
		var lp = arrP.length;
		var p: { x: Int, y: Int };
		var clash = false;
		for( i in 0...lp ){
			p = arrP[ i ];
			if( isOne( p.x + offX, p.y + offY ) ) {
				clash = true;
				break;
			}
		}
		return clash;
	}
	public inline
	function addPoints( arrP: Array<{x: Int,y: Int }>, ?offX: Int = 0, ?offY: Int = 0 ){
		var lp = arrP.length;
		var p: { x: Int, y: Int };
		for( i in 0...lp ){
			p = arrP[ i ];
			//trace( 'adding ' + ( p.x + offX ) + '  ' + ( p.y + offY ) );
			addOne( p.x + offX, p.y + offY );
		}
	}
	public static inline
	function overlap( a: Arr2D, b: Arr2D ): Bool {
		var la = a.length;
		var lb = b.length;
		if( la != lb ) throw 'can t compare Arr2D';
		var overlapped = false;
		var ai: Int;
		var bi: Int;
		for( i in 2...la ){
			ai = a[i];
			bi = b[i];
			if( ai == 1 && bi == 1 ){
				// then they overlap
				overlapped = true;
				break;
			}
		}
		return overlapped;
	}
	// assumes all squares are to be 0 or 1, does not check!
	public inline
	function merge( b: Arr2D ){
		var a = this;
		return if( overlap( a, b ) ){
			false;
		} else {
			var la = a.length;
			var ai: Int;
			for( i in 2...la ){
				ai = a[ i ];
				if( ai == 0 ){
					this[ i ] = b[ i ];
				} 
			}
			true;
		}
	}
	public inline
	function prettyString(){
		var h = this[ 1 ];
		var str = '';
		for( y in 0...h ){
			str = str + rowToString( y );
		}
		return str;
	}
}