
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
		idea = Idea.new
		body << (erb :"idea/form", :locals => {:idea => idea})
		render_page("New Idea", body)
	end

	def can_edit_idea?(idea)
		return true if idea.created_by_user_id == user_model.user_id
		false		
	end
	
	get '/edit/:idea_id' do
		
		idea = Idea[:idea_id => params[:idea_id]]
		
		if idea && !can_edit_idea?(idea)
			return error("Sorry, you don't have permissions to edit this idea.")
		end

		if !idea
			return error("Sorry, that idea could not be retrieved.")
		end
				
		body = erb :"idea/header"
		body << (erb :"idea/form", :locals => {:idea => idea})
		render_page("Editing Idea", body)
		
	end

	def delete(idea)
		idea.delete
		idea.save
	end

	post '/save' do

		idea = Idea[:idea_id => params[:idea_id]]
		if idea && !can_edit_idea?(idea)
			return error("Sorry, you don't have permissions to edit this page.")
		end
		
		if params[:action] == "Delete"
			delete(idea)
			redirect "/idea/list/"
		end
		
		if !idea
			idea = Idea.new
		end
		
		idea.public = params[:public] ? 1 : 0
		idea.short_description = params[:short_description]
		idea.long_description = params[:long_description]
		idea.created = Time.now
		idea.created_by_user_id = user_model.user_id
		idea.save

		redirect "/idea/list/"
	end
	
	get '/list/:filter?' do
	
		where = ''
		where = " OR idea.public=1" if params[:filter] == "all"
		
		# Fixme: this SQL is pretty lame
		ideas = DB["SELECT idea.*, username FROM idea 
		LEFT JOIN user on idea.created_by_user_id=user.user_id
			WHERE created_by_user_id=? #{where}", user_model.user_id]

		header = erb :"idea/header"
		body = erb :"idea/list", :locals => {"user_model"=>user_model, "ideas"=>ideas}
		render_page("Idea", header + body)
	end

end
