require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'

project_name = 'googlecalendar'
project_title = "Google Calendar api for Ruby"
current_version = "0.0.2"
gem_name = project_name + "-" + current_version

desc "Default Task"
task :default => [ :package ]

# Create compressed packages
spec = Gem::Specification.new do |s|
  s.name = project_name
  s.version = current_version
  s.summary = project_title
  s.description = %{The Google Calendar project provides: Export features (text file, simple html page or excel files), Ruby api's to connect to google calendars, A plugin for Ruby On Rails.}
  s.files = ["README", "CHANGELOG"] + Dir['lib/**/*.rb']
  s.require_path = 'lib'
  s.autorequire = project_name
  s.has_rdoc = false
  s.rubyforge_project = project_name
end
  
Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  puts "----------------------------------------------------------------------------"
  puts "WARNING: You need to install cygwin (Archive package) for this task to work!"
  puts "----------------------------------------------------------------------------"
  p.need_tar = true
  p.need_zip = true
end

# Update Rails Plugin ---------------------------------------------
desc "Update the Rails Plugin"
task :plugin => [:package] do 
  File.copy "lib/googlecalendar.rb", "plugins/" + project_name + "/lib/googlecalendar.rb"
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
desc "Publish the beta gem"
task :pgem => [:package] do 
  Rake::SshFilePublisher.new("cogito@rubyforge.org", "public_html/gems/gems", "pkg", gem_name + ".gem").upload
  `ssh cogito@rubyforge.org './gemupdate.sh'`
end

desc "Publish the API documentation"
task :pdoc => [:rdoc] do 
  Rake::SshDirPublisher.new("cogito@rubyforge.org", "/var/www/gforge-projects/googlecalendar/doc", "doc").upload
end

desc "Publish the release files to RubyForge."
task :release => [ :package ] do
  `command rubyforge login --config ./config.yml`

  for ext in %w( tgz zip)
    release_command = "command /c rubyforge add_release " + project_name + " " + project_name + " 'REL " + current_version + "' pkg/" + gem_name + ".#{ext}"
    puts release_command
    `#{release_command}`
  end
end