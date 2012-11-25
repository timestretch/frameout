require 'rubygems' if RUBY_VERSION < '1.9'
require 'sequel'
require 'digest/md5'
require 'digest/sha2'
require 'bcrypt'

class User < Sequel::Model
	
	def gravatar
		return Digest::MD5.hexdigest(email)
	end
	
	def password=(new_password)
		h = Digest::SHA2.new << new_password
		self.password_hash = BCrypt::Password.create(h.to_s)
	end
	
	def valid_password?(password)
		h = Digest::SHA2.new << password
		hash = BCrypt::Password.new(self.password_hash)
		return (hash == h.to_s)
	end
	
end

class Idea < Sequel::Model
	attr_accessor :username
	attr_accessor :gravatar
	
end

