require 'spec_helper'

describe UserHelper do
	
	before :each do
		@user_helper = UserHelper.new
	end
	
	it "ensures an email address is valid" do
		valid_emails = ['user@host.com','UsEr55@email.domain.com']
		valid_emails.each do |email|
			@user_helper.email_valid?(email).should_not eq(nil) 
		end
	end
	
	it "ensures an email address is invalid" do
		invalid_emails = ['user_host.com','USER@', '@HOST.COM', '@@domain.com']
		invalid_emails.each do |email|
			@user_helper.email_valid?(email).should eq(nil) 
		end
	end
	
end
