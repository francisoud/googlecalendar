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
end

def parse(data)
    parser = ICALParser.new
    parser.parse(data)
end