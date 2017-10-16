package polyominoTriangles.game;
import polyominoTriangles.game.Templates;
import polyominoTriangles.game.Shape;
import justTriangles.Point;
import polyominoTriangles.game.ABC;
// not much of a class just moved the random shape generation out of controller
// just to reduce the complexity of controller so this is really part of controller
@:enum
    abstract PolyominoShape( String ) to String from String {
    var polyomino_Z     = 'polyomino_Z';
    var polyomino_L      = 'polyomino_L';
    var polyomino_box    = 'polyomino_box';
    var polyomino_t      = 'polyomino_t';
    var polyomino_l      = 'polyomino_l';
    #if fullPolyomino
    var polyomino_S      = 'polyomino_S';
    var polyomino_rL     = 'polyomino_rL';
    #end
    var polyomino_random = 'polyomino_random';
}
class ShapeGenerator{
	var templates: 	Templates;
    var abc: ABC;
    var last        = -1;
    var random      = 0;
	public function new( createShape ){
        #if use_abc
            abc = new ABC( createShape );
        #else
		    templates = new Templates( createShape );  // uses Templates a shape factory.
        #end
	}
	public
	function randomShape( p: Point, col0_: Int, col1_: Int, ?shape: PolyominoShape = polyomino_random ){
		var ts: Shape;
        #if use_abc 
            ts = abc.rnd( p );
        #else // normal function
        switch( shape ){ // normally works as random polyomino shape
            case polyomino_random:
                #if fullPolyomino
                    var no = 6;
                #else
                    var no = 4;
                #end
                var random  = Math.round( no*Math.random() );
                trace( random );
                if( random == last ) return randomShape( p, col0_, col1_ );
                ts = switch( random ){
                        case 0:
                            ts = templates.Z( p );
                        case 1:
                            ts = templates.L( p );
                        case 2:
                            ts = templates.box( p );
                        case 3:
                            ts = templates.t( p );
                        case 4: 
                            ts = templates.l( p );
                        #if fullPolyomino
                        case 5:
                            ts = templates.S( p );
                        case 6:
                            ts = templates.rL( p );
                        #end     
                        default:
                            ts = templates.Z( p );
                    }
            default: 
                ts = switch( shape ){ // used to allow testing of only one shape ( add PolyominoShape in the method call );
                    case polyomino_Z:
                        templates.Z( p );
                    case polyomino_L:
                        templates.L( p );
                    case polyomino_box:
                        templates.box( p );
                    case polyomino_t:
                        templates.t( p );
					case polyomino_l:
						templates.l( p );
                    #if fullPolyomino
                    case polyomino_S:
                        ts = templates.S( p );
                    case polyomino_rL:
                        ts = templates.rL( p );
                    #end
                    default:
                        templates.box( p );
                }
        } 
        last = random;
        #end
		return ts;
    }
}