package tetrisTriangles.game;
import tetrisTriangles.game.Controller;
// Main Tetris x, y movement control
class Movement{
	var controller: 		Controller;
	var dia:				Float;
	var fallSpeed           = 0.01;
    var jumpSpeed           = 7;
    var jumpX               = .0;   // for movement smoothing
    var jumpY               = .0;
    var toggleX             = false;
    var toggleY             = false;
    var jx                  = 0.;
    var jy                  = 0.;
    public var leftStop:    Float;
    public var rightStop:   Float;
	public function new( controller_: Controller, dia_: Float ){
		controller  = controller_;
		dia			= dia_;
	}
    public inline
	function move( x: Int, y: Int ): Bool{
        return if( toggleX ) {
			false;
		} else if( toggleY ) {
			false;
		} else {
        	if( x != 0 ) toggleX = true;
        	if( y != 0 ) toggleY = true;
        	jumpX = x * dia;
        	jumpY = y * dia;
			true;
		}
    }
    public inline 
    function update(){ // variable names could be improved
        var djx = 0.;
        var djy = 0.;
        if( toggleX ){ // smooth x movement 
            if( jumpX > 0 ){
                djx = jumpX / jumpSpeed;
                jx += djx;
                if( jx > jumpX + djx/2 ){ // reset
                    toggleX = false;
                    jx = 0.;
                    djx = 0.;
                }
            } else {
                djx = jumpX / jumpSpeed;
                jx += djx;
                if( jx < jumpX + djx/2 ){ // reset
                    toggleX = false;
                    jx = 0.;
                    djx = 0.;
                }
            }
        }
        if( toggleY ){ // only one of these actually used the down movement smoothing
            if( jumpY > 0 ){
                djy = jumpY / jumpSpeed;
                jy += djy;
                if( jy > jumpY + djy/2 ){ // reset
                    toggleY = false;
                    jy = 0.;
                    djy = 0.;
                }
            } else {
                djy = jumpY / jumpSpeed;
                jy += djx;
                if( jy < jumpY + djy/2 ){ // reset
                    toggleY = false;
                    jy = 0.;
                    djy = 0.;
                }
            }
        }
        if( toggleX ) controller.moveX( djx, leftStop, rightStop );
        controller.moveDelta( 0.0, fallSpeed + djy );

        /* Non smooth mouse movement alternative to above complexity
            controller.moveX( jumpX ); 
            controller.moveDelta( 0.0, fallSpeed + jumpY );

            // jumpX = 0.;
            // jumpY = 0.;
        }
        */
    }

}