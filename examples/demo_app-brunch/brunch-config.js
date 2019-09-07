const glob = require('glob');
const assetFunctions = require('node-sass-asset-functions');

const jsEntryRoot = 'app/javascript/packs/';
const jsEntryFiles = glob.sync(`${jsEntryRoot}**/*.js`);
const jsEntryPoints = jsEntryFiles.reduce(
  (result, file) => ({ ...result, [file]: file.replace(jsEntryRoot, '') }),
  {}
);
const autoRequires = jsEntryFiles.reduce(
  (result, file) => ({ ...result, [file.replace(jsEntryRoot, '')]: [file] }),
  {}
);

const stylesEntryRoot = 'app/assets/stylesheets/packs/';
const stylesheets = glob.sync(`${stylesEntryRoot}**/*.scss`).reduce(
  (result, file) => (
    {
      ...result,
      [file.replace(stylesEntryRoot, '').replace('.scss', '.css')]: file
    }
  ),
  {}
);

const imagesRoot = 'app/assets/images/';
const imageSourceFiles = glob.sync(`${imagesRoot}**/*`);
const imageOutputFiles =
  imageSourceFiles.map(file => `/packs/${file.replace(imagesRoot, '')}`);

module.exports = {
  conventions: {
    assets: /assets\/images\//,
    ignored: [/\/_/, /stylesheets\/(?!packs)/]
  },
  files: {
    javascripts: { entryPoints: jsEntryPoints },
    stylesheets: { joinTo: stylesheets }
  },
  modules: {
    autoRequire: autoRequires,
    nameCleaner: path => path
  },
  paths: {
    public: 'public/packs',
    watched: ['app/javascript', 'app/assets']
  },
  plugins: {
    fingerprint: {
      alwaysRun: true,
      assetsToFingerprint: imageOutputFiles,
      autoReplaceAndHash: true,
      destBasePath: 'public/packs/',
      hashLength: 10,
      manifest: './public/packs/manifest.json',
      srcBasePath: 'public/packs/'
    },
    sass: {
      functions: assetFunctions({
        http_images_path: '/packs',
      }),
      options: {
        includePaths: ['node_modules'],
      }
    }
  }
};
