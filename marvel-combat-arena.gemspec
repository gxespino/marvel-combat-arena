# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','marvel-combat-arena','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'marvel-combat-arena'
  s.version = MarvelCombatArena::VERSION
  s.author = 'Glenn Espinosa'
  s.email = 'glennpeter.espinosa@gmail.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A CLI for a text based Marvel character combat arena'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'marvel-combat-arena'
  s.add_development_dependency('rake','~> 0.9.2')
  s.add_development_dependency('rspec')
  s.add_runtime_dependency('gli','~> 2.20.1')
end
