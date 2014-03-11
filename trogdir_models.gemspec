lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'trogdir_models/version'

spec = Gem::Specification.new do |s|
  s.name = 'trogdir_models'
  s.version = TrogdirModels::VERSION
  s.summary = 'Shared models for the Trogdir directory'
  s.description = 'A shared set of Mongoid models for the Trogdir directory project'
  s.files = Dir['README.*', 'MIT-LICENSE', 'lib/**/*.rb']
  s.require_path = 'lib'
  s.author = 'Adam Crownoble'
  s.email = 'adam.crownoble@biola.edu'
  s.homepage = 'https://github.com/biola/trogdir-models'
  s.license = 'MIT'
  s.add_dependency('mongoid')
end