require File.dirname(__FILE__) + '/../shared.rb'

g = GData.new
puts 'login'
token = g.login('REPLACE_WITH_YOUR_MAIL@gmail.com', 'REPLACE_WITH_YOUR_PASSWORD')

puts "token: #{token}"
event = {:title=>'title', 
          :content=>'content', 
          :author=>'pub.cog', 
          :email=>'pub.cog@gmail.com', 
          :where=>'Toulouse,France', 
          :startTime=>'2007-06-20T15:00:00.000Z', 
          :endTime=>'2007-06-20T17:00:00.000Z'}
puts 'new_event'
response = g.new_event(event) #post data to that calendar
puts response.body
puts 'done'
