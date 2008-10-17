require File.dirname(__FILE__) + '/../shared.rb'

def proxy_parse
  # Sample free anonymous proxy: 64.66.68.186:3128
  data = scan_proxy('xxx.xxx.xxx.xxx', 3128, french_holidays)
  calendar = parse data
end

proxy_parse
