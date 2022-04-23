# ExternalAssetPipeline Demo with Webpack

This example uses [`webpack`] with [`webpack-assets-manifest`] to build the
assets and generate the manifest. Refer to the [`package.json`](./package.json)
and [`webpack.config.js`](./webpack.config.js) to see the specifics.

[`webpack`]: https://webpack.js.org
[`webpack-assets-manifest`]: https://github.com/webdeveric/webpack-assets-manifest

## Working with assets

### Watch mode (incremental recompilation)

`bin/yarn watch`

### Development build

`bin/yarn build`

### Production build

`NODE_ENV=production bin/yarn build`
