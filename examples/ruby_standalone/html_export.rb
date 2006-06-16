require File.dirname(__FILE__) + '/../shared.rb'

def html_export
  data = scan french_holidays
  calendar = parse data
  html calendar, 'output/results.html'
end

html_export