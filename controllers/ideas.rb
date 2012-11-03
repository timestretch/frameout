require 'app'

# This will be mounted on /idea
class Ideas < App

	# Make sure we are authenticated before accessing this area.
	before do
		redirect '/user/login' if !logged_in?
	end
	
	get '/' do
		redirect '/idea/list'
	end

	get '/new' do
		body = erb :"idea/header"
		body << (erb :"idea/form", :locals => {
			:idea_id => 0,
			:public => 0,
			:created => nil,
			:short_description => "", 
			:long_description => ""})
		render_page("New Idea", body)
	end

	def can_edit_idea(idea_id = 0)
		return true if idea_id.to_i <= 0
		query = "SELECT * FROM idea where idea_id='#{idea_id.to_i}' 
			and created_by_user_id=(SELECT user_id FROM user WHERE email='%s')" % [db.escape_string(current_user)]
		res = db.query(query)
		return res.num_rows > 0
	end
	
	get '/edit/:idea_id' do
		
		idea_id = params[:idea_id]
		if idea_id && !can_edit_idea(idea_id)
			return error("Sorry, you don't have permissions to edit this page.")
		end
		
		query = "SELECT idea.* FROM idea where idea_id='#{idea_id.to_i}'"
		res = db.query(query)
		idea_hash = res.fetch_hash
		
		body = erb :"idea/header"
		body << (erb :"idea/form", :locals => idea_hash)
		render_page("Editing Idea", body)
		
	end

	def delete(idea_id)
		query = "delete from idea where idea_id='#{idea_id.to_i}'"
		res = db.query(query)
	end

	post '/save' do
		
		idea_id = params[:idea_id]
		if idea_id && !can_edit_idea(idea_id)
			return error("Sorry, you don't have permissions to edit this page.")
		end
		
		if params[:action] == "Delete"
			delete(params[:idea_id])
			redirect "/idea/list/"
		end
		
		method = "INSERT"
		where = ''
		
		if idea_id && idea_id.to_i > 0
			method = "UPDATE"
			where = "WHERE idea_id='#{idea_id.to_i}'"
		end
		
		if params[:public]
			public = 1
		else
			public = 0
		end
		
		query = "#{method} idea SET 
			short_description='%s', 
			long_description='%s',
			public='%d',
			created=now(),
			created_by_user_id=(select user_id from user where email='%s')
			#{where}
			" % [
				db.escape_string(params[:short_description]), 
				db.escape_string(params[:long_description]),
				public,
				db.escape_string(current_user)
			]
		
		puts query
			
		db.query(query)
		redirect "/idea/list/"
	end
	
	get '/list/:filter?' do
		where = 'OR 0'
		where = " OR idea.public=1" if params[:filter] == "all"
		
		# Fixme: this SQL is pretty lame
		query = "SELECT idea.*, email FROM idea 
		LEFT JOIN user on idea.created_by_user_id=user.user_id
			WHERE (created_by_user_id=(SELECT user_id FROM user WHERE email='%s') #{where})" % [db.escape_string(current_user)]

		res = db.query(query)
		ideas = []
		while row = res.fetch_hash
			ideas << row
		end
		
		header = erb :"idea/header"
		body = erb :"idea/list", :locals => {"current_user"=>current_user, "ideas"=>ideas}
		render_page("Idea", header + body)
	end

end
