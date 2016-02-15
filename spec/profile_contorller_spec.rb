require 'spec_helper'

# This is the "Users" app controller spec.
# Note all paths are relative to "/user"

describe "Login" do
		
	before do
		Capybara.app = ProfileController
		visit '/login'
	end
	
	it "has a 'Log In' in h3" do
		expect(page).to have_selector('h3', :text => 'Log In')
	end
	
end
