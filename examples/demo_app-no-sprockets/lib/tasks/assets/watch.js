const gulp = require('gulp');

const buildTask = require('./build');
const buildImagesTask = require('./build-images');

const watch = gulp.series(buildTask, function watchFiles() {
  gulp.watch(buildImagesTask.files, buildImagesTask);
});

watch.description = 'Watch files for changes and trigger recompilation';

module.exports = watch;
