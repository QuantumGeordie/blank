require 'json'

get '/api/:key/:value/?' do
  @key   = params.fetch('key', 'none')
  @value = params.fetch('value', 0)
  if request.xhr?
    {'key' => @key, 'value' => @value}.to_json
  else
    erb :api
  end
end
