Sequel.migration do

	up do
		create_table! :privilege, :charset  => "utf8" do
			primary_key :privilege_id
			String :privilege_name, :unique => true
			Time :created
		end
		
		create_table! :role, :charset => "utf8" do
			primary_key :role_id
			String :role_name
			Time :created
		end
		
		create_table! :role_privilege_tie, :charset => "utf8" do
			primary_key :role_privilege_tie_id
			foreign_key :role_id, :role, :key => :role_id
			foreign_key :privilege_id, :privilege, :key => :privilege_id
			Time :created
			Time :updated
		end
		
		create_table! :user_role_tie, :charset => "utf8" do
			primary_key :user_role_tie_id
			foreign_key :user_id, :user, :key => :user_id
			foreign_key :role_id, :role, :key => :role_id
			Time :created
			Time :updated
		end
		
	end

	down do
		drop_table :privilege
		drop_table :role
		drop_table :role_privilege_tie
		drop_table :user_role_tie
	end

end