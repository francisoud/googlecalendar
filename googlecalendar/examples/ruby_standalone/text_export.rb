require File.dirname(__FILE__) + '/../shared.rb'
require 'fileutils'

def text_export
  data = scan french_holidays
  calendar = parse data
  text calendar, File.dirname(__FILE__) + '/../../output/results.txt'
end

text_export
