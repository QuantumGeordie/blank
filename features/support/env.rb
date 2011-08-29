ENV['RACK_ENV'] = 'test'

require 'bundler'
Bundler.setup

require 'rack/test'
require 'webrat'

app_file = File.dirname(__FILE__) + '/../../app'
require app_file
# Force the application name because polyglot breaks the auto-detection logic.
Sinatra::Application.app_file = app_file

Webrat.configure do |config|
  config.mode = :rack
 end

class TestWorld
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  Webrat::Methods.delegate_to_session :response_code, :response_body

  def app
    Sinatra::Application
  end
end
 
World{TestWorld.new}
