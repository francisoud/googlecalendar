$:.unshift File.dirname(__FILE__)

module GoogleCalendar
  # List of googlecalendar lib files to include
  FILES = %w{builders.rb calendar.rb dsl.rb event.rb gcalendar.rb gdata.rb ical.rb net.rb}
end

# Add all FILES as require
GoogleCalendar::FILES.each { |f| require "googlecalendar/#{f}"}



require 'net/http'
require 'net/https'
require 'uri'
require "rexml/document"


