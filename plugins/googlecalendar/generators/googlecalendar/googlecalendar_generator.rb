class GoogleCalendarGenerator < Rails::Generator::Base  
  def manifest
    record do |m|
      m.template 'googlecalendar_controller.rb', File.join("app/controller", "googlecalendar_controller.rb")
      # m.file File.join("#{dir}/googlecalendar_controller.rb")
    end
  end
end
