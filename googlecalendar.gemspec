spec = Gem::Specification.new do |s|
  s.name = 'googlecalendar'
  s.version = '1.0.2'
  s.summary = "Google Calendar api for Ruby."
  s.description = %{The Google Calendar project provides: Export features (text file, simple html page or excel files), Ruby api's to connect to google calendars, A plugin for Ruby On Rails.}
  s.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb'] + Dir['plugins/googlecalendar/lib/**/*.rb']
  s.require_path = 'lib'
  s.autorequire = 'googlecalendar'
  s.has_rdoc = true
  s.extra_rdoc_files = Dir['[A-Z]*']
  s.rdoc_options << '--title' <<  'googlecalendar -- Google Calendar api for Ruby.'
  s.author = "Benjamin Francisoud"
  s.email = "pub.cog@gmail.com"
  s.homepage = "http://benjamin.francisoud.googlepages.com"
end