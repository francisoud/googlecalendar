require 'net/http'
require 'net/https'
require 'uri'
require "rexml/document"

module Googlecalendar
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
    
    #Convinient method to create the conf file use in login_with_conf_file
    #if you don't want to create it by hand
    def self.create_conf_file(email, pwd)
      p = {'email' => email, 'password' => pwd}
      path = File.expand_path("~/.googlecalendar4ruby/google.yaml")
      unless File.exists?(path)
        puts "Creating file in #{path}"
        Dir.mkdir(File.dirname(path))
      end
      f = File.new(path, File::CREAT|File::TRUNC|File::RDWR)
      f << p.to_yaml
      f.close
    end
    
    #Log into google data
    #This method is basically the same as the login with user and password 
    #but it tries to find a ~/.googlecalendar4ruby/google.yml
    #Use this if you don't want to hardcode your user/password in your .rb files
    def login_with_conf_file(file='~/.googlecalendar4ruby/google.yaml')
      path = File.expand_path(file)
      if(File.exists?(path))
        File.open(path) { |f| @yaml = YAML::load(f) }
      else
        GData::create_conf_file('REPLACE_WITH_YOUR_MAIL@gmail.com', 'REPLACE_WITH_YOUR_PASSWORD')
        throw "Created a default file in: #{path}, you need to edit it !!"
      end 
      email = @yaml['email'] 
      pwd = @yaml['password']
      login(email, pwd)
    end # login

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
    end # login
  
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
    end # quick_add
  
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
    end # post_event
  
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
    end # get_calendars
    
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
    end # template

    # method to allow deleting an event from a google calendar
    def delete_event(event_url, if_match = '*')
       # create required deletion headers
       delete_headers = @headers.merge({'If-Match' => if_match})

       # now delete it
       http = Net::HTTP.new(@google_url, 80)
       response, data = http.delete(event_url, delete_headers)
       case response
       when Net::HTTPSuccess, Net::HTTPRedirection
         redirect_response, redirect_data = http.delete(response['location'], delete_headers)
         case redirect_response
         when Net::HTTPSuccess, Net::HTTPRedirection
           return redirect_data
         else
           return redirect_response.error!
         end
       else
         return response.error!
       end
       return data
     end # delete_event
  end # GData class  
end # module Googlecalendar
