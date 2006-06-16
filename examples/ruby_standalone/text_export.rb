require File.dirname(__FILE__) + '/../shared.rb'

def text_export
  data = scan french_holidays
  calendar = parse data
  text calendar, 'output/results.txt'
end

text_export