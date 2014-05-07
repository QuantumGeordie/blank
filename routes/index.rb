get '/' do
  @random_number = RandomNumberGenerator::generate_random_number(1000)
  erb :index
end
