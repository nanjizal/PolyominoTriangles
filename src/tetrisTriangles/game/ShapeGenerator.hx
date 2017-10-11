package tetrisTriangles.game;
import tetrisTriangles.game.Templates;
import tetrisTriangles.game.Shape;
import justTriangles.Point;
// not much of a class just moved the random shape generation out of controller
// just to reduce the complexity of controller so this is really part of controller
@:enum
    abstract TetrisShape( String ) to String from String {
    var tetris_Z     = 'tetris_Z';
    var tetris_L      = 'tetris_L';
    var tetris_box    = 'tetris_box';
    var tetris_t      = 'tetris_t';
    var tetris_l      = 'tetris_l';
    #if fullTetris
    var tetris_S      = 'tetris_S';
    var tetris_rL     = 'tetris_rL';
    #end
    var tetris_random = 'tetris_random';
}
class ShapeGenerator{
	var templates: 	Templates;
    var last        = -1;
    var random      = 0;
	public function new( createShape ){
		templates = new Templates( createShape );  // uses Templates a shape factory.
	}
	public
	function randomShape( p: Point, col0_: Int, col1_: Int, ?shape: TetrisShape = tetris_random ){
		var ts: Shape;
        switch( shape ){ // normally works as random tetris shape
            case tetris_random:
                #if fullTetris
                    var no = 6;
                #else
                    var no = 4;
                #end
                var random  = Std.int( no*Math.random() );
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
                        #if fullTetris
                        case 5:
                            ts = templates.S( p );
                        case 6:
                            ts = templates.rL( p );
                        #end     
                        default:
                            ts = templates.Z( p );
                    }
            default: 
                ts = switch( shape ){ // used to allow testing of only one shape ( add TetrisShape in the method call );
                    case tetris_Z:
                        templates.Z( p );
                    case tetris_L:
                        templates.L( p );
                    case tetris_box:
                        templates.box( p );
                    case tetris_t:
                        templates.t( p );
					case tetris_l:
						templates.l( p );
                    #if fullTetris
                    case tetris_S:
                        ts = templates.S( p );
                    case tetris_rL:
                        ts = templates.rL( p );
                    #end
                    default:
                        templates.box( p );
                }
        } 
        last = random;
		return ts;
    }
}