require File.dirname(__FILE__) + '/../shared.rb'
require File.dirname(__FILE__) + '/../../lib/googlecalendar'

data = scan_proxy('xxx.xxx.xxx.xxx', 3128, french_holidays)
calendar = parse data