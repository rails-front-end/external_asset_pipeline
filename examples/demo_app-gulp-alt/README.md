# ExternalAssetPipeline Demo with Gulp and Webpack reading from two manifests

This example is the same as [`demo_app-gulp`](../demo_app-gulp) but showcasing
how you can assemble a more complex integration with the ExternalAssetPipeline.
This app integrates with two separate JSON manifests (`gulp-manifest.json`, for
the `gulp`-compiled assets, and `webpack-manifest.json`, for the
`webpack`-compiled assets). To achieve this, the app instantiates its own
`ExternalAssetPipeline::Manifest` instances corresponding to each JSON file and
combines them using the `ExternalAssetPipeline::PriorityManifest`. Finally, it
overrides the `external_asset_pipeline_manifest` helper method to reference this
custom manifest instance. See [this commit] for details.

[this commit]: https://github.com/rails-front-end/external_asset_pipeline/commit/defd5e93c73ef67a3df9f3f386031a38ba29520f

This example uses [`gulp`] with [`gulp-rev`] and [`webpack`] with
[`webpack-assets-manifest`] to build the assets and generate the manifest. Refer
to the [`package.json`](./package.json), [gulp tasks](./lib/tasks/assets), and
[`webpack.config.js`](./webpack.config.js) to see the specifics.

In this example, [`sprockets`] has been completely removed. Thus, there's no
more `assets:precompile` rake task, and in fact, there's no need to install
gems, load the rails environment, or even have ruby installed to compile
assets - the app's asset compilation is completely decoupled from rails! When
that coupling exists, changes to ruby code may affect assets, but when they're
completely separate, that's guaranteed to not be the case. Thus, we can easily
determine when it's unnecessary to recompile assets and use that to reduce the
overall build time.

[`gulp`]: https://gulpjs.com
[`gulp-rev`]: https://github.com/sindresorhus/gulp-rev
[`sprockets`]: https://github.com/rails/sprockets
[`webpack`]: https://webpack.js.org
[`webpack-assets-manifest`]: https://github.com/webdeveric/webpack-assets-manifest

## Working with assets

### Watch mode (incremental recompilation)

`bin/yarn watch`

### Development build

`bin/yarn build`

### Production build

`NODE_ENV=production bin/yarn build`
