package tetrisTriangles.game;
import justTriangles.Triangle;
import tetrisTriangles.visual.TetrisGenerator;
class TetrisTriangles {
    var dia: Float = 0.15;
    var edge: Float = 0.01; // disabled in code as gets in way of hitTest for momment, this is the spacing between squares.
    var x: Int = -4;
    var y: Int = -4;
    var right: Int = 10;
    var above: Int = 7;
    var tetrisGenerator: TetrisGenerator;
    var count = 0.;
    var toggle: Bool = true;
    var wide: Int = 22;
    var hi: Int = 15;
    public function new( scale: Float = 1 ){
        dia = scale*dia;
        edge = scale*edge;
        tetrisGenerator = new TetrisGenerator( 0, Triangle.triangles, dia, edge );
        var dx = dia*x;
        var dy = dia*y;
        var sy = dia*above;
        tetrisGenerator.generateBackground( { x: dx, y: dy }, wide, hi, 10, 0, 9, 0 );
        var randX: Float;
        for( i in 0...30 ){
            var m = i % 6;// restart colors
            var randX = dia + dia * Math.round( Math.random() * ( wide - 0.5 ));
            tetrisGenerator.generateRandom( { x: dx + randX, y: dy - i * sy }, m + 1, m + 2 );
        }
        tetrisGenerator.generateHoriz( { x: dx, y: dy + dia * hi }, wide, 8, 9 );
        
    }
    public inline function update(){
        tetrisGenerator.hitBottom();
        var rotationSpeed = 10;// 50 for testing
        if( count % rotationSpeed == 0 ) toggle = !toggle; 
        count += 1.;
        if( toggle ) {
            count += 1.; 
            tetrisGenerator.rotate( Math.PI/ rotationSpeed );
            //tetrisGenerator.rotate( Math.PI/ 2 );
            //toggle = false;
        }
        tetrisGenerator.moveDelta( 0.0, 0.1 );// testing 0.015
        tetrisGenerator.hitBottom();
    }
}