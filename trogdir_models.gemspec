lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'trogdir_models/version'

spec = Gem::Specification.new do |s|
  s.name = 'trogdir_models'
  s.version = TrogdirModels::VERSION
  s.summary = 'Shared models for the Trogdir directory'
  s.description = 'A shared set of Mongoid models for the Trogdir directory project'
  s.files = Dir['README.*', 'MIT-LICENSE', 'lib/**/*.rb', 'spec/factories/*.rb']
  s.require_path = 'lib'
  s.author = 'Adam Crownoble'
  s.email = 'adam.crownoble@biola.edu'
  s.homepage = 'https://github.com/biola/trogdir-models'
  s.license = 'MIT'
  s.add_runtime_dependency 'api-auth', '~> 1.0'
  s.add_runtime_dependency 'email_validator', '~> 1.4'
  s.add_runtime_dependency 'mongoid', '~> 4.0'
  # mongoid-history 0.4.5 has a breaking change where `require 'mongoid-history'`
  # raises an exception. Rather than do weird version checking on the gem, or resquing
  # errors, I'm excluding higher versions until it's resolved.
  # Details here: https://github.com/aq1018/mongoid-history/issues/124
  s.add_runtime_dependency 'mongoid-history', '~> 0.4', '<= 0.4.4'
  s.add_runtime_dependency 'mongoid_userstamp', '~> 0.4'
  s.add_development_dependency 'factory_girl', '~> 4.4'
  s.add_development_dependency 'faker', '~> 1.3'
  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'mongoid-rspec', '~> 2.0.0.rc1'
  s.add_development_dependency 'pry', '~> 0.9'
end
