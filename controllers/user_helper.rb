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

	# From http://blog.sosedoff.com/2009/04/16/inet_ntoa-and-inet_aton-in-ruby/
	def inet_aton(ip)
	    ip.split(/\./).map{|c| c.to_i}.pack("C*").unpack("N").first
	end
 
	def inet_ntoa(n)
	    [n].pack("N").unpack("C*").join "."
	end
	
	# based on the html5 regex presented here:
	# http://www.w3.org/TR/html5/states-of-the-type-attribute.html#e-mail-state
	def email_valid?(email)
		return email.match /^[a-zA-Z0-9\.\!\#\$\%\&\'\*\+\/\=\?\^\_\`\{\|\}\~\-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/
	end
	
	# Contains only lowercase letters and underscores
	def valid_username?(username)
		return username.match(/^[0-9a-z_]+$/)
	end
	
	# Return nil on success, or the error string.
	def register(params, ip)
	
		email = params[:email]
		username = params[:username]
		
		return "Please enter a valid email address" if !email_valid?(email)
		return "Please enter a valid username" if !valid_username?(username)
		
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
			last_login_ip = inet_aton(ip)
			user.save
			
			return nil
		rescue
			"There was an error creating your account. Please try again later."
		end
		
	end
	
	def last_login_for_user(user)
		begin
			return inet_ntoa(user.last_login_ip)
		rescue
			return "Never logged in"
		end
	end
	
	# Login and verify password BCrypt hash.
	def login(params, ip)
	
		user = User[:email => params[:email]]
		return nil if !user
		
		if user.valid_password?(params[:password])
			user.last_login_ip = inet_aton(ip)
			user.save
			return user.username
		end
		return nil
	end
	
	def change_password(user, params, ip)
		return "Please choose a password 6 characters, or greater in length." if params[:new_password].length < 6
		return "The passwords did not match. Please retype them." if params[:new_password] != params[:new_password2] 
		return "Sorry, your password is incorrect." if !user.valid_password?(params[:password])
		user.password = params[:new_password]
		user.save
		return nil
	end
	
end
