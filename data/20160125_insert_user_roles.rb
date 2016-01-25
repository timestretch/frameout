Sequel.migration do

	up do
		now = Time.now

		self[:privilege].insert(
			privilege_id: 1,
			privilege_name: "User:View Users",
			created: now
		)
		
		self[:privilege].insert(
			privilege_id: 2,
			privilege_name: "User:Add Users",
			created: now
		)
		
		self[:role].insert(
			role_id: 1,
			role_name: "admin",
			created: now
		)
		
		self[:role_privilege_tie].insert(
			role_privilege_tie_id: 1,
			role_id: 1,
			privilege_id: 1,
			created: now
		)
		
		self[:role_privilege_tie].insert(
			role_privilege_tie_id: 2,
			role_id: 1,
			privilege_id: 2,
			created: now
		)

	end


end