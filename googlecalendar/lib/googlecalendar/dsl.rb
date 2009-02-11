require 'net/http'
# require 'net/https'
# require 'uri'

def parse(data)
    parser = Googlecalendar::ICALParser.new
    parser.parse(data)
end

def scan(ical_url, base_url='www.google.com')
  Net::HTTP.start(base_url, 80) do |http|
    response, data = http.get(ical_url)
    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
      return data
    else
      response.error!
    end
  end
end

def scan_proxy(proxy_addr, proxy_port, ical_url, base_url='www.google.com')
  Net::HTTP::Proxy(proxy_addr, proxy_port).start(base_url, 80) do |http|
    response, data = http.get(ical_url)
    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
      return data
    else
      response.error!
    end
  end
end

# Builder DSL
def text(calendar, filename)
    dirname = File.dirname(filename)
    Dir.mkdir(dirname) unless File.exists?(dirname)
    text_builder = Googlecalendar::TextBuilder.new
    text_builder.calendar = calendar
    text_builder.filename = filename
    text_builder.export
end

def html(calendar, filename)
    dirname = File.dirname(filename)
    Dir.mkdir(dirname) unless File.exists?(dirname) 
    html_builder = Googlecalendar::HtmlBuilder.new
    html_builder.calendar = calendar
    html_builder.filename = filename
    html_builder.date_format = "%d-%m-%y" #"%F"#"%A %B %d %Y" #"%d-%m-%Y"
    html_builder.export
end
