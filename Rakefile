require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'

project_name = 'googlecalendar'
project_title = "Google Calendar api for Ruby"
current_version = "0.0.4"
gem_name = project_name + "-" + current_version

desc "Default Task"
task :default => [ :package ]

# Create compressed packages
spec = Gem::Specification.new do |s|
  s.name = project_name
  s.version = current_version
  s.summary = project_title
  s.description = %{The Google Calendar project provides: Export features (text file, simple html page), Ruby api's to connect to google calendars, A plugin for Ruby On Rails.}
  s.files = ["README", "CHANGELOG"] + Dir['lib/**/*.rb']
  s.require_path = 'lib'
  s.autorequire = project_name
  s.has_rdoc = true
  s.rubyforge_project = project_name
  s.author = "Benjamin Francisoud"
  s.email = "cogito@rubyforge.org"
  s.homepage = "http://benjamin.francisoud.googlepages.com/googlecalendar"
end
  
Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

# Generate the RDoc --------------------------------
Rake::RDocTask.new { |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = project_title
  rdoc.options << '--line-numbers' << '--inline-source' << '-A cattr_accessor=object'
  rdoc.rdoc_files.include('README', 'CHANGELOG')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include('examples/**/*.rb')
}

# Publishing ------------------------------------------------------
desc "Publish the API documentation"
task :pdoc => [:rdoc] do 
  p = Rake::SshDirPublisher.new("cogito@rubyforge.org", "/var/www/gforge-projects/googlecalendar/doc", "doc")
  p.upload
end

# Creating the tar.gz-----------------------------------------------
# `C:\path\cygwin\bin\tar cf googlecalendar-0.0.4.tar googlecalendar-0.0.4`
# `C:\path\cygwin\bin\gzip googlecalendar-0.0.4.tar`

# Compress Prophet with TUGZip ---------------------------------------------
desc "Compress GoogleCalendar with TUGZip"
task :TUGZip do
  Dir.mkdir "pkg" unless File.exist?("pkg")
  zip = "pkg/#{project_name}-#{current_version}.zip"
  FileUtils.remove zip if File.exist?(zip)
  File.open('pkg/file_list.txt', 'w') do |f|
    Dir["lib/**/*", "examples/**/*", "html/**/*", "test/**/*"].each do |path|
      # replace '/' with '\'
      escaped_path = path.gsub(/\//, '\\\\')
      f <<  "#{escaped_path},"
    end
  end
  `/Program Files/TUGZip/tzscript.exe googlecalendar.tzs`
  FileUtils.mv "pkg/googlecalendar.zip", zip
end
