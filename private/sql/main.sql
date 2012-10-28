CREATE TABLE user (
	user_id int(11) PRIMARY KEY auto_increment,
	email varchar(30),
	password_hash varchar(128),
	created datetime,
	last_login_ip int(11) unsigned
) ENGINE=InnoDB charset=utf8;

create table idea (
	idea_id int(11) PRIMARY KEY auto_increment,
	short_description varchar(255),
	long_description text,
	public int(11) default 0,
	created datetime,
	created_by_user_id int(11) NOT NULL,
	
	FOREIGN KEY (created_by_user_id)
		REFERENCES user(user_id)
		ON DELETE RESTRICT
 ) ENGINE=InnoDB charset=utf8;