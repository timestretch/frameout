require 'digest/sha2'
require 'bcrypt'

class UserHelper
  
	def initialize(db)
		@db = db
	end
	
	def email_registered?(email)
		statement = @db.prepare "SELECT * FROM user where email=?"
		statement.execute email
		result = statement.fetch
		if result && result.count > 0
			return true
		end
		return false
	end
	
	# based on the html5 regex presented here:
	# http://www.w3.org/TR/html5/states-of-the-type-attribute.html#e-mail-state
	def email_valid?(email)
		return email.match /^[a-zA-Z0-9\.\!\#\$\%\&\'\*\+\/\=\?\^\_\`\{\|\}\~\-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/
	end
	
	# Return nil on success, or the error string.
	def register(params, ip)
	
		email = params[:email]
		return "Please enter a valid email address" if !email_valid?(email)
		
		if email_registered?(email)
			return "Sorry, the email you provided is already in use." 
		end
		
		return "Please choose a password 6 characters, or greater in length." if params[:password].length < 6
		return "The passwords did not match. Please retype them." if params[:password] != params[:password2] 
		
		begin
			# Hash the password before running through bcrypt.
			# Can always sha-256 before transmitting.
			h = Digest::SHA2.new << params[:password]
			hash = BCrypt::Password.create(h.to_s)
			
			statement = @db.prepare "INSERT INTO user SET
				email=?,
				password_hash=?,
				created=now(),
				last_login_ip=INET_ATON(?)"
			
			statement.execute(email, hash.to_s, ip)
			return nil
		rescue
			"There was an error creating your account. Please try again later."
		end
		
	end
	
	def last_login_ip_for_email(email)
		begin
			res = @db.query("SELECT INET_NTOA(last_login_ip) as ip_addr 
        FROM user where email='%s'" % @db.escape_string(email))
			row = res.fetch_hash 
			return row['ip_addr']
		rescue
			return "Never logged in"
		end
	end
	
	# Login and verify password BCrypt hash.
	def login(params, ip)
	
		res = @db.query("SELECT email, password_hash 
      FROM user where email='%s'" % @db.escape_string(params[:email]))
	
		while row = res.fetch_hash 
			
			email = row['email']
			password_hash = row['password_hash']
			
			h = Digest::SHA2.new << params[:password]
			hash = BCrypt::Password.new(password_hash)
      
			if hash == h.to_s
				statement = @db.prepare "UPDATE user SET last_login_ip=INET_ATON(?)"
				statement.execute ip
				return email
			end
		
		end
		
		return nil
	end
	
end
