require 'spec_helper'

# This is the "Users" app controller spec.
# Note all paths are relative to "/user"

describe "Login" do
	subject { page }
	describe "should have title 'Login'" do
		before do
			Capybara.app = Users
			visit '/login'
		end
		it { should have_selector('h3', :text => 'Login')}
	end
end
