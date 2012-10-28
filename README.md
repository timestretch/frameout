Frameout
--------

A simple Sinatra based example to register, login, and view a profile.

Install
-------

Create the required database.

	$ mysql -u root
	mysql> create database frameout;
	mysql> quit
	
	$ mysql -u root frameout < private/sql/main.sql
	
	$ sudo gem install shotgun
	$ shotgun config.ru

Source Code
-----------

Start with "config.ru". Each controller must be loaded here. Rack directs routes starting with a particular prefix to the appropriate controller. 

The base class and some useful helper utilities are in "app.rb". The configuration variables used in app.rb are in config.rb. Templates are located in the "views" directory. Each controller has its own subdirectory. The login views are present in the "user" sub-directory.

To-Do
-----

- Switch to an ORM such as ActiveRecord or Sequel.
- Unit Tests
- Clean up repeated erb template code.
- Email validation when registering
- Add some admin-only user management functionality.
- Try Sequel Prepared statements.
- Implement "fetch_hash" to ruby-mysql prepared statement results.

Thanks
------

- namelessjon helped me break things up, refactor, and explain sessions.