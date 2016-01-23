require 'spec_helper'

# This is the "Root" app controller spec.

describe "Home page" do
	before do
		Capybara.app = Root
		visit '/'
	end
	it "check h3 tag" do
		expect(page).to have_selector('h3', :text => 'Home')
	end
	it "check title tag" do
		expect(page.title).to eq("Home")
	end
end
