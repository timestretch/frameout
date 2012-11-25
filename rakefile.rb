require 'rubygems'
require 'rspec/core/rake_task'
require 'rake'

namespace :db do 
	task :migrate do
		`sequel -m data data/database.yml`
	end
	
	task :wipe do
		`sequel -m data data/database.yml -M 0`
	end
end

task :default => :spec
RSpec::Core::RakeTask.new(:spec)