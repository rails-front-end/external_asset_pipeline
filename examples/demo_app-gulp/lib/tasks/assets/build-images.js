const gulp = require('gulp');
const cache = require('gulp-cached');

const revisionAsset = require('./util/revision-asset');

const FILES = ['app/assets/images/**/*'];

function buildImages() {
  return revisionAsset(gulp.src(FILES).pipe(cache('images')));
}

buildImages.description = 'Build images (fingerprint and output to destination)';
buildImages.files = FILES;

module.exports = buildImages;
