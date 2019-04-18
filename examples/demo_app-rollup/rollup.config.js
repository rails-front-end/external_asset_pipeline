const glob = require('glob');
const babel = require('rollup-plugin-babel');
const commonjs = require('rollup-plugin-commonjs');
const fingerprint = require('rollup-plugin-fingerprint');
const resolve = require('rollup-plugin-node-resolve');
const { terser } = require('rollup-plugin-terser');

const files = glob.sync('app/javascript/packs/**/*.js');

const plugins = [
  resolve(),
  commonjs({
    namedExports: {
      activestorage: ['start']
    }
  }),
  babel()
];

if (process.env.NODE_ENV === 'production') {
  plugins.push(
    terser({
      mangle: {
        // Works around a Safari 10 bug:
        // https://github.com/mishoo/UglifyJS2/issues/1753
        safari10: true
      }
    })
  );
}

module.exports = files.map(
  file => ({
    input: file,
    output: {
      file: file.replace('app/javascript/packs/', ''),
      format: 'iife'
    },
    plugins: plugins.concat(
      fingerprint({
        dest: file.replace('app/javascript/packs/', '').replace('.js', '-[hash].js'),
        destDir: 'public/packs',
        manifest: 'public/packs/manifest.json',
        replace: true,
        reuseManifest: true
      })
    )
  })
);
