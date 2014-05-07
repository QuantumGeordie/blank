get '/' do
  @random_number = rand(1000).to_s
  erb :index
end

