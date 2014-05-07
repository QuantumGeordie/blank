require 'bundler'
Bundler.setup(:default)

require 'sinatra'
require 'sinatra/flash'

enable :sessions
set :session_secret, 'rockthecasbah'

Dir["lib/**/*.rb"].each { |file| require File.expand_path file }

require File.dirname(__FILE__) + '/routes/init.rb'
require File.dirname(__FILE__) + '/models/init.rb'
