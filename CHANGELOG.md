# Changelog

## 0.6.0

Default `dev_server.host` setting to `'localhost'` and `dev_server.port` setting
to `3035`. This means there is less to configure in apps which align with these
conventions.

## 0.5.0

Add `external_asset_pipeline_manifest` helper method which can be overridden to
return a different `Manifest` instance than the default. One example use case
would be to override this helper in different rails engines to use a distinct
`Manifest` instance in each one.

## 0.4.0

Add `prepend_assets_prefix_to_manifest_values` setting to support manifests
whose values already include the assets prefix.

## 0.3.0

Add `dev_server.public_origin` setting to support the use case where different
origins are used when the rails backend connects to the dev server (to get the
manifest) and when the browser requests assets from the dev server.

## 0.2.0

Add support for requesting assets from a dev server

## 0.1.0

Initial version
