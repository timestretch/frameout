require 'app'

# this is mounted on /user
class Users < App

  def login_locals(error = nil)
    return :locals => {
      :email => params[:email],
      :password => params[:password],
      :error => error,
      }
  end

  def register_locals(error = nil)
    return :locals => {
      :email => params[:email],
      :password => params[:password],
      :password2 => params[:password2],
      :error => error,
      }
  end

  get '/' do
    render_page("Users", "Users")
  end

  get '/login' do
    body = erb :"user/login", login_locals
    render_page("Login", body)
  end

  post '/login' do
    user_helper = UserHelper.new(db)
    email = user_helper.login(params, request.ip)
    if email
      session[:user_email] = email
      redirect '/user/profile'
    else
      body = erb :"user/login", login_locals("The username or password was incorrect.")
      render_page("Login", body)
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/register' do
    body = erb :"user/register", register_locals
    render_page("Login", body)
  end

  post '/register' do
    user_helper = UserHelper.new(db)
    error = user_helper.register(params, request.ip)
    if error
      body = erb :"user/register", register_locals(error)
      render_page("Register", body)
    else
      redirect("/user/profile")
    end
  end

# These methods are only available to logged in users....
  get '/profile' do
    if logged_in?
      body = erb :"user/profile", :locals => { 
          :user_email => current_user,
					:ip_addr => UserHelper.new(db).last_login_ip_for_email(current_user) }
      render_page("Profile", body)
    else
      redirect("/")
    end
  end

end
