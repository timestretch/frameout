Sequel.migration do

	up do
		now = Time.now

		# Admin role and default privileges
		self[:role].insert(
			role_id: 1,
			role_name: "admin",
			created: now
		)

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
		
		# User role and privileges
		self[:role].insert(
			role_id: 2,
			role_name: "user",
			created: now
		)

		self[:privilege].insert(
			privilege_id: 3,
			privilege_name: "Profile:View Profile",
			created: now
		)

		self[:privilege].insert(
			privilege_id: 4,
			privilege_name: "Profile:Change Password",
			created: now
		)
		
		# Insert the admin ties
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
		
		self[:role_privilege_tie].insert(
			role_privilege_tie_id: 3,
			role_id: 1,
			privilege_id: 3,
			created: now
		)
		
		self[:role_privilege_tie].insert(
			role_privilege_tie_id: 4,
			role_id: 1,
			privilege_id: 4,
			created: now
		)

		# user role ties
		
		self[:role_privilege_tie].insert(
			role_privilege_tie_id: 5,
			role_id: 2,
			privilege_id: 3,
			created: now
		)
		
		self[:role_privilege_tie].insert(
			role_privilege_tie_id: 6,
			role_id: 2,
			privilege_id: 4,
			created: now
		)


	end


end