require File.dirname(__FILE__) + '/../shared.rb'
require File.dirname(__FILE__) + '/../../lib/googlecalendar'

data = scan french_holidays
calendar = parse data
text calendar, 'output/results.txt'
