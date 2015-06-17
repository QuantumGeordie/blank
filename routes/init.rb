get '/styles.css' do
  scss :'styles/application'
end

require File.dirname(__FILE__) + '/index.rb'
require File.dirname(__FILE__) + '/dummy.rb'
require File.dirname(__FILE__) + '/api_endpoint.rb'
