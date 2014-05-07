get '/styles.css' do
  scss :styles
end

require File.dirname(__FILE__) + '/index.rb'
