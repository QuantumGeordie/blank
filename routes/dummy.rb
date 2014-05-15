get '/flash_message/:type' do

  case params[:type]
  when 'error'
    flash[:error] = 'oh yeah! you just errored all over the place!'
  when 'success'
    flash[:success] = 'that was very successful.'
  when 'notice'
    flash[:notice] = 'i am here to notify you with a flash message.'
  else
    # there must not be a flash message.
  end

  redirect to '/'
end

post '/flash' do
  ## curl --data "msg=booty itcher" http://127.0.0.1:9393/flash
  puts "flash message = #{params[:msg]}"
end
