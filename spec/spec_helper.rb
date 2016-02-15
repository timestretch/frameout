# FIXME: switch to require_relative 

root_dir = File.dirname(__FILE__)
require File.join(root_dir, '../app.rb')
require File.join(root_dir, '../controllers/profile_controller.rb')
require File.join(root_dir, '../helpers/user_helper.rb')
require File.join(root_dir, '../data/init.rb')

require 'capybara/rspec'
require 'capybara/dsl'

RSpec.configure do |config|
	config.include Capybara::DSL
end
