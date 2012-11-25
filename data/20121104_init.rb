class BaseSchema < Sequel::Migration

	def up
		create_table! :users, :charset  => "utf8" do
			primary_key :user_id
			
			String :email, :unique => true
			String :username, :unique => true
			
			String :password_hash
			Time :created
			Int :last_login_ip, :unsigned => true
		end
		
		create_table! :ideas, :charset => "utf8" do
			primary_key :idea_id
			String :short_description
			Text :long_description
			Int :public
			Time :created
			foreign_key :created_by_user_id, :users, :key => :user_id
		end
		
	end

	def down
		drop_table :ideas
		drop_table :users
	end

end