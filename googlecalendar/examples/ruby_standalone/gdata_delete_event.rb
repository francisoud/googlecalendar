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
          :startTime=>'2009-06-20T15:00:00.000Z', 
          :endTime=>'2009-06-20T17:00:00.000Z'}

create_response = g.new_event(event) 
puts create_response.body


puts 'delete_event'
# TODO GET id from new_event response
id='http://www.google.com/calendar/feeds/default/private/full/pgvgjdnh43g3bo0emnpfg0gnr4'
response = g.delete_event(id)
puts 'done'
