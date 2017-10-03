# tetrisTriangles

Simple experimental Haxe tetris, WIP

Current code in incomplete, but the bin folders contain html javascript solutions using a range of Haxe toolkits, click on the kit to view the experiment:

- [Kha ->](https://rawgit.com/nanjizal/simpleTetris/master/binKha2/html5/index.html)        ( Graphics2, Graphics4 version not working well needs tidy )
- [Luxe ->](https://rawgit.com/nanjizal/simpleTetris/master/binLuxe/web/index.html)
- [Canvas ->](https://rawgit.com/nanjizal/simpleTetris/master/binCanvas/index.html)
- [SVG ->](https://rawgit.com/nanjizal/simpleTetris/master/binSVG/index.html)                ( bit slow uses 'justDrawing' abstraction, could be improved need work )
- [NME - jsprime ->](https://rawgit.com/nanjizal/simpleTetris/master/binNme/jsprime/TetrisTrianglesFlash/index.html)   ( fails to load in content in gitraw :( )
- [OpenFL ->](https://rawgit.com/nanjizal/simpleTetris/master/binOpenFL/index.html)
- [Heaps ->](https://rawgit.com/nanjizal/simpleTetris/master/binHeaps/index.html)

Blocks are animated as triangles that are drawn to screen every frame, hitTest is done against the corners of all the bottom block triangles against all triangles of the other blocks, but a different hitTest solution is required.

When shapes hit static blocks such as the bottom thier squares are transfered to the bottom block.

At moment just renders tetris blocks rotating and falling with no keyboard control.

Have to improve rotation so that the blocks stay on grid by adjusting position based on Compass rotation this will need to vary with each shape, some will need starting offset others will need offset for 'East' / 'West' so that they when at perpendicular angles always in thier rows.

Blocks are hardcode based on offset from centre, so the 'L' shape block is defined

``` haxe
    var ts = createTetris( p );
    ts.addBlock( -1, -1.5 );
    ts.addBlock( -1, -0.5 );
    ts.addBlock( -1, 0.5 );
    ts.addBlock( 0, 0.5 );
```

Rotation are calculated on the points of the 'Triangle' class in my 'justTriangles' library, using translations trig and translations back so that rotations are around a blocks centre, it seems fast enough but perhaps could be simpler.

Need to add functionality to make blocks snap to grid on hitting bottom, perhaps matrix implementation for squares is needed so that they can be properly be snapped and hitTested more simply and never take another blocks position. 

No pooling is really implemented yet.

