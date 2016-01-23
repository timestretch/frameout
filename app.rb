# By Erik Wrenholt 2012

require 'rubygems' if RUBY_VERSION < '1.9'
require 'sinatra'
require 'erb'

require './data/init'
require './data/models'

# Constants for Database Config and Site Name, Byline are in 'config.rb'
require './config'

# This class actually has no routes of its own (except for things like 'not_found')
# It exists as a common point of inheritence, to hold certain universal settings
# and helpers.

class App < Sinatra::Base

	enable :sessions

	# Sinatra's sessions are signed by default, with a HMAC algorithm, which is
	# the correct way to sign data so that it can be verified later.
	set :session_secret, SITE_SECRET_KEY

	helpers do
		def h(text)
			Rack::Utils.escape_html(text)
		end
	end

	def render_page(title, body)
		
		# header
		header = erb :"main/header", :locals => {
			:site_name => SITE_NAME,
			:current_class => self.class.to_s,
			:controllers => controller_list
		}
		
		# footer
		footer = erb :"main/footer", :locals => {
			:by_line => "&copy; #{Time.now.year} #{SITE_BY_LINE}",
		}

		# Main layout
		erb :"main/layout", :locals => {
			:header => header,
			:footer => footer,
			:title => title,
			:body => body,
		}
	end

	# Render an error page.
	def error(error)
		halt 403, render_page("Error", "<div class=\"error\">" + error + "</div>")
	end

	# Fixme: it would be better to have each controller register its own tab and info.
	def controller_list
		[{'url'=>'/user/profile', 'title'=>'Profile', 'class'=>'Users'},
				{'url'=>'/idea/list/', 'title'=>'Ideas', 'class'=>'Ideas'}]
	end

	def current_user
		session[:username]
	end
	
	def user_model
		@user_model ||= User[:username => current_user]
	end

	def logged_in?
		current_user ? true : false
	end

	not_found do
		render_page("Page not found!", "Sorry, the page you requested was not found!")
	end

end

class Root < App
# Non-secured methods....
	get '/?' do
		if current_user
			redirect '/user/profile'
		else
			body = erb :"pages/home"
			render_page("Home", body)
		end
	end
end
