# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rpg_maker_vx_util/version'

Gem::Specification.new do |spec|
  spec.name          = 'rpg-maker-vx-util'
  spec.version       = RPGMakerVXUtil::VERSION
  spec.authors       = ['Michael Miller']
  spec.email         = ['bluepixelmike@gmail.com']
  spec.summary       = %q{Gem containing utilities and libraries for accessing and modifying RPG Maker VX (Ace) projects.}
  spec.description   = %q{Contains utilities and libraries for accessing and modifying RPG Maker VX (Ace) projects.
This gem effectively lets developers write RPG Maker games in their own environments.
It provides functionality for importing and exporting data from RPG Maker VX projects.
All credit and ownership for the original code goes to Enterbrain - the creators of RPG Maker.}
  spec.homepage      = 'https://github.com/bluepixelmike/rpg-maker-vx-util'
  # TODO: spec.license

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
