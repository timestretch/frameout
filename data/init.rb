require 'sequel'
require 'yaml'

content = File.new("data/database.yml").read
settings = YAML::load content
DB = Sequel.connect "#{settings['adapter']}://#{settings['username']}:#{settings['password']}@#{settings['host']}/#{settings['database']}?encoding=#{settings['encoding']}&charset=#{settings['charset']}"
