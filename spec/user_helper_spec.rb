require 'spec_helper'

describe UserHelper do
	
	before :each do
		@user_helper = UserHelper.new
	end
	
	it "ensures an email address is valid" do
		valid_emails = ['user@host.com','UsEr55@email.domain.com']
		valid_emails.each do |email|
			expect(@user_helper.email_valid?(email)).not_to eq(nil)
		end
	end
	
	it "ensures an email address is invalid" do
		invalid_emails = ['user_host.com','USER@', '@HOST.COM', '@@domain.com']
		invalid_emails.each do |email|
			expect(@user_helper.email_valid?(email)).to eq(nil)
		end
	end
	
	it "ensures an invalid username is invalid" do
		invalid_usernames = ['user_host.com','USER@', '@HOST.COM', '@@domain.com']
		invalid_usernames.each do |username|
			expect(@user_helper.username_valid?(username)).to eq(nil)
		end
	end
	
	it "ensures a username is valid" do
		invalid_usernames = ['user','user_name', 'user1999', 'user_99']
		invalid_usernames.each do |username|
			expect(@user_helper.username_valid?(username)).not_to eq(nil)
		end
	end
	
end
