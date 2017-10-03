/// NOT IMPLEMENTED - unlikely I will have time for Flambe?

package tetrisTriangles;
import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;

import justTriangles.Triangle;
import justTriangles.Draw;
import justTriangles.Point;
import justTriangles.PathContext;
import justTriangles.ShapePoints;
import justTriangles.QuickPaths;
import justTriangles.SvgPath;
import justTriangles.PathContextTrace;

// not implemented or supported haxelib does not work and the scripts for running too tricky to get right.
class TetrisTrianglesFlambe {
    static var graphics: Entity;
    public static function main(): Void {
        System.init();
        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.fromAssets("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }
    static function onSuccess ( pack :AssetPack ){
        // Add a solid color background
        var background = new FillSprite(0xFFffff, System.stage.width, System.stage.height);
        System.root.addChild(new Entity().add(background));
        graphics = new Entity();
        System.root.addChild(graphics);
        draw();
    }
    static function draw(){
        
    }
    static var fillColor: Int;
    static var fillAlpha: Float = 1.0;
    static inline function drawRectFill( x: Float, y: Float, width: Float, height: Float ){
        var shape = new flambe.display.FillSprite( fillColor, width, height )
                        .setXY( x, y )
                        .setAlpha( fillAlpha );
        shape.pixelSnapping = false;
        graphics.addChild(new flambe.Entity().add(shape));
    }
}