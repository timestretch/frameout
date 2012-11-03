Frameout
--------

A simple Sinatra based example to register, login, and view a profile. It uses MySQL, and no ORM. This example shows one way to separate your code into multiple controllers with Sinatra.

Install
-------

Create database tables.

	$ mysql -u root
	mysql> create database frameout;
	mysql> quit
	
	$ mysql -u root frameout < private/sql/main.sql

Test with shotgun.

	$ sudo gem install shotgun
	$ shotgun config.ru

Source Code
-----------

Each controller must be added to the config.ru rackup file. Rack directs routes starting with a particular prefix to the appropriate controller. 

The base class and some useful helper utilities are in "app.rb". The configuration variables used in app.rb are in config.rb. Templates are located in the "views" directory. Each controller has its own subdirectory for erb templates. The login views are present in the "user" sub-directory.

I use tabs, equivalent to 4 spaces. You may switch them to two spaces if that looks better to you.

To-Do
-----

- Email validation when registering
- Unit Tests
- Clean up repeated erb template code.
- Add some admin-only user management functionality.
- Use an ORM such as ActiveRecord or Sequel where appropriate.
- Try Sequel Prepared statements.
- Implement "fetch_hash" to ruby-mysql prepared statement results.
- Javascript confirmation on delete

Thanks
------

- namelessjon helped me break things up, refactor, and explain sessions.