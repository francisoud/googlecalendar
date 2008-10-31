require File.dirname(__FILE__) + '/../shared.rb'

# GData::create_conf_file('REPLACE_WITH_YOUR_MAIL@gmail.com', 'REPLACE_WITH_YOUR_PASSWORD')
g = GData.new
puts 'login_with_conf_file'
# login using file store in default location, see method rdoc for details...
token = g.login_with_conf_file()

