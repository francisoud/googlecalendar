require 'googlecalendar'
g = GData.new
puts 'login'
token = g.login('yatiohi@gmail.com', 'PASS')
g.get_calendars

event = {:title=>'title', 
          :content=>'content', 
          :author=>'pub.cog', 
          :email=>'pub.cog@gmail.com', 
          :where=>'Toulouse,France', 
          :startTime=>'2007-06-06T15:00:00.000Z', 
          :endTime=>'2007-06-06T17:00:00.000Z'}

puts 'new_event'
response = g.new_event(event, 'uni') #post data to that calendar
puts response.body
puts 'done'

