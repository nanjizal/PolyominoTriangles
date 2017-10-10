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

project.addDefine('use_tetris_S');
project.addDefine('use_tetris_L');
project.addDefine('use_tetris_box');
project.addDefine('use_tetris_t');
project.addDefine('use_tetris_l');

//project.addShaders('src/Shaders/**');
//project.addLibrary('poly2trihx');
//project.addLibrary('justTriangles');
//project.addLibrary('Nodule');
resolve(project);
