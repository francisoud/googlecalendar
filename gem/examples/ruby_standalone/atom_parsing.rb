require File.dirname(__FILE__) + '/../shared.rb'

require 'rexml/document'
include REXML  # so that we don t have to prefix everything with REXML::...

def get_calendar_titles(atom)
  XPath.match(atom, "/feed/entry/title") 
end

g = GData.new
g.login('REPLACE_WITH_YOUR_MAIL@gmail.com', 'REPLACE_WITH_YOUR_PASSWORD')
dog = g.get_calendars()
atom = Document.new dog.body
get_calendar_titles(atom).each { |node| puts node.text }
