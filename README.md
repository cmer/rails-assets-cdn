# rails-assets-cdn

This gem allows you to add single or multiple CDN hosts for the asset pipeline.
It aims to be flexible and configurable.

## Installation

Add this line to your application's Gemfile:

    gem 'rails-assets-cdn'

And then execute:

    $ bundle

Then add `assets_cdn.yml` to your `config` directory. Here's an example of the the most minimal config file possible:

    development:
      host: assets.myapp.dev

And here's a more complex config file supporting multiple CDN hosts for the production environment:

    development:
      host: assets.myapp.dev

    production:
      enabled: true
      hosts:
        - assets1.myapp.com
        - assets2.myapp.com
        - assets3.myapp.com
        - assets4.myapp.com
      protocol: browser
      fallback_protocol: http

## Configuration options:

#### enabled

A boolean value to enable/disable the CDN.

#### host

A single CDN host.

#### hosts

An array of hosts. The path of the asset is hashed then the modulo is extracted to determine which CDN host to use.

This is a simple and effective way to evenly split the load between multiple hosts. It is recommended to have 4 hosts (even if they all CNAME to the same destination) since some browsers can't download more than 2 files per host at the same time.

#### fallback_protocol

If `request` is used for protocol, this is the protocol Rails will use when an asset URL is generated outside of a request since it won't be able to determine the protocol to use.

Default: http

#### protocol

The protocol to prepend to the asset URL.

Default: browser

Options:

  - browser (Let the browser determine which protocol to use)
  - request (Rails prepends the protocol of the current request)
  - http (force http://)
  - https (force https://)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request