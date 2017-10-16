let project = new Project('Empty');
project.addAssets('assets/**');
project.addSources('src');
project.windowOptions.width = 1024;
project.windowOptions.height = 768;

// debug visual options
//project.addDefine('drawOnBackground');
//project.addDefine('showVirtualBlocksAbove'); // not right yet
//project.addDefine('showVirtualBlocksBelow');
//project.addDefine('hideBottom');

//project.addDefine('showVirtualBlocksBelow'); //use with hide blocks
//project.addDefine('hideBlocks');

//project.addDefine('use_polyomino_Z');
//project.addDefine('use_polyomino_L');
//project.addDefine('use_polyomino_box');
//project.addDefine('use_polyomino_t');
//project.addDefine('use_polyomino_l');

//extra polyomino shapes
        
//project.addDefine('use_polyomino_S');
//project.addDefine('use_polyomino_rL');
//project.addDefine('use_abc');
//project.addDefine('use_kha');

//project.addShaders('src/Shaders/**');
//project.addLibrary('poly2trihx');
//project.addLibrary('justTriangles');
//project.addLibrary('Nodule');
resolve(project);
