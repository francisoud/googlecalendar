module Googlecalendar
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
  end # class Event
end # module Googlecalendar
