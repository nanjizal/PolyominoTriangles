package polyominoTriangles.game;
import nodule.StringCodeIterator;
// Consider alternative data structure?
// Slightly not ideal that order is y, x but this was so that can loop a row faster
//
//   checkerDrawString( g, 30, 10, droidSans, 20, '   ', 0xFF00FFFF, 0xFFFFFF00 );
// Kha to screen imports
#if kha
import kha.graphics2.Graphics;
import kha.Font;
import kha.Color;
#end 

// need to consider adding constraint like this
/*
typedef Cloneable<T> = {
  function clone(): T;
}
*/
@:forward
abstract Array2D<T>(Array<Array<Null<T>>>) from Array<Array<Null<T>>> to Array<Array<Null<T>>> {
    inline public 
    function new<T>( ?w: Int = 100, ?h: Int = 100, ?v: Array<Array<T>> ) {
        // init Matrix2D
        if( v == null ) {
            if( w == null ) w = 100;
            if( h == null ) h = 100;
            v = getEmpty( w, h );
        }
        this = v;
    }
    inline static 
    function getEmpty( w, h ){
        return new Array2D( w, h, [for( y in 0...h )[ for( x in 0...w ) null ]] );
    }
    public inline
    function clear<T>(){
        var ly = this.length;
        var lx = this[0].length;
        this = new Array2D<T>( lx, ly );
    }
    // work out constraints later... as cast not ideal :(
    /*
    public inline
    function clone(){
        return [for( y in 0...this.length ) [ for( x in 0...this[ y ].length ) {
            var t = cast this[ y ][ x ]; // dangerous
            return ( t != null )? t.clone(): null; 
            }
            ]];
    }
    */
    public inline
    function addElement( t: T, x: Int, y: Int ){
        if( this == null ) return;
        this[ y ][ x ] = t;
    }
    public inline
    function isEmpty( x: Int, y: Int ){
        return ( this[ y ][ x ] ==0 );
    }
    public inline
    function rowFull( y: Int ){
        var full = true;
        var row = this[ y ];
        var l = row.length;
        for( x in 0...l ){
            if( row[ x ] == null ) {
                full = false;
                break;
            }
        }
        return full;
    }
    public inline
    function rowEmpty( y: Int ){
        var empty = true;
        var row = this[y];
        var l = row.length;
        for( x in 0...l ){
            if( row[ x ] != null ) {
                empty = false;
                break;
            }
        }
        return empty;
    }
    // Used to check if the matrix clash
    public static inline
    function clashTest<T>( s: Array2D<T>, t: Array2D<T> ){
        var clash = false;
        var ls = s.length;
        var lt = t.length;
        if( ls != lt ) throw "Can't clash test matrix are not same size";
        var rowS: Array<T>;
        var rowT: Array<T>;
        for( y in 0...ls ){
            rowS = s[ y ];
            rowT = t[ y ];
            var lrs = rowS.length;
            var lrt = rowT.length;
            if( lrs != lrt ) throw "Can't clash test matrix are not same size - failed on row " + y;
            for( x in 0...lrs ){
                if( rowS[ x ] != null && rowT[ x ] != null ){
                    clash = true;
                    break;
                    break;
                }
            }
        }
        return clash;
    }
    /*public static inline
    function move( from: x:Int,y:Int}, to: {x:Int,y:Int} ){
    }*/
    public inline
    function moveLocations( locations: Array<{x:Int,y:Int}>, dx, dy ):Bool {
        var lp = locations.length;
        if( dx == dy ) return false;
        var loc: { x: Int, y: Int };
        for( i in 0...lp ){
            loc = locations[ i ];
            var x = loc.x;
            var y = loc.y;
            this[ y + dy][ x + dx ] = this[ y ][ x ];
            this[ y ][ x ] = null;
        }
        return true;
    }
    public inline
    function checkerString<T>(): String {
        var blackSquare = '■';
        var whiteSquare = '□';
        var nextLine = '\n';
        var gridStr = nextLine;
        var l = this.length;
        var w: Int;
        var row: Array<T>;
        for( y in 0...l ){
            row = this[y];
            w = row.length;
            for( x in 0...w ){
                if( row[x] == null ){
                    gridStr = gridStr + whiteSquare;
                } else {
                    gridStr = gridStr + blackSquare;
                }
            }
            gridStr = gridStr + nextLine;
        }
        return gridStr;
    }
    #if kha
    // for kha debug on screen
    public inline
    function checkerDrawString<T>( g: kha.graphics2.Graphics
                                 , x:    Float, y: Float
                                 , font: kha.Font
                                 , size: Int
                                 , spacing: String
                                 , colorWhite: kha.Color
                                 , colorBlack: kha.Color
                                 ){
        //if( this == null ) return;
        var dx: Float = x;
        var dy: Float = y;
        // unfortunately black and white squares are not supported? That took a while to realize!!
        var blackSquare = 'X';
        var whiteSquare = '0';
        var nextLine = '\n';
        var gridStr = nextLine;
        var l = this.length;
        var w: Int;
        var row: Array<T>;
        for( y in 0...l ){
            row = this[y];
            w = row.length;
            for( x in 0...w ){
                if( row[x] == null ){
                    gridStr = gridStr + whiteSquare + spacing;
                } else {
                    gridStr = gridStr + blackSquare + spacing;
                }
            }
            gridStr = gridStr + nextLine;
        }
        var str = gridStr;
        g.font = font;
        g.fontSize = size;
        g.color = colorWhite;
        var strHi =  g.font.height( size );
        var strIter = new nodule.StringCodeIterator( str );
        strIter.next();
        strIter.addChar();
        str = strIter.toStr();
        while( strIter.hasNext() ){
            switch( strIter.c ){
                case 'X'.code:// not ideal to hard code X here :(
                    g.color = colorBlack;
                    str = strIter.toStr();
                    g.drawString( str, dx, dy );
                    dx += g.font.width( size, str );
                    strIter.resetBuffer();
                    strIter.next();
                case '0'.code:
                    g.color = colorWhite;
                    str = strIter.toStr();
                    g.drawString( str, dx, dy );
                    dx += g.font.width( size, str );
                    strIter.resetBuffer();
                    strIter.next();
                case '\r'.code | '\n'.code:
                    if( str != '' ){
                        g.drawString( str, dx, dy );
                        dx += g.font.width( size, str );
                    }
                    strIter.resetBuffer();
                    strIter.next();
                    dy = dy + strHi;
                    dx = x;
                default:
                    strIter.next();
                    strIter.addChar();
                    str = strIter.toStr();
            }
        }
        str = strIter.toStr();
        g.drawString( str, dx, dy );
        
    }
    #end
}