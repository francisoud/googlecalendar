require File.dirname(__FILE__) + '/../shared.rb'

g = GData.new
puts 'login'
token = g.login('REPLACE_WITH_YOUR_MAIL@gmail.com', 'REPLACE_WITH_YOUR_PASSWORD')
puts "token: #{token}"

puts 'quick_add'
# http://code.google.com/apis/calendar/developers_guide_protocol.html#CreatingQuickAdd
# http://www.google.com/support/calendar/bin/answer.py?answer=36604
response = g.quick_add('Tennis with John December 03 3pm-4:30pm') # post quick add to default calendar

puts response.body
puts 'done'
