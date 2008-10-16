class GooglecalendarGenerator < Rails::Generator::Base  
  def manifest
    record do |m|
      m.directory File.join('app/views/googlecalendar')
      
      m.template 'googlecalendar_controller.rb', File.join("app/controllers", "googlecalendar_controller.rb")
      m.file 'index.rhtml', File.join('app/views/googlecalendar', "index.rhtml")
    end
  end
end
