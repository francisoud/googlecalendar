require File.dirname(__FILE__) + '/../lib/googlecalendar'
require File.dirname(__FILE__) + '/../lib/googlecalendar_builders'
include Googlecalendar

def french_holidays 
  "/calendar/ical/french@holiday.calendar.google.com/public/basic"
end
