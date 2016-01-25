# Users controller makes use of this
class UserHelper
  
	def email_registered?(email)
		user = User[:email => email]
		return user ? true : false
	end
	
	def username_registered?(username)
		user = User[:username => username]
		return user ? true : false
	end
	
	# based on the html5 regex presented here:
	# http://www.w3.org/TR/html5/states-of-the-type-attribute.html#e-mail-state
	def email_valid?(email)
		email.match(/^[a-zA-Z0-9\.\!\#\$\%\&\'\*\+\/\=\?\^\_\`\{\|\}\~\-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/)
	end
	
	# Contains only lowercase letters and underscores
	def username_valid?(username)
		username.match(/^[0-9a-z_]+$/)
	end
	
	# Return nil on success, or the error string.
	def register(params, ip)
	
		email = params[:email]
		username = params[:username]
		
		return "Please enter a valid email address" if !email_valid?(email)
		return "Please enter a valid username" if !username_valid?(username)
		return "Please enter a username that is less than 25 characters" if username.length > 25
		
		if email_registered?(email)
			return "Sorry, the username you provided is already in use." 
		end
		
		if username_registered?(username)
			return "Sorry, the email you provided is already in use." 
		end
		
		return "Please choose a password 6 characters, or greater in length." if params[:password].length < 6
		return "The passwords did not match. Please retype them." if params[:password] != params[:password2] 
		
		begin
			user = User.new
			user.username = username
			user.email = email
			user.password = params[:password]
			user.created = Time.now
			user.login_ip = ip
			user.save

			# Make the first user we create an admin
			if user && user.user_id == 1
				DB[:user_role_tie].insert(
					user_id: 1,
					role_id: 1,
					created: Time.now
				)
			end
			return nil
		rescue Sequel::Error => ex
			"There was an error creating your account. Please try again later. #{ex}"
		end
		
	end
	
	def last_login_for_user(user)
		begin
			return user.login_ip
		rescue
			return "Never logged in"
		end
	end
	
	# Login and verify password BCrypt hash.
	def login(params, ip = nil)
	
		user = User[:email => params[:email]]
		return nil if !user
		
		if user.valid_password?(params[:password])
			user.login_ip = ip if ip
			user.save
			return user.username
		end
		nil
	end
	
	def change_password(user, params, ip)
		return "Sorry, your password is incorrect." if !user.valid_password?(params[:password])
		return "Please choose a password 6 characters, or greater in length." if params[:new_password].length < 6
		return "The passwords did not match. Please retype them." if params[:new_password] != params[:new_password2] 
		user.password = params[:new_password]
		user.save
		nil
	end
	
end
