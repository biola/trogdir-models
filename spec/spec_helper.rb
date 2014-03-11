$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
$:.unshift File.expand_path(File.dirname(__FILE__))

require 'bundler/setup'
require 'rspec'
require 'trogdir_models'
require 'shoulda-matchers'

RSpec.configure do |config|
end