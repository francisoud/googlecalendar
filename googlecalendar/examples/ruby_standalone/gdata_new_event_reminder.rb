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
          :startTime=>'2007-12-03T14:55:00.000Z', 
          :endTime=>'2007-12-03T17:00:00.000Z'}
g.add_reminder(event, '10', 'email')
g.add_reminder(event, '20', 'sms')
puts 'new_event'
response = g.new_event(event) #post data to that calendar , 'my_NOT_default_calendar'
puts response.body
puts 'done'
