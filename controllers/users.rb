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
			:username => params[:username],
			:password => params[:password],
			:password2 => params[:password2],
			:error => error,
			}
	end
	
	def change_pass_locals (error = nil)
		return :locals => {
			:password => params[:password],
			:new_password => params[:new_password],
			:new_password2 => params[:new_password2],
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
		user_helper = UserHelper.new
		username = user_helper.login(params, request.ip)
		if username
			session[:username] = username
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
		render_page("Register", body)
	end

	post '/register' do
		user_helper = UserHelper.new
		error = user_helper.register(params, request.ip)
		if error
			body = erb :"user/register", register_locals(error)
			render_page("Register", body)
		else
			session[:username] = user_helper.login(params, request.ip)
			redirect("/user/profile")
		end
	end
	
	get '/change_password' do
		body = erb :"user/change_password", change_pass_locals
		render_page("Change Password", body)
	end
	
	post '/change_password' do
		user = user_model
		user_helper = UserHelper.new
		error = user_helper.change_password(user, params, request.ip)
		if error
			body = erb :"user/change_password", change_pass_locals(error)
			render_page("Change Password", body)
		else
			redirect("/user/profile")
		end
	end

# These methods are only available to logged in users....
	get '/profile' do
		if logged_in?
			user = User[:username=>current_user]
			body = erb :"user/profile", :locals => { 
					:gravatar => user.gravatar,
					:username => user.username,
					:ip_addr => UserHelper.new.last_login_for_user(user) }
			render_page("Profile", body)
		else
			redirect("/")
		end
	end

end
