module Googlecalendar
  class ICALParser
    attr_reader :calendar
    
    def parse(data)
      while data.sub!(/\r\n /, '')
        # Unfold; for more info take a look at RFC 2445 (iCalendar), section 4.1
=begin
        4.1 Content Lines

           The iCalendar object is organized into individual lines of text,
           called content lines. Content lines are delimited by a line break,
           which is a CRLF sequence (US-ASCII decimal 13, followed by US-ASCII
           decimal 10).

           Lines of text SHOULD NOT be longer than 75 octets, excluding the line
           break. Long content lines SHOULD be split into a multiple line
           representations using a line "folding" technique. That is, a long
           line can be split between any two characters by inserting a CRLF
           immediately followed by a single linear white space character (i.e.,
           SPACE, US-ASCII decimal 32 or HTAB, US-ASCII decimal 9). Any sequence
           of CRLF followed immediately by a single linear white space character
           is ignored (i.e., removed) when processing the content type.

           For example the line:

             DESCRIPTION:This is a long description that exists on a long line.

           Can be represented as:

             DESCRIPTION:This is a lo
              ng description
               that exists on a long line.

           The process of moving from this folded multiple line representation
           to its single line representation is called "unfolding". Unfolding is
           accomplished by removing the CRLF character and the linear white
           space character that immediately follows.

           When parsing a content line, folded lines MUST first be unfolded
           according to the unfolding procedure described above. When generating
           a content line, lines longer than 75 octets SHOULD be folded
           according to the folding procedure described above.
=end
      end
      lines = data.split("\n")
      
      reset_prefix
      lines.each do |line| 
        handle_element(line)
      end
      
      return @calendar
    end
    
    # An ICal line consist of 2 part XXX: YYYY
    # Get the first part of the line and after a small transformation call the appropriate method
    # example: 
    #   line is: VCALENDAR:BEGIN 
    #            VERSION:VALUE
    #   method call: handle_vcalendar_version
    # kind of work like a sax parser...
    def handle_element(line)
      pair = line.split(':', 2) # avoid problems when summary contains ':'
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
  
#    def handle_vcalendar_prodid(value)
#      @calendar.product_id = value
#    end

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
      @calendar.events.last.start_date = DateTime.parse(value)
    end
  
    def handle_vevent_dtend(value)
      @calendar.events.last.end_date = DateTime.parse(value)
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
  end # class ICALParser
end # module Googlecalendar
