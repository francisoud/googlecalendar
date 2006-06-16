require File.dirname(__FILE__) + '/../shared.rb'

def proxy_parse
  data = scan_proxy('xxx.xxx.xxx.xxx', 3128, french_holidays)
  calendar = parse data
end

proxy_parse