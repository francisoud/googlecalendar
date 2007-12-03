require 'net/http'
require 'net/https'
require 'uri'
require "rexml/document"

class Calendar
  attr_accessor :product_id, :version, :scale, :method, :events
  
  def add(event)
    # create events if it doesn't exist
    @events ||= []
    @events.push event
  end

  def to_s
    data = "########## calendar ##########\n"
    data << 'version: ' + @version.to_s + "\n"
    data << 'scale: ' + @scale.to_s + "\n"
    data << 'method: ' + @method.to_s + "\n"
    data << 'number of events: ' + @events.size.to_s + "\n"
    @events.each do |event|
      data << event.to_s
    end
    return data
  end
end

class GCalendar
  attr_reader :title, :url

  def initialize(title, url)
    @title = title
    @url = url
  end
end

class Event
  attr_accessor :start_date, :end_date, :time_stamp, :class_name, :created, :last_modified, :status, :summary, :description, :location, :rrule
  
  def to_s
    data = "---------- event ----------\n"
    data << 'start_date: ' + @start_date.to_s + "\n"
    data << 'end_date: ' + @end_date.to_s + "\n"
    data << 'time_stamp: ' + @time_stamp.to_s + "\n"
    data << 'class_name: ' + @class_name.to_s + "\n"
    data << 'created: ' + @created.to_s + "\n"
    data << 'last_modified: ' + @last_modified.to_s + "\n"
    data << 'status: ' + @status.to_s + "\n"
    data << 'rrule: ' + @rrule.to_s + "\n"
    data << 'summary: ' + @summary.to_s + "\n"
    data << 'desription: ' + @desription.to_s + "\n"
    data << 'location: ' + @location.to_s + "\n"
    return data
  end

  # 'FREQ=WEEKLY;BYDAY=MO;WKST=MO'  
  def rrule_as_hash
    array = @rrule.split(';')
    hash = Hash.new
    array.each do |item| 
      pair = item.split('=')
      hash[pair[0]] = pair[1]
    end 
    return hash
  end
end

#
# Make it east to use some of the convenience methods using https
#
module Net
  class HTTPS < HTTP
    def initialize(address, port = nil)
      super(address, port)
      self.use_ssl = true
    end
  end
end

# A ruby class to wrap calls to the Google Data API
# 
# More informations
# 
# Google calendar API: http://code.google.com/apis/calendar/developers_guide_protocol.html
class GData
  attr_accessor :google_url
  
  def initialize(google='www.google.com')
    @calendars = []
    @google_url = google
  end
  
  #Log into google data, this method needs to be call once before using other methods of the class
  #* Email   The user's email address.
  #* Passwd  The user's password.
  #* source  Identifies your client application. Should take the form companyName-applicationName-versionID
  #*Warning* Replace the default value with something like: 
  #+companyName-applicationName-versionID+ 
  def login(email, pwd, source='googlecalendar.rubyforge.org-googlecalendar-default')
    # service   The string cl, which is the service name for Google Calendar.
    @user_id = email
    response = Net::HTTPS.post_form(URI.parse("https://#{@google_url}/accounts/ClientLogin"),
        { 'Email' => email, 
          'Passwd' => pwd, 
          'source' => source, 
          'accountType' => 'HOSTED_OR_GOOGLE', 
          'service' => 'cl'})
    response.error! unless response.kind_of? Net::HTTPSuccess
    @token = response.body.split(/=/).last
    @headers = {
       'Authorization' => "GoogleLogin auth=#{@token}",
       'Content-Type'  => 'application/atom+xml'
     }
     return @token
  end

  # Reset reminders
  def reset_reminders(event)
    event[:reminders] = ""
  end
  
  # Add a reminder to the event hash 
  #* reminderMinutes
  #* reminderMethod [email, alert, sms, none]
  def add_reminder(event, reminderMinutes, reminderMethod)
    event[:reminders] = event[:reminders].to_s + 
      "<gd:reminder minutes='#{reminderMinutes}' method='#{reminderMethod}' />\n"
  end
  
  # Create a quick add event
  # 
  # <tt>text = 'Tennis with John April 11 3pm-3:30pm'</tt>
  # 
  # http://code.google.com/apis/calendar/developers_guide_protocol.html#CreatingQuickAdd
  def quick_add(text)
  content = <<EOF
<entry xmlns='http://www.w3.org/2005/Atom' xmlns:gCal='http://schemas.google.com/gCal/2005'>
  <content type="html">#{text}</content>
  <gCal:quickadd value="true"/>
</entry>
EOF
    post_event(content)
  end

  #'event' param is a hash containing 
  #* :title
  #* :content
  #* :author
  #* :email
  #* :where
  #* :startTime '2007-06-06T15:00:00.000Z'
  #* :endTime '2007-06-06T17:00:00.000Z'
  # 
  # Use add_reminder(event, reminderMinutes, reminderMethod) method to add reminders
  def new_event(event={},calendar = nil)
    new_event = template(event)
    post_event(new_event, calendar)
  end
  
  def post_event(xml, calendar = nil)
    #Get calendar url    
    calendar_url  = if calendar
      get_calendars
      find_calendar(calendar).url
    else
      # We will use user'default calendar in this case
      '/calendar/feeds/default/private/full'
    end
    
    http = Net::HTTP.new(@google_url, 80)
    response, data = http.post(calendar_url, xml, @headers)
    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
      redirect_response, redirect_data = http.post(response['location'], xml, @headers)
      case response
      when Net::HTTPSuccess, Net::HTTPRedirection
        return redirect_response
      else
        response.error!
      end
    else
      response.error!
    end
  end

  # Retreive user's calendar urls.
  def get_calendars
    http = Net::HTTP.new(@google_url, 80)
    response, data = http.get("http://#{@google_url}/calendar/feeds/" + @user_id, @headers)
    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
      redirect_response, redirect_data = http.get(response['location'], @headers)
      case response
      when Net::HTTPSuccess, Net::HTTPRedirection
        doc = REXML::Document.new redirect_data
	      doc.elements.each('//entry')do |e|
	        title = e.elements['title'].text
	        url = e.elements['link'].attributes['href']
	        @calendars << GCalendar.new(title, url.sub!("http://#{@google_url}",''))
	      end
        return redirect_response
      else
        response.error!
      end
    else
      response.error!
    end
  end
  
  def find_calendar(x)
    @calendars.find {|c| c.title.match x}
  end

  # The atom event template to submit a new event
  def template(event={})
  content = <<EOF
<?xml version="1.0"?>
<entry xmlns='http://www.w3.org/2005/Atom'
    xmlns:gd='http://schemas.google.com/g/2005'>
  <category scheme='http://schemas.google.com/g/2005#kind'
    term='http://schemas.google.com/g/2005#event'></category>
  <title type='text'>#{event[:title]}</title>
  <content type='text'>#{event[:content]}</content>
  <author>
    <name>#{event[:author]}</name>
    <email>#{event[:email]}</email>
  </author>
  <gd:transparency
    value='http://schemas.google.com/g/2005#event.opaque'>
  </gd:transparency>
  <gd:eventStatus
    value='http://schemas.google.com/g/2005#event.confirmed'>
  </gd:eventStatus>
  <gd:where valueString='#{event[:where]}'></gd:where>
  <gd:when startTime='#{event[:startTime]}' endTime='#{event[:endTime]}'>
    #{event[:reminders]}
  </gd:when>
</entry>
EOF
  end
end # GData class

class ICALParser
  attr_reader :calendar
  
  def parse(data)
    lines = data.split("\n")
    
    reset_prefix
    lines.each do |line| 
      handle_element(line)
    end
    
    return @calendar
  end
  
  def handle_element(line)
    pair = line.split(':')
    name = pair[0]
    value = pair[1]
    handler_method = @method_prefix + name.split(';')[0].tr('-', '_').downcase
    if self.respond_to? handler_method
      self.send(handler_method, value.chomp)
    end
  end

  def reset_prefix
    @method_prefix = "handle_"
  end  
  
  def handle_begin(value)
    if value == "VCALENDAR"
      handle_vcalendar_begin(value)
    elsif value == "VEVENT"
      handle_vevent_begin(value)
    end
  end
  
  def handle_vcalendar_end(value)
    reset_prefix
  end

  def handle_vcalendar_begin(value)
    @calendar = Calendar.new
    @method_prefix = @method_prefix + value.downcase + "_"
  end

  def handle_vcalendar_version(value)
    @calendar.version = value
  end

  def handle_vcalendar_calscale(value)
    @calendar.scale = value
  end

  def handle_vcalendar_method(value)
    @calendar.method = value
    # FIXME don't like to do this!
    reset_prefix
  end
  
  def handle_vevent_begin(value)
      event = Event.new
      @calendar.add event
      @method_prefix = @method_prefix + value.downcase + "_"
  end
  
  def handle_vevent_end(value)
    reset_prefix
  end

  def handle_vevent_dtstart(value)
    @calendar.events.last.start_date = Date.parse(value)
  end

  def handle_vevent_dtend(value)
    @calendar.events.last.end_date = Date.parse(value)
  end

  def handle_vevent_dtstamp(value)
    @calendar.events.last.time_stamp = DateTime.parse(value)
  end

  def handle_vevent_class(value)
    @calendar.events.last.class_name = value
  end

  def handle_vevent_created(value)
    @calendar.events.last.created = DateTime.parse(value)
  end

  def handle_vevent_last_modified(value)
    @calendar.events.last.last_modified = DateTime.parse(value)
  end

  def handle_vevent_status(value)
    @calendar.events.last.status = value
  end

  def handle_vevent_summary(value)
    @calendar.events.last.summary = value
  end
  
  def handle_vevent_rrule(value)
    @calendar.events.last.rrule = value
  end

  def handle_vevent_description(value)
    @calendar.events.last.description = value
  end

  def handle_vevent_location(value)
    @calendar.events.last.location = value
  end
end

def parse(data)
    parser = ICALParser.new
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
