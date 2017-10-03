let project = new Project('Empty');
project.addAssets('assets/**');
project.addSources('src');
project.addShaders('src/Shaders/**');
project.addLibrary('poly2trihx');
project.addLibrary('justTriangles');
resolve(project);
