# tetrisTriangles

Simple experimental Haxe tetris, WIP

<img width="1665" alt="tetristriangles" src="https://user-images.githubusercontent.com/20134338/31321459-4e9a4a72-ac7e-11e7-9594-b837273e5f7e.png">

Current code in incomplete, but the bin folders contain html javascript solutions using a range of Haxe toolkits, click on the kit to view the experiment:

- [Kha ->](https://rawgit.com/nanjizal/tetrisTriangles/master/binKha2/)        ( Graphics2, Graphics4 version not working well needs tidy )
- [Luxe ->](https://rawgit.com/nanjizal/simpleTetris/master/binLuxe/web/index.html)
- [Canvas ->](https://rawgit.com/nanjizal/simpleTetris/master/binCanvas/index.html)
- [SVG ->](https://rawgit.com/nanjizal/simpleTetris/master/binSVG/index.html)                ( bit slow uses 'justDrawing' abstraction, could be improved need work )
- [NME - jsprime ->](https://rawgit.com/nanjizal/simpleTetris/master/binNme/jsprime/TetrisTrianglesFlash/index.html)   ( fails to load in content in gitraw :( )
- [OpenFL ->](https://rawgit.com/nanjizal/simpleTetris/master/binOpenFL/index.html)
- [Heaps ->](https://rawgit.com/nanjizal/simpleTetris/master/binHeaps/index.html)

Blocks are animated by drawing triangles to screen every frame. HitTest is done using point in Triangle algorithm, so checking the corners of all the bottom block ( triangles ) against all triangles of the animating blocks. A different hitTest solution is required for Tetris functionality, but current could be improved perhaps by restoring block to last non hitTest position, perhaps add History for future alternate use.

When block shapes hit the static bottom ( blocks ) thier internal squares are transfered to the bottom block.

At moment just renders tetris blocks rotating and falling with no keyboard control.

Have to improve rotation so that the blocks stay on grid by adjusting position based on Compass rotation this will need to vary with each shape, some will need starting offset others will need offset for 'East' / 'West' so that they when at perpendicular angles always in thier rows.

Blocks are hardcode based on offset from centre, so the 'L' shape block is defined

``` haxe
    var ts = createTetris( centrePoint );
    ts.addBlock( -1, -1.5 ); // based on the current diameter setting 'dia'
    ts.addBlock( -1, -0.5 );
    ts.addBlock( -1, 0.5 );
    ts.addBlock( 0, 0.5 );
```

Rotation are calculated on the points of the 'justTriangle.Triangle' class, by using translations -> trig -> translations similar to matrix calculations but lower overhead, this is so that rotations are around a blocks centre, it seems fast enough but perhaps could be simpler.

Need to add functionality to make blocks snap to grid on hitting bottom, perhaps matrix implementation for squares is needed so that they can be properly be snapped and hitTested more simply and never take another blocks position. 

No pooling is really implemented yet but probably needed for the blocks, must add a 'noSquares' parameter or similar.

