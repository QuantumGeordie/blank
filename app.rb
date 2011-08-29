require 'bundler'
Bundler.setup(:default)

require 'sinatra'
require 'rack-flash'

enable :sessions
use Rack::Flash

#Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
#Dir[File.dirname(__FILE__) + '/routes/*.rb'].each {|file| require file }

require File.dirname(__FILE__) + '/routes/init.rb'
require File.dirname(__FILE__) + '/models/init.rb'
