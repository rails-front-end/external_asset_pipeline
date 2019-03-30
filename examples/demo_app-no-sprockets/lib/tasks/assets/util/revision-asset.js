const gulp = require('gulp');
const rev = require('gulp-rev');

function revisionAsset(input) {
  return (
    input
      .pipe(rev())
      .pipe(gulp.dest('public/packs'))
      .pipe(rev.manifest({
        base: 'public/packs',
        merge: true,
        path: 'public/packs/manifest.json'
      }))
      .pipe(gulp.dest('public/packs'))
  );
}

module.exports = revisionAsset;
