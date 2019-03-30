const gulp = require('gulp');
const buildImagesTask = require('./build-images');

const build = gulp.parallel(buildImagesTask);

build.description = 'Build all static assets';

module.exports = build;
