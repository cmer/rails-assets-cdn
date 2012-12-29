# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails-assets-cdn/version'

Gem::Specification.new do |gem|
  gem.name          = "rails-assets-cdn"
  gem.version       = RailsAssetsCdn::VERSION
  gem.authors       = ["Carl Mercier"]
  gem.email         = ["carl@carlmercier.com"]
  gem.description   = %q{Add support for single and multiple CDN hosts for the Rails asset pipeline}
  gem.summary       = %q{CDN support for Rails asset pipeline made easy}
  gem.homepage      = "http://github.com/cmer/rails-assets-cdn"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'rails'
end