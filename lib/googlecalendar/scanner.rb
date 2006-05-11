require 'net/http'
require 'uri'
# require 'parser.rb'
# require 'builders.rb'

def scan(ical_url)
  Net::HTTP.start('www.google.com', 80) do |http|
    response, data = http.get(ical_url)
    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
      return data
    else
      response.error!
    end
  end
end

def scan_proxy(proxy_adress, proxy_port, ical_url)
  Net::HTTP.Proxy(proxy_adress, proxy_port).start('www.google.com', 80) do |http|
    response, data = http.get(ical_url)
    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
      return data
    else
      response.error!
    end
  end
end
