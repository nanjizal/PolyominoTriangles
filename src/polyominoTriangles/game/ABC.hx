package polyominoTriangles.game;
import polyominoTriangles.game.Shape;
import justTriangles.Point;
// Polyomino Alphabet factory ( if that's the right word ).
class ABC {
	public var createPolyomino: Point -> Snapped -> Shape;
	public function new( createPolyomino_: Point -> Snapped -> Shape ){
		createPolyomino = createPolyomino_;
    }
    // var count = 0;
    public function rnd( p: Point): Shape {
        var rangeABC = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        var indx = Math.round(Math.random()*(rangeABC.length-1));
        /*
        var indx = count++;
        if( indx > rangeABC.length ){
            count = 0;
            indx = 0;
        }
        */
        #if use_kha
            return createABC( 'KHA', p );
        #else
            return createABC( rangeABC.substr( indx, 1 ), p );
        #end
    }
    public function createABC( letter: String, p: Point ): Shape {
        var arr: Arr2D;
        return switch( letter ){
            case 'A':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,1,1,0
                                    ,1,0,0,1
                                    ,1,0,0,1
                                    ,1,1,1,1
                                    ,1,0,0,1
                                ]);
                abc( p, arr );
            case 'B':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,1,1,0
                                    ,1,0,0,1
                                    ,1,1,1,0
                                    ,1,0,0,1
                                    ,1,1,1,0
                                ]);
                abc( p, arr );
            case 'C':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,1,1,1
                                    ,1,0,0,0
                                    ,1,0,0,0
                                    ,1,0,0,0
                                    ,0,1,1,1
                                ]);
                abc( p, arr );
            case 'D':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,1,1,0
                                    ,1,0,0,1
                                    ,1,0,0,1
                                    ,1,0,0,1
                                    ,1,1,1,0
                                ]);
                abc( p, arr );
            case 'E':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,1,1,1
                                    ,1,0,0,0
                                    ,1,1,1,1
                                    ,1,0,0,0
                                    ,1,1,1,1
                                ]);
                abc( p, arr );
            case 'F':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,1,1,1
                                    ,1,0,0,0
                                    ,1,1,1,0
                                    ,1,0,0,0
                                    ,1,0,0,0
                                ]);
                abc( p, arr );
            case 'G':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,1,1,1
                                    ,1,0,0,0
                                    ,1,0,1,1
                                    ,1,0,0,1
                                    ,1,1,1,1
                                ]);
                abc( p, arr );
            case 'H':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,0,0,1
                                    ,1,0,0,1
                                    ,1,1,1,1
                                    ,1,0,0,1
                                    ,1,0,0,1
                                ]);
                abc( p, arr );
            case 'I':
                arr = new Arr2D( [   3,5 // array dimensions
                                    ,1,1,1
                                    ,0,1,0
                                    ,0,1,0
                                    ,0,1,0
                                    ,1,1,1
                                ]);
                abc( p, arr );
            case 'J':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,1,1,1
                                    ,0,0,1,0
                                    ,0,0,1,0
                                    ,1,0,1,0
                                    ,0,1,0,0
                                ]);
                abc( p, arr );
            case 'K':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,0,0,1
                                    ,1,0,1,0
                                    ,1,1,0,0
                                    ,1,0,1,0
                                    ,1,0,0,1
                                ]);
                abc( p, arr );
            case 'L':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,0,0,0
                                    ,1,0,0,0
                                    ,1,0,0,0
                                    ,1,0,0,0
                                    ,1,1,1,1
                                ]);
                abc( p, arr );
            case 'M':
                arr = new Arr2D( [   5,5 // array dimensions
                                    ,1,0,0,0,1
                                    ,1,1,0,1,1
                                    ,1,0,1,0,1
                                    ,1,0,0,0,1
                                    ,1,0,0,0,1
                                ]);
                abc( p, arr );
            case 'N':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,0,0,1
                                    ,1,1,0,1
                                    ,1,0,1,1
                                    ,1,0,0,1
                                    ,1,0,0,1
                                ]);
                abc( p, arr );
            case 'O':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,1,1,0
                                    ,1,0,0,1
                                    ,1,0,0,1
                                    ,1,0,0,1
                                    ,0,1,1,0
                                ]);
                abc( p, arr );
            case 'P':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,1,1,0
                                    ,1,0,0,1
                                    ,1,1,1,0
                                    ,1,0,0,0
                                    ,1,0,0,0
                                ]);
                abc( p, arr );
            case 'Q':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,1,1,0
                                    ,1,0,0,1
                                    ,1,0,0,1
                                    ,1,0,1,0
                                    ,0,1,0,1
                                ]);
                abc( p, arr );
            case 'R':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,1,1,0
                                    ,1,0,0,1
                                    ,1,1,1,0
                                    ,1,0,1,0
                                    ,1,0,0,1
                                ]);
                abc( p, arr );
            case 'S':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,1,1,1
                                    ,1,0,0,0
                                    ,0,1,1,0
                                    ,0,0,0,1
                                    ,1,1,1,0
                                ]);
                abc( p, arr );
            case 'T':
                arr = new Arr2D( [   5,5 // array dimensions
                                    ,1,1,1,1,1
                                    ,0,0,1,0,0
                                    ,0,0,1,0,0
                                    ,0,0,1,0,0
                                    ,0,0,1,0,0
                                ]);
                abc( p, arr );
            case 'U':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,0,0,1
                                    ,1,0,0,1
                                    ,1,0,0,1
                                    ,1,0,0,1
                                    ,0,1,1,1
                                ]);
                abc( p, arr );
            case 'V':
                arr = new Arr2D( [   5,5 // array dimensions
                                    ,1,0,0,0,1
                                    ,1,0,0,0,1
                                    ,0,1,0,1,0
                                    ,0,1,0,1,0
                                    ,0,0,1,0,0
                                ]);
                abc( p, arr );
            case 'W':
                arr = new Arr2D( [   5,5 // array dimensions
                                    ,1,0,0,0,1
                                    ,1,0,0,0,1
                                    ,1,0,1,0,1
                                    ,0,1,0,1,0
                                    ,0,1,0,1,0
                                ]);
                abc( p, arr );
            case 'X':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,0,0,1
                                    ,1,0,0,1
                                    ,0,1,1,0
                                    ,1,0,0,1
                                    ,1,0,0,1
                                ]);
                abc( p, arr );
            case 'Y':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,0,0,1
                                    ,1,0,0,1
                                    ,0,1,1,1
                                    ,0,0,0,1
                                    ,0,1,1,0
                                ]);
                abc( p, arr );
            case 'Z':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,1,1,1
                                    ,0,0,0,1
                                    ,0,1,1,0
                                    ,1,0,0,0
                                    ,1,1,1,1
                                ]);
                abc( p, arr );
            case '0':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,1,1,0
                                    ,1,0,1,1
                                    ,1,1,0,1
                                    ,1,0,0,1
                                    ,0,1,1,0
                                ]);
                abc( p, arr );
            case '1':
                arr = new Arr2D( [   3,5 // array dimensions
                                    ,0,1,0
                                    ,1,1,0
                                    ,0,1,0
                                    ,0,1,0
                                    ,1,1,1
                                ]);
                abc( p, arr );
            case '2':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,1,1,0
                                    ,1,0,0,1
                                    ,0,0,1,0
                                    ,0,1,0,0
                                    ,1,1,1,1
                                ]);
                abc( p, arr );
            case '3':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,1,1,0
                                    ,0,0,0,1
                                    ,0,1,1,0
                                    ,0,0,0,1
                                    ,1,1,1,0
                                ]);
                abc( p, arr );
            case '4':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,0,0,0
                                    ,1,0,0,0
                                    ,1,0,1,0
                                    ,1,1,1,1
                                    ,0,0,1,0
                                ]);
                abc( p, arr );
            case '5':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,1,1,1
                                    ,1,0,0,0
                                    ,1,1,1,0
                                    ,0,0,0,1
                                    ,1,1,1,0
                                ]);
                abc( p, arr );
            case '6':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,1,1,1
                                    ,1,0,0,0
                                    ,1,1,1,0
                                    ,1,0,0,1
                                    ,0,1,1,0
                                ]);
                abc( p, arr );
            case '7':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,1,1,1
                                    ,0,0,1,0
                                    ,0,0,1,0
                                    ,0,1,0,0
                                    ,0,1,0,0
                                ]);
                abc( p, arr );
            case '8':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,1,1,0
                                    ,1,0,0,1
                                    ,0,1,1,0
                                    ,1,0,0,1
                                    ,0,1,1,0
                                ]);
                abc( p, arr );
            case '9':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,1,1,0
                                    ,1,0,0,1
                                    ,0,1,1,1
                                    ,0,0,0,1
                                    ,1,1,1,0
                                ]);
                abc( p, arr );
            case '.':
                arr = new Arr2D( [   3,5 // array dimensions
                                    ,0,0,0
                                    ,0,0,0
                                    ,0,0,0
                                    ,0,1,1
                                    ,0,1,1
                                ]);
                abc( p, arr );
            case ',':
                arr = new Arr2D( [   3,5 // array dimensions
                                    ,0,0,0
                                    ,0,0,0
                                    ,0,0,1
                                    ,0,0,1
                                    ,0,1,0
                                ]);
                abc( p, arr );
            case '!':
                arr = new Arr2D( [  3,5 // array dimensions
                                    ,0,0,1
                                    ,0,0,1
                                    ,0,0,1
                                    ,0,0,0
                                    ,0,0,1
                                ]);
                abc( p, arr );
            case '?':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,1,1,1
                                    ,1,0,0,1
                                    ,0,0,1,0
                                    ,0,0,0,0
                                    ,0,0,1,0
                                ]);
                abc( p, arr );
            case '"':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,0,1
                                    ,1,0,1
                                    ,0,0,0
                                    ,0,0,0
                                    ,0,0,0
                                ]);
                abc( p, arr );
            case '+':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,0,0
                                    ,0,1,0
                                    ,1,1,1
                                    ,0,1,0
                                    ,0,0,0
                                ]);
                abc( p, arr );
            case '-':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,0,0,0
                                    ,0,0,0,0
                                    ,0,1,1,0
                                    ,0,0,0,0
                                    ,0,0,0,0
                                ]);
                abc( p, arr );
            case '(':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,1,0,0
                                    ,1,0,0,0
                                    ,1,0,0,0
                                    ,1,0,0,0
                                    ,0,1,0,0
                                ]);
                abc( p, arr );
            case ')':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,0,1,0
                                    ,0,0,0,1
                                    ,0,0,0,1
                                    ,0,0,0,1
                                    ,0,0,1,0
                                ]);
                abc( p, arr );
            case '=':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,0,0,0
                                    ,1,1,1,1
                                    ,0,0,0,0
                                    ,1,1,1,1
                                    ,0,0,0,0
                                ]);
                abc( p, arr );
            case '@':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,1,1,1
                                    ,1,0,0,1
                                    ,0,1,1,1
                                    ,0,1,0,1
                                    ,0,1,1,0
                                ]);
                abc( p, arr );
            case '\\':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,0,0,0
                                    ,0,1,0,0
                                    ,0,0,1,0
                                    ,0,0,1,0
                                    ,0,0,0,1
                                ]);
                abc( p, arr );
            case '/':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,0,0,1
                                    ,0,0,1,0
                                    ,0,1,0,0
                                    ,0,1,0,0
                                    ,1,0,0,0
                                ]);
                abc( p, arr );
            case ';':
                arr = new Arr2D( [   3,5 // array dimensions
                                    ,0,0,1
                                    ,0,0,1
                                    ,0,0,0
                                    ,0,0,1
                                    ,0,1,0
                                ]);
                abc( p, arr );
            case ':':
                arr = new Arr2D( [   3,5 // array dimensions
                                    ,0,0,1
                                    ,0,0,1
                                    ,0,0,0
                                    ,0,0,1
                                    ,0,0,1
                                ]);
                abc( p, arr );
            case '>':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,1,0,0
                                    ,0,0,1,0
                                    ,0,0,0,1
                                    ,0,0,1,0
                                    ,0,1,0,0
                                ]);
                abc( p, arr );
            case '<':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,0,1,0
                                    ,0,1,0,0
                                    ,1,0,0,0
                                    ,0,1,0,0
                                    ,0,0,1,0
                                ]);
                abc( p, arr );
            case '^':
                arr = new Arr2D( [   3,5 // array dimensions
                                    ,0,1,0
                                    ,1,0,1
                                    ,0,0,0
                                    ,0,0,0
                                    ,0,0,0
                                ]);
                abc( p, arr );
            case '~':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,0,0,0
                                    ,0,1,0,1
                                    ,1,0,1,0
                                    ,0,0,0,0
                                    ,0,0,0,0
                                ]);
                abc( p, arr );
            case '*':
                arr = new Arr2D( [   5,5 // array dimensions
                                    ,1,0,1,0,1
                                    ,0,1,1,1,0
                                    ,1,1,1,1,1
                                    ,0,1,1,1,0
                                    ,1,0,1,0,1
                                ]);
                abc( p, arr );
            case '#':
                arr = new Arr2D( [   5,5 // array dimensions
                                    ,0,1,0,1,0
                                    ,1,1,1,1,1
                                    ,0,1,0,1,0
                                    ,1,1,1,1,1
                                    ,0,1,0,1,0
                                ]);
                abc( p, arr );
            case '[':
                arr = new Arr2D( [   2,5 // array dimensions
                                    ,1,1
                                    ,1,0
                                    ,1,0
                                    ,1,0
                                    ,1,1
                                ]);
                abc( p, arr );
            case ']':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,0,1,1
                                    ,0,0,0,1
                                    ,0,0,0,1
                                    ,0,0,0,1
                                    ,0,0,1,1
                                ]);
                abc( p, arr );
            case '_':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,0,0,0
                                    ,0,0,0,0
                                    ,0,0,0,0
                                    ,0,0,0,0
                                    ,1,1,1,1
                                ]);
                abc( p, arr );
            case '%':
                arr = new Arr2D( [   5,5 // array dimensions
                                    ,1,1,0,0,1
                                    ,1,0,0,1,0
                                    ,0,0,1,0,0
                                    ,0,1,0,0,1
                                    ,1,0,0,1,1
                                ]);
                abc( p, arr );
            case '&':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,1,1,0
                                    ,1,0,1,0
                                    ,0,1,0,1
                                    ,1,0,1,0
                                    ,0,1,0,1
                                ]);
                abc( p, arr );
            case '|':
                arr = new Arr2D( [   2,5 // array dimensions
                                    ,0,1
                                    ,0,1
                                    ,0,1
                                    ,0,1
                                    ,0,1
                                ]);
                abc( p, arr );
            case 'KHA':
                arr = new Arr2D( [   14,5 // array dimensions
                                    ,1,0,0,1,0,1,0,0,1,0,0,1,1,0
                                    ,1,0,1,0,0,1,0,0,1,0,1,0,0,1
                                    ,1,1,0,0,0,1,1,1,1,0,1,0,0,1
                                    ,1,0,1,0,0,1,0,0,1,0,1,1,1,1
                                    ,1,0,0,1,0,1,0,0,1,0,1,0,0,1
                                ]);
                abc( p, arr );               
            default:
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,1,0,0,1
                                    ,1,0,0,1
                                    ,0,0,0,0
                                    ,1,0,0,1
                                    ,0,1,1,0
                                ]);
                abc( p, arr );
            /*case ' ':
                arr = new Arr2D( [   4,5 // array dimensions
                                    ,0,0,0,0
                                    ,0,0,0,0
                                    ,0,0,0,0
                                    ,0,0,0,0
                                    ,0,0,0,0
                                ]);
                abc( p, arr );*/
        }

	}
    public inline 
    function abc( p: Point, pos: Arr2D, ?snapped: Snapped ): Shape {
        if( snapped == null ) snapped = Snapped.Always;
        var ts = createPolyomino( p, snapped );
        var sx = -2;
        var sy = -2.5;
        var w = pos.width;
        var h = pos.height;
        var dx = sx;
        var dy = sy;
        var count: Int = 0;
        for( x in 0...w ){
            for( y in 0...h ){
                if( pos.isOne( x, y ) ){
                    ts.addBlock( sx + x, sy + y 
                            #if hideBlocks
                                , true, false
                            #end 
                            );
                }
            }
        }
        return ts;
    }
}