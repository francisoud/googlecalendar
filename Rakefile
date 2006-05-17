require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'

dist_dirs = Dir['lib/**/*.rb'] + Dir['test/**/*.rb'] + Dir['plugins/googlecalendar/lib/**/*.rb']

desc "Default Task"
task :default => [ :package ]

# Create compressed packages
spec = Gem::Specification.new do |s|
  s.name = 'googlecalendar'
  s.version = '1.0.2'
  s.summary = "Google Calendar api for Ruby."
  s.description = %{The Google Calendar project provides: Export features (text file, simple html page or excel files), Ruby api's to connect to google calendars, A plugin for Ruby On Rails.}
  s.files = ["README", "CHANGELOG"]
  dist_dirs.each do |dir|
    s.files = s.files + Dir.glob( "#{dir}/**/*" ).delete_if { |item| item.include?( "\.svn" ) }
  end
  s.require_path = 'lib'
  s.autorequire = 'googlecalendar'
  s.has_rdoc = false
  s.rubyforge_project = "googlecalendar"
end
  
Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  #p.need_tar = true
  #p.need_zip = true
end

# Publishing ------------------------------------------------------

desc "Publish the beta gem"
task :pgem => [:package] do 
  Rake::SshFilePublisher.new("pub.cog@gmail.com", "public_html/gems/gems", "pkg", "googleclendar-1.0.2.gem").upload
  `ssh pub.cog@gmail.com './gemupdate.sh'`
end

desc "Publish the API documentation"
task :pdoc => [:rdoc] do 
  Rake::SshDirPublisher.new("pub.cog@gmail.com", "public_html/ar", "doc").upload
end

desc "Publish the release files to RubyForge."
task :release => [ :package ] do
  `rubyforge login`

  for ext in %w( tgz zip)
    release_command = "rubyforge add_release googlecalendar googlecalendar 'REL 1.0.2' pkg/googleclendar-1.0.2.#{ext}"
    puts release_command
    `#{release_command}`
  end
end