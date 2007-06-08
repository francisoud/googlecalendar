require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'

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

# --config ./config.yml
desc "Publish the release files to RubyForge."
task :release => [ :package ] do
  p = Rake::RubyForgePublisher.new(project_name, 'cogito')
#  `call rubyforge login`
#
#  for ext in %w( tgz zip)
#    release_command = "rubyforge add_release " + project_name + " " + project_name + " 'REL " + current_version + "' pkg/" + gem_name + ".#{ext}"
#    puts release_command
#    `#{release_command}`
#  end
end
