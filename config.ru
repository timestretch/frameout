require './app'
require './controllers/user_controller'
require './controllers/idea_controller'
require './controllers/profile_controller'

map "/" do
	run Root
end

map "/user" do
	run UserController
end

map "/profile" do
	run ProfileController
end

map "/idea" do
	run IdeaController
end