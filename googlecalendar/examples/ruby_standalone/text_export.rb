require File.dirname(__FILE__) + '/../shared.rb'
require 'fileutils'

def text_export
  data = scan french_holidays
  calendar = parse data
  FileUtils.mkdir('output') unless File.exist?('output')
  text calendar, 'output/results.txt'
end

text_export
