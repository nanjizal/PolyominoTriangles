// Kha needs Main as entry point you can't just have any named file
package;

import kha.System;
import tetrisTriangles.TetrisTrianglesKha2;
//import tetrisTriangles.TetrisTrianglesKha4;
import kha.Scheduler;
class Main {
    public static function main() {
        //TOD: add antiAlias; 4 ?? 
        System.init({title: "Simple Tetris Kha", width: 1024, height: 768, samplesPerPixel: 4 }, initGraphics2 );
    }
    static function initGraphics2():Void {
        new TetrisTrianglesKha2();
    }
    static function initGraphics4():Void {
        //new TetrisTrianglesKha4();
    }
}