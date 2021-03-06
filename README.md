Frameout
--------

A simple Sinatra based example to register, login, and view a profile. It uses MySQL, and Sequel ORM. This example shows one way to separate your code into multiple controllers with Sinatra.

Install
-------

Create database tables.

	$ mysql -u root
	mysql> create database frameout;
	mysql> quit
	
	$ rake db:migrate

Run the unit tests with "rake" or "rake spec".

	$ rake
	$ rake spec

Test with shotgun.

	$ sudo gem install shotgun
	$ shotgun config.ru

Source Code
-----------

Each controller must be added to the config.ru rackup file. Rack directs routes starting with a particular prefix to the appropriate controller. 

The base class and some useful helper utilities are in "app.rb". The configuration variables used in app.rb are in config.rb. Templates are located in the "views" directory. Each controller has its own subdirectory for erb templates. The login views are present in the "user" sub-directory.

To-Do
-----

- Forgot / reset Password link.
- Find a good way to unit-test controllers
- Clean up repeated erb template code.
- Add some admin-only user management functionality.
- Try Sequel Prepared statements.
- Javascript confirmation on delete

Thanks
------

- namelessjon helped me break things up, refactor, and explain sessions.
- Sean Hess's blog - https://github.com/seanhess/Blog