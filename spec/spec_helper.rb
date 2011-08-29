require File.join(File.dirname(__FILE__), '..', 'app.rb')

require 'rack/test'
set :environment, :test

RSpec.configure do |config|
  #config.before(:each) { DataMapper.auto_migrate! }
end

