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

class Event
  attr_accessor :start_date, :end_date, :time_stamp, :class_name, :created, :last_modified, :status, :summary
  
  def to_s
    data = "---------- event ----------\n"
    data << 'start_date: ' + @start_date.to_s + "\n"
    data << 'end_date: ' + @end_date.to_s + "\n"
    data << 'time_stamp: ' + @time_stamp.to_s + "\n"
    data << 'class_name: ' + @class_name.to_s + "\n"
    data << 'created: ' + @created.to_s + "\n"
    data << 'last_modified: ' + @last_modified.to_s + "\n"
    data << 'status: ' + @status.to_s + "\n"
    data << 'summary: ' + @summary.to_s + "\n"
    return data
  end
end