require File.dirname(__FILE__) + '/spec_helper'

describe 'Tron' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'basic test functionality' do 

    it 'should run a single test in test environment' do
      settings.environment.should == :test
    end

    it 'should return OK/200 status' do
      get '/'
      last_response.status.should == 200
    end

  end  # end basic test functionality
end
