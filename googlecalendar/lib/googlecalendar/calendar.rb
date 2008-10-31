module Googlecalendar
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
end # module Googlecalendar
