ENV['RACK_ENV'] = 'test'

require 'bundler'
Bundler.setup(:default, :test)

require 'capybara'
require 'capybara/dsl'
require 'minitest/autorun'
require 'rack/test'
require 'active_support/dependencies'
require 'mocha/mini_test'
require 'mocha/setup'

require File.expand_path '../../app.rb', __FILE__
require File.expand_path '../page_objects', __FILE__

Capybara.default_driver = :selenium

class SeleniumTest < MiniTest::Test
  include Rack::Test::Methods
  include Capybara::DSL

  def app
    Sinatra::Application
  end

  def setup
    Capybara.app = app
  end
end
