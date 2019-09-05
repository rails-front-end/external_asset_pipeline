# ExternalAssetPipeline

The `external_asset_pipeline` gem provides a lightweight and flexible
integration between rails and any independent asset processor(s) that can
produce an asset manifest.

It can be used in conjunction with [`sprockets`] or as a complete replacement
that manages all assets. This is perhaps best illustrated through examples, so
don't hesitate to check out some demo apps:
- [examples/demo_app](./examples/demo_app) uses [`webpack`] to process
javascript assets while `sprockets` handles other assets
  - [examples/demo_app-rails5](./examples/demo_app-rails5) is the same app but
    using rails 5 instead of rails 6 (`external_asset_pipeline` supports both)
- [examples/demo_app-gulp](./examples/demo_app-gulp) uses
[`gulp`] in addition to `webpack` to manage all assets without `sprockets`
- [examples/demo_app-rollup](./examples/demo_app-rollup) uses [`rollup`] instead
of `webpack` to process javascript assets

[`gulp`]: https://gulpjs.com
[`rollup`]: https://rollupjs.org
[`sprockets`]: https://github.com/rails/sprockets
[`webpack`]: https://webpack.js.org

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'external_asset_pipeline'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install external_asset_pipeline

## Usage

In `config/application.rb`, after the code that `require`s rails, add:

```ruby
require 'external_asset_pipeline/railtie'
```

See an example in
[`examples/demo_app/config/application.rb`](./examples/demo_app/config/application.rb)

Additionally, in any environments where you don't want the asset manifest to be
cached (e.g. in development), you should set

```ruby
config.external_asset_pipeline.cache_manifest = false
```

See an example in
[`examples/demo_app/config/environments/development.rb`](./examples/demo_app/config/environments/development.rb)

### Usage together with sprockets

If you'd like to use the `external_asset_pipeline` together with `sprockets`,
you must also set

```ruby
config.external_asset_pipeline.fall_back_to_sprockets = true
````

either in `config/application.rb` or in an initializer (e.g.
`config/initializers/assets.rb`). This tells your app to first look for an asset
in the external asset pipeline manifest, and if no asset is found then fall back
to looking in the sprockets pipeline.

See an example in
[`examples/demo_app/config/application.rb`](./examples/demo_app/config/application.rb)

### Configuration

By default, the `external_asset_pipeline` will look for an asset manifest in
`public/packs/manifest.json`. You can configure both the public subdirectory and
the manifest filename:

```ruby
config.external_asset_pipeline.assets_prefix = '/static'
config.external_asset_pipeline.manifest_filename = '.asset-manifest.json'
```

### Using with a dev server

You may also connect the `external_asset_pipeline` to a dev server (e.g.
[`webpack-dev-server`]). To do so, configure the corresponding `dev_server`
settings:

```ruby
config.external_asset_pipeline.dev_server.enabled = true
config.external_asset_pipeline.dev_server.host = 'localhost'
config.external_asset_pipeline.dev_server.port = 9000
```

You may _optionally_ also configure the `dev_server.public_origin` setting,
which will be used to generate the URLs in your asset tags. If this isn't set,
the asset origin defaults to `"http://#{dev_server.host}:#{dev_server.port}"`,
so `public_origin` only needs to be set if that default doesn't work <sup>1</sup>.

If the dev server is enabled but not running (i.e. we can't establish a
connection to that port), the app will automatically fall back to returning
assets from disk.

See an example in
[`examples/demo_app/config/environments/development.rb`](./examples/demo_app/config/environments/development.rb)

<sup><sup>1</sup> For example, if you're running everything in docker containers
then the origin from which the browser requests assets may be different than the
origin that the rails container uses to request the manifest from the dev server
container.</sup>

[`webpack-dev-server`]: https://github.com/webpack/webpack-dev-server

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to [rubygems.org].

[rubygems.org]: https://rubygems.org

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/rails-front-end/external_asset_pipeline.

## License

The gem is available as open source under the terms of the [MIT License].

[MIT License]: https://opensource.org/licenses/MIT
