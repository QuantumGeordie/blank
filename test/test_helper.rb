ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'

require File.expand_path '../../app.rb', __FILE__

class UnitTest < MiniTest::Test
  include Rack::Test::Methods
end

class IntegrationTest < UnitTest
  def app
    Sinatra::Application
  end
end
