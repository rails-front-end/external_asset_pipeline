# ExternalAssetPipeline Demo with Brunch replacing Sprockets

This example uses [`brunch`] with [`fingerprint-brunch`] to build the assets
and generate the manifest. Refer to the [`package.json`](./package.json) and
[`brunch-config.js`](./brunch-config.js) to see the specifics.

In this example, [`sprockets`] has been completely removed. Thus, there's no
more `assets:precompile` rake task, and in fact, there's no need to install
gems, load the rails environment, or even have ruby installed to compile
assets - the app's asset compilation is completely decoupled from rails! When
that coupling exists, changes to ruby code may affect assets, but when they're
completely separate, that's guaranteed to not be the case. Thus, we can easily
determine when it's unnecessary to recompile assets and use that to reduce the
overall build time.

[`brunch`]: https://brunch.io
[`fingerprint-brunch`]: https://github.com/dlepaux/fingerprint-brunch
[`sprockets`]: https://github.com/rails/sprockets

## Working with assets

### Watch mode (incremental recompilation)

`bin/yarn watch`

### Development build

`bin/yarn build`

### Production build

`NODE_ENV=production bin/yarn build`
