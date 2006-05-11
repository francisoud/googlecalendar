class TextBuilder
  attr_accessor :calendar, :filename
  
  def export
    begin
      File.delete(@filename)
    rescue
      # if doesn't exist
    end
    File.open(@filename, File::CREAT|File::RDWR) do |file|
      file << calendar.to_s
    end
  end
end

def text(calendar, filename)
    text_builder = TextBuilder.new
    text_builder.calendar = calendar
    text_builder.filename = filename
    text_builder.export
end

class HtmlBuilder
  attr_accessor :calendar, :filename, :date_format
  
  def export
    begin
      File.delete(@filename)
    rescue
      # if doesn't exist
    end
    File.open(@filename, File::CREAT|File::RDWR) do |file|
      file << "<html><head>\n"
      file << "<title>Calendar</tilte>\n"
      IO.foreach("html/styles.css") { |line| file << line } 
      file << "\n"
      IO.foreach("html/scripts.js") { |line| file << line } 
      file << "\n</head>\n<body>"
      file << summary
      event_number = 0
      @calendar.events.each do |event|
        file << "<p class=\"event\">"
        file << "<h2>Event [" + event.start_date.to_s + "]</h2>"
        file << "<div><b>From: </b>" + event.start_date.to_s + "<b> -&gt; To:</b> " + event.end_date.to_s + "</div>"
        file << div(event, 'summary')
        file << details(event, event_number)
        file << "</p>\n"
        event_number += 1
      end
      file << "</body></html>"
    end
  end

  def format(date)
    Date.strptime(date, @date_format)
  end
  
  def summary
    data = "<p class=\"calendar\">"
    data << "<h1>Calendar</h1>"
    data << div(@calendar, 'version')
    data << div(@calendar, 'scale')
    data << div(@calendar, 'method')
    data << "<div><b>number of events: </b>" + @calendar.events.size.to_s + "</div>"
    data << "</p>\n"
    return data
  end
  
  def details(event, number)
    details = "<a href=\"javascript:displayHideSection('details" + number.to_s + "');\">Display details</a>"
    details << "<div id=\"details" + number.to_s + "\" class=\"details\">"
    details << div(event, 'start_date')
    details << div(event, 'end_date')
    details << div(event, 'time_stamp')
    details << div(event, 'created')
    details << div(event, 'last_modified')
    details << div(event, 'status')
    details << div(event, 'class_name')
    details << "</div>"
  end
  
  def div(object, field)
    "<div><b>" + field.capitalize + ": </b>" + object.send(field).to_s + "</div>\n"
  end
end

def html(calendar, filename)
    html_builder = HtmlBuilder.new
    html_builder.calendar = calendar
    html_builder.filename = filename
    html_builder.date_format = "%d-%m-%y" #"%F"#"%A %B %d %Y" #"%d-%m-%Y"
    html_builder.export
end