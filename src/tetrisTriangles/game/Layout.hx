package tetrisTriangles.game;
// Setup position of Controller visual elements
class Layout{
	var controller: Controller;
	var noBlocks    = 30;//1
	var originP:    { x: Float, y: Float };
	var wide: 		Int;
	var hi: 		Int;
	var dia: 		Float;
	public function new( 	controller_: 	Controller,  originP_: 	{ x: Float, y: Float }
						, 	wide_: 			Int, 		 hi_: 		Int
						, 	dia_: 			Float, 		 sy: 		Float ){
		controller = controller_;
		wide = wide_;
		hi = hi_;
		dia = dia_;
		originP = originP_;
        var bottomP = { x: originP.x, y: originP.y + dia * hi };
        background();
        fallingBlocks( noBlocks, sy );
        bottom( bottomP );
	}
	function background(){
        controller.createBg( originP, wide, hi, 10, 0, 9, 0 );
    }
    function fallingBlocks( noBlocks: Int, aboveY: Float ){
        var randX   = 0.;
		var x = originP.x;
		var y = originP.y;
        for( i in 0...noBlocks ){
            var m = i % 6 + 1; // restart colors
            var randX = dia + dia * Math.round( Math.random() * ( wide - 0.5 ));
            controller.createShape( { x: x + randX, y: y - i * aboveY }, m , m + 1 );// , TetrisShape.tetris_L );  <- can choose on shape.
        }
    }
    function bottom( p: { x: Float, y: Float } ){
        controller.createBottom( p, wide, 8, 9 );
    }

}