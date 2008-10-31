module Googlecalendar
  class GCalendar
    attr_reader :title, :url
  
    def initialize(title, url)
      @title = title
      @url = url
    end
  end # class GCalendar
end # module Googlecalendar
