# ExternalAssetPipeline Demo with Rollup

This example uses [`rollup`] with [`rollup-plugin-fingerprint`] to build the
assets and generate the manifest. Refer to the [`package.json`](./package.json)
and [`rollup.config.js`](./rollup.config.js) to see the specifics.

[`rollup`]: https://rollupjs.org
[`rollup-plugin-fingerprint`]: https://github.com/rmacklin/rollup-plugin-fingerprint

## Working with assets

### Watch mode (incremental recompilation)

`bin/yarn watch`

### Development build

`bin/yarn build`

### Production build

`NODE_ENV=production bin/yarn build`
