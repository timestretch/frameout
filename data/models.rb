require 'rubygems' if RUBY_VERSION < '1.9'
require 'sequel'
require 'digest/md5'
require 'digest/sha2'
require 'bcrypt'
require './helpers/inet_ip'

class User < Sequel::Model(:user)
	
	attr_accessor :login_ip

	def gravatar
		Digest::MD5.hexdigest(email)
	end
	
	def password=(new_password)
		h = Digest::SHA2.new << new_password
		self.password_hash = BCrypt::Password.create(h.to_s)
	end
	
	def valid_password?(password)
		h = Digest::SHA2.new << password
		hash = BCrypt::Password.new(self.password_hash)
		(hash == h.to_s)
	end
	
	def login_ip=(ip)
		@login_ip = ip
		self.last_login_ip = InetIp::inet_aton(ip)
	end
	
	def login_ip
		@login_ip ||= InetIp::inet_ntoa(self.last_login_ip)
	end
	
	def to_json
		super(:except => [:password_hash, :last_login_ip], :include => :login_ip)	
	end
end

class Idea < Sequel::Model(:idea)
	attr_accessor :username
	attr_accessor :gravatar
	
end

