require 'googlecalendar.rb'

class GooglecalendarController < ApplicationController
  def index
    data = scan("/calendar/ical/french@holiday.calendar.google.com/public/basic")
    calendar = parse data
    @events = []
    calendar.events.each do |event|
      @events.push(event.start_date)
    end
  end
end
