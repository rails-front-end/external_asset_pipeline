const gulp = require('gulp');
const buildStylesTask = require('./build-styles');

const build = gulp.parallel(buildStylesTask);

build.description = 'Build all static assets';

module.exports = build;
