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
		var h = this[ 1 ];
        this[ id( x, y, h) ] = 1; 
    }
	public inline
    function addZero( x: Int, y: Int ){ // use this to add entries.
		var h = this[ 1 ];
        this[ id( x, y, h) ] = 0; 
    }
	inline static function id( x: Int, y: Int, h: Int ){
		return Std.int( 2 + ( h * y ) + x );
	}
	public inline
	function isZero( x: Int, y: Int ){
		var h = this[ 1 ];
		return this[ id( x, y, h) ] == 0; 
	}
	public inline
	function isOne( x: Int, y: Int ){
		var h = this[ 1 ];
		return this[ id( x, y, h) ] == 1; 
	}
	public inline
	function rowFull( y: Int ){
		var w = this[0];
		var h = this[1];
		var s = id( 0, y, h );
		trace( 's'+ s );
		var e = s + w;
		trace( 'e' + e );
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
	function clash( arrP: Array<{x: Int,y: Int }> ){
		var lp = arrP.length;
		var p: { x: Int, y: Int };
		var clash = false;
		for( i in 0...lp ){
			p = arrP[ i ];
			if( isOne( p.x, p.y ) ) {
				clash = true;
				break;
			}
		}
		return clash;
	}
	public inline
	function addPoints( arrP: Array<{x: Int,y: Int }> ){
		var lp = arrP.length;
		var p: { x: Int, y: Int };
		for( i in 0...lp ){
			p = arrP[ i ];
			addOne( p.x, p.y );
		}
	}
	public static inline
	function overlap( a: Arr2D, b: Arr2D ){
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
}