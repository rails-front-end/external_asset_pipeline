const fs = require('fs');
const gulp = require('gulp');
const sassGrapher = require('@rmacklin/sass-graph');
const path = require('path');
const touch = require('touch');

const buildTask = require('./build');
const buildImagesTask = require('./build-images');
const buildStylesTask = require('./build-styles');

let sassGraph;

function buildGraph() {
  sassGraph = sassGrapher.parseDir('./app/assets/stylesheets');
}

const watch = gulp.series(buildTask, function watchFiles() {
  buildGraph();
  gulp.watch(buildImagesTask.files, buildImagesTask);
  gulp.watch(buildStylesTask.files, buildStylesTask);

  // Trigger recompilation of stylesheet entry points when their dependencies
  // are modified
  const watcher = gulp.watch(buildStylesTask.additionalWatchFiles);
  watcher.on('all', (type, filepath) => {
    const rebuildGraphAfterTraversal = !fs.existsSync(filepath);

    if (!rebuildGraphAfterTraversal) {
      buildGraph();
    }

    const absolutePath = path.join(__dirname, '..', '..', '..', filepath);

    sassGraph.visitAncestors(absolutePath, (parent) => {
      if (parent.includes('stylesheets/packs')) {
        if (fs.existsSync(parent)) {
          touch.sync(parent);
        }
      }
    });

    if (rebuildGraphAfterTraversal) {
      buildGraph();
    }
  });
});

watch.description = 'Watch files for changes and trigger recompilation';

module.exports = watch;
