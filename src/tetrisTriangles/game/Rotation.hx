package tetrisTriangles.game;
import tetrisTriangles.game.Controller;
// Main Tetris rotation control, to help with animating the rotation.
class Rotation{
	var controller: 	Controller;
	var toggle          = false;
	var count           = 0.; // for rotation smoothing
	var rotationSpeed   = 20;
	public function new( controller_: Controller ){
		controller = controller_;
	}
	inline public
	function rotate( i: Int ): Bool{
        return if( toggle ) {
			false;
		} else {
        	toggle = true;
        	count = 1.0;
			true;
		}
    }
    inline public
    function update(){
        if( toggle ) controller.rotate( Math.PI/ rotationSpeed );
        if( count % ( rotationSpeed/2 ) == 0. ) {
            count = 0.;
            toggle = false;
        }
        count += 1.;
    }
	public function reset(){
		toggle = false;
		count = 0;
	}
}