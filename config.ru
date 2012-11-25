require './app'
require './controllers/users'
require './controllers/ideas'

map "/" do
	run Root
end

map "/user" do
	run Users
end

map "/idea" do
	run Ideas
end