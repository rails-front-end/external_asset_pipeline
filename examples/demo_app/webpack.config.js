const glob = require('glob');
const path = require('path');
const util = require('util');
const WebpackAssetsManifest = require('webpack-assets-manifest');

const entryDir = 'packs';
const sourceRoot = path.resolve(__dirname, './app/javascript');
const entryRoot = path.resolve(sourceRoot, entryDir);
const targetRoot = path.resolve(__dirname, `./public/${entryDir}`);

const extensions = ['js', 'jsx', 'ts', 'tsx'];
const mode = process.env.NODE_ENV || 'development';

const config = {
  context: entryRoot,
  entry: async () => {
    const globPromise = util.promisify(glob);
    const paths = await globPromise(`${entryRoot}/**/*.{${extensions.join(',')}}`);

    const entry = {};
    paths.forEach((p) => {
      const relativePath = path.relative(entryRoot, p);
      const parts = path.parse(relativePath);
      const chunkName = path.join(parts.dir, parts.name);
      entry[chunkName] = p;
    });

    return entry;
  },
  mode,
  module: {
    rules: [
      {
        include: [sourceRoot],
        test: /\.(t|j)sx?$/,
        use: {
          loader: 'babel-loader',
          options: {
            cacheDirectory: true,
          },
        },
      },
    ]
  },
  node: false,
  output: {
    filename: '[name]-[hash].js',
    path: targetRoot,
    publicPath: `/${entryDir}/`
  },
  plugins: [
    new WebpackAssetsManifest(),
  ],
  resolve: {
    extensions: extensions.map(e => `.${e}`)
  }
};

if (mode === 'development') {
  config.devtool = 'cheap-source-map';
}

module.exports = config;
