# this is mounted on /user
class UserController < App

	def hash_to_html(hash)
		%(<ul>)+
		hash.map do |k,v|
			%(<li>#{h k}) +
				if v.is_a?(Hash) && v != {}
					hash_to_html(v)
				else
					""
				end +
			%(</li>)
		end.join +
		%(</ul>)
	end

	def paths_to_hash(rows)
		rows.inject({}) { |h,i| t = h; i.split(":").each { |n| t[n] ||= {}; t = t[n] }; h }
	end
	
	def format_privileges(rows)
		hash_to_html(paths_to_hash(rows))
	end

	get '/list' do
		if logged_in?
			users = DB["SELECT 
					user.username, 
					date_format(user.created, '%Y-%m-%d') as user_created,
					GROUP_CONCAT(distinct role_name order by role_name) as role_names,
					GROUP_CONCAT(distinct privilege_name order by privilege_name) as privilege_names
				FROM user 
					LEFT JOIN user_role_tie ON user_role_tie.user_id=user.user_id
					LEFT JOIN role ON role.role_id=user_role_tie.role_id
					LEFT JOIN role_privilege_tie ON role_privilege_tie.role_id=role.role_id
					LEFT JOIN privilege ON privilege.privilege_id=role_privilege_tie.privilege_id
				GROUP BY user.user_id
				ORDER BY user.user_id DESC"].map do |row|
					username = row[:username]
					user_created = row[:user_created]
					role_names = row[:role_names]
					privilege_names = format_privileges(row[:privilege_names].split(","))
					
					{
						username: username,
						user_created: user_created,
						role_names: role_names,
						privilege_names: privilege_names
					}	
			end
			body = erb :"user/list", :locals => { users: users }
			render_page("User List", body)
		else
			redirect("/")
		end
	end

end
