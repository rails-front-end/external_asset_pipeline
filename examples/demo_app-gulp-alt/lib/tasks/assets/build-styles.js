const gulp = require('gulp');
const changedInPlace = require('gulp-changed-in-place');
const postcss = require('gulp-postcss');
const revRewrite = require('gulp-rev-rewrite');
const sass = require('gulp-sass');
const assetFunctions = require('node-sass-asset-functions');

const buildImagesTask = require('./build-images');
const revisionAsset = require('./util/revision-asset');

const FILES = ['app/assets/stylesheets/packs/**/*'];
const ADDITIONAL_WATCH_FILES = ['app/assets/stylesheets/**/*', `!${FILES[0]}`];

const buildStyles = gulp.series(buildImagesTask, function buildStyles() {
  const manifest = gulp.src('public/packs/gulp-manifest.json');

  return revisionAsset(
    gulp.src(FILES, { sourcemaps: true })
      .pipe(
        changedInPlace({
          firstPass: true,
          howToDetermineDifference: 'modification-time'
        })
      )
      .pipe(
        sass({
          includePaths: ['node_modules'],
          functions: assetFunctions({
            http_images_path: '/packs',
          }),
        }).on('error', function handleSassError(error) {
          sass.logError.call(this, error);

          if (process.env.NODE_ENV === 'production') {
            // Errors in production builds should exit the process with a
            // nonzero code, so that CI will fail. But we don't want to do this
            // in development builds to avoid exiting the whole watch task for
            // development errors like typos.
            process.exit(1);
          }
        })
      )
      .pipe(revRewrite({ manifest }))
      .pipe(postcss()),
    { sourcemaps: '.' }
  );
});

buildStyles.description = 'Build styles (process sass, minify, fingerprint)';
buildStyles.files = FILES;
buildStyles.additionalWatchFiles = ADDITIONAL_WATCH_FILES;

module.exports = buildStyles;
