require_relative 'lib/icomoon/version'

Gem::Specification.new do |s|
  s.name          = 'icomoon'
  s.version       = Icomoon::VERSION
  s.summary       = 'Icomoon helper'
  s.description   = 'Rails helper makes using Icomoon easier.'
  s.authors       = ['polakowski']
  s.email         = 'marek.polakowski@gmail.com'
  s.files         = Dir.glob('{bin,lib}/**/*') + %w(README.md)
  s.homepage      = 'https://github.com/polakowski/icomoon'
  s.license       = 'MIT'
  s.require_paths = ['lib']

  s.executables << 'icomoon'
  s.required_ruby_version = '>= 2.2.2'

  s.add_dependency 'colorize', '~> 0.8.1'
  s.add_development_dependency 'bundler', '~> 1.5'
end
