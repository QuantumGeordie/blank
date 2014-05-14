get '/' do
  @random_number = RandomNumberGenerator::generate_random_number(1000)
  @current_route = request.path_info

  erb :index
end
