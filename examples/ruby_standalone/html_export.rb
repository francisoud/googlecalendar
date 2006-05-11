require File.dirname(__FILE__) + '/../shared.rb'
require File.dirname(__FILE__) + '/../../lib/googlecalendar'


data = scan french_holidays
calendar = parse data
html calendar, 'output/results.html'