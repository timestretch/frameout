Sequel.migration do

	up do
		alter_table(:user) do
			add_column :api_token, String, :size => 36
		end
	end

end