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
	
	def register(params, ip)
	
		return "Please enter a valid email address" if !params[:email]
		
		if email_registered?(params[:email])
			return "Sorry, the email you provided is already in use." 
		end
		
		return "Please choose a password 6 characters, or greater in length." if params[:password].length < 6
		return "The passwords did not match. Please retype them." if params[:password] != params[:password2] 
		
		begin
      # Hash the password before running through bcrypt.
      # When checking passwords sent from iOS apps, sha-256 before transmitting.
			h = Digest::SHA2.new << params[:password]
			hash = BCrypt::Password.create(h.to_s)
			
			statement = @db.prepare "INSERT INTO user SET
				email=?,
				password_hash=?,
				created=now(),
				last_login_ip=INET_ATON(?)"
			
			statement.execute(params[:email], hash.to_s, ip)
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
