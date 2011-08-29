#require 'rubygems'

require 'sinatra'

#require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'dm-postgres-adapter'
require 'dm-sqlite-adapter'
require 'rack-flash'
require 'digest/sha1'
require 'date' 
require 'dm-validations'
require 'pony'

configure :development do
  require "sinatra/reloader"
end


enable :sessions
use Rack::Flash

configure :development do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/plan.sqlite3")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/plan.sqlite3")
end


configure :test do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/plan.test.sqlite3")
end

class Plan
  include DataMapper::Resource

  property :id,         Serial    # An auto-increment integer key
  property :task,       String    # A varchar type string, for short strings
  property :planned_on, DateTime  # A DateTime, for any date you might like.
  property :status,     Integer   # status of planned task
  belongs_to :user
  
end

class Did
  include DataMapper::Resource
  
  property :id,         Serial
  property :task,       String
  property :done_on,    DateTime
  belongs_to :user
  
end

class User
  include DataMapper::Resource
  
  property :id,         Serial
  property :username,   String, :required => true, :unique => true
  property :password,   String, :required => true
  property :first_name, String, :required => true
  property :last_name,  String, :required => true
  property :email,      String, :required => true, :unique => true, :format => :email_address
  
  validates_length_of :password, :min => 1
  
  has n, :dids
  has n, :plans

end

configure :development do 
  DataMapper.auto_upgrade!
end

before do
  @current_user = session['user_id']
  @current_user = 0 if @current_user == nil  
  #logout if @current_user == 0
  @user = User.get(@current_user) unless @current_user == 0
end

def logout
  @current_user = 0
  session['user_id'] = 0
end

get '/' do

  @current_user = session['user_id']
  @current_user = 0 if @current_user == nil  
  #logout if @current_user == 0
  @user = User.get(@current_user) unless @current_user == 0

  if @current_user == nil or @current_user == 0
    erb :greeting
  else
    @user = User.get(@current_user)
    this_day = Date.today
    tomorrow = this_day + 1
    #x = DateTime.now
    @y = DateTime.new(this_day.year, this_day.month, this_day.day, 3, 0, 0, 0)
    #x = DateTime.now
    y2 = DateTime.new(tomorrow.year, tomorrow.month, tomorrow.day, 2, 59, 59, 0)
    
    @plans = Plan.all(:conditions => {:planned_on => (@y..y2), :user_id => @current_user}, :order => [ :planned_on.asc ])
    @dids  = Did.all(:conditions => {:done_on => (@y..y2), :user_id => @current_user}, :order => [ :done_on.asc ])
    
    erb :index
  end
end

get '/history/:days' do

  if @current_user < 1
    erb :greeting
  else
    #@user = User.get(@current_user)
    @plans = Hash.new
    @dids  = Hash.new
    
    days_old = params[:days]
    
    dtnow = DateTime.now
    dnow = Date.new(dtnow.year, dtnow.month, dtnow.day)
    0.upto(days_old.to_i) { |i| 
    
      this_day = Date.today - i
      next_day = this_day + 1
      @y = DateTime.new(this_day.year, this_day.month, this_day.day, 3, 0, 0, 0)
      @y2 = DateTime.new(next_day.year, next_day.month, next_day.day, 2, 59, 59, 0)

      ps = Plan.all(:conditions => {:planned_on => (@y..@y2), :user_id => @current_user}, :order => [ :planned_on.asc ])
      ds = Did.all(:conditions => {:done_on => (@y..@y2), :user_id => @current_user}, :order => [ :done_on.asc ])
      
      @plans.merge!({ this_day , ps })
      @dids.merge!({ this_day , ds })
    }
        
     @plans = @plans.sort.reverse
     #@dids  = @dids.sort
        
        
    erb :history
  end
end

get '/greeting/?' do
  erb :greeting
end

 
post '/plan/' do
  x = DateTime.now
  y = DateTime.new(x.year, x.month, x.day, x.hour, x.min, x.sec, x.sec_fraction)
  task = params[:task]
  plan = Plan.create(:task => task, :planned_on => y, :status => 0, :user_id => @current_user)
  @plans = Plan.all
  redirect '/'
end

get '/did/:id' do |id|
  plan = Plan.get(id)
  
  if plan != nil 
    if plan.user_id == @current_user
      plan.status = 1
      plan.save
      
      x = DateTime.now
      y = DateTime.new(x.year, x.month, x.day, x.hour, x.min, x.sec, 0)
      
      did = Did.create(:task => plan.task, :done_on => y, :user_id => @current_user)
    else
      flash[:error] = "Only your own plans please!"
    end
  else  
    flash[:error] = "no record for that plan. sorry."
  end
  redirect '/'
end

post '/did/' do
  day = Date.today
  x = DateTime.now
  y = DateTime.new(x.year, x.month, x.day, x.hour, x.min, x.sec, 0)
      
  did = Did.create(:task => params[:task], :done_on => y, :user_id => @current_user)

  redirect '/'
end

post '/login/?' do
  u = params[:username] if params[:username]
  p = Digest::SHA1.hexdigest(params[:pswd]) if params[:pswd]
  
  user = User.first(:username => u)
  
  if user
    if user.password == p
      session['user_id'] = user.id
      @current_user = user.id
      @user = User.get(user.id)
 
      flash[:notice] = "Login Successfull! Hello, #{user.first_name} #{user.last_name}"
    else
      #logout
      flash[:error] = "Login Failure!"
    end
  else
    flash[:error] = "Login Failure! No info for user name '#{u}'."
  end
   
  redirect '/'

end

get '/logout/?' do
  logout
  #@current_user = 0
  #session['user_id'] = 0
  
  flash[:notice] = "Logout Successful!"
  
  redirect '/'
end

post '/reg/' do
  ps_crypt = Digest::SHA1.hexdigest(params[:pswd])
  
  if params[:pswd].length == 0
    flash[:error] = "Enter a valid password!"
    redirect '/profile/'
    return
  end
  
  if @current_user == 0   # new user registration
    if user = User.create(:first_name => params[:first_name], 
                          :last_name  => params[:last_name],
                          :username   => params[:username],
                          :password   => ps_crypt,
                          :email      => params[:email])
    
      session['user_id'] = user.id
      @current_user = user.id
      @user = User.get(user.id)
      
      #SendNewUserNotice("#{params[:first_name]} #{params[:last_name]}: #{params[:email]}") unless test?
      flash[:notice] = "Hello, #{params[:first_name]}. Registration successful."
    else
      flash[:error] = User.errors.first
    end 
  else     # edit of existing user profile
  
    user = User.get(@current_user)
    
    user.first_name = params[:first_name]
    user.last_name  = params[:last_name] 
    user.password   = ps_crypt
    user.email      = params[:email]
    user.username   = params[:username]
    if user.save 
      flash[:notice] = "Profile update successful"
    else
      flash[:error] = user.errors.first
    end 
  end 
  
  redirect '/'
end

get '/profile/?' do
  if @current_user > 0
    erb :profile
  else
    erb :greeting
  end
end

get '/users/?' do
  if @user != nil && @user.username == 'gspeake'
    @users = User.all
    erb :user
  else
    flash[:error] = "i don't think so!"
    redirect '/'  
  end
end 

get '/users/:id/delete/?' do
  if @user != nil && @user.username == 'gspeake'
    u = User.get(params[:id])
    u.destroy
    redirect '/users/'
  else
    flash[:error] = "i don't think so!"
    redirect '/'
  end
end

get '/about/?' do 
  erb :about
end

=begin
get '/fixup/' do
  
  @dids = Did.all( :order => [ :done_on.asc ])

  @dids.each do | did |
    x = did.done_on
    if x.hour == 0
   
      y = DateTime.new(x.year, x.month, x.day, x.hour + 4, x.min, x.sec, 0)
      did.done_on = y
      did.save
    end
  
  end

  erb :fixup
end
=end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  
  def DayOfWeek(date)

   day_of_week = case date.wday
      when 0 then "Sunday"
      when 1 then "Monday"
      when 2 then "Tuesday"
      when 3 then "Wednesday"
      when 4 then "Thursday"
      when 5 then "Friday"
      when 6 then "Saturday"
      else "unknown day"
    end

    return day_of_week
  end
  
  def SendNewUserNotice(username)
  
    Pony.mail(:to      => 'george.speake@gmail.com', 
              :from    => 'george.speake@gmail.com',
              :subject => 'new plan_did user', 
              :body    => "A new user just registered for a plan_did account: #{username}", 
              :via => :smtp, 
              :via_options => {
                             :address        => 'smtp.gmail.com',
                             :port           => '587',
                             :user_name      => 'george.speake',
                             :password       => 'XXXXXX',
                             :authentication => :plain,
                             :domain         => 'localhost.localdomain'
    })
  end
  
end

not_found do
  "not found error"
end

error do
  #"error found #{request.env['sinatra_error'].message}"
  logout
  flash[:error] = env['sinatra_error'].name if env['sinatra_error']
  redirect '/'
end

