// Kha needs Main as entry point you can't just have any named file
package;
// graphics4 commented out as the shaders mess up the Kode graphics2 build.
import kha.System;
import polyominoTriangles.PolyominoTrianglesKha2;
//import polyominoTriangles.PolyominoTrianglesKha4;
import kha.Scheduler;
class Main {
    public static function main() {
        //TOD: add antiAlias; 4 ?? 
        System.init({title: "Simple Polyomino Kha", width: 1024, height: 768, samplesPerPixel: 4 }, initGraphics2 );
    }
    static function initGraphics2():Void {
        new PolyominoTrianglesKha2();
    }
    static function initGraphics4():Void {
        //new PolyominoTrianglesKha4();
    }
}