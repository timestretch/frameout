require 'spec_helper'

# This is the "Root" app controller spec.

describe "Home page" do
	subject { page }
	describe "should have title 'Home'" do
		before do
			Capybara.app = Root
			visit '/'
		end
        it { should have_selector('h3', :text => 'Home') }
        it { should have_selector('title', :text => 'Home') }
	end
end
