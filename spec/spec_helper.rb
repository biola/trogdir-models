$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
$:.unshift File.expand_path(File.dirname(__FILE__))

ENV['RACK_ENV'] = 'test'

require 'bundler/setup'
require 'rspec'
require 'trogdir_models'
require 'mongoid-rspec'
require 'factory_girl'
require 'faker'
require 'pry'

Mongoid.load!('spec/config/mongoid.yml')

FactoryGirl.definition_file_paths = ['./spec/factories']
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Mongoid::Matchers

  # Clean/Reset Mongoid DB prior to running each test.
  config.before(:each) do
    Mongoid::Sessions.default.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
end