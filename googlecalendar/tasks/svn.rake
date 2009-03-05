SVN = 'svn+ssh://cogito@rubyforge.org/var/svn/googlecalendar'

desc 'update branch in svn'
task :svn_branch do
  `svn delete #{SVN}/branches/1.X -m "cleanup branch"`
  `svn copy #{SVN}/trunk #{SVN}/branches/1.X -m "create branch"`
end

desc 'create tag in svn'
task :svn_tag do
  `svn copy #{SVN}/trunk #{SVN}/tags/1.0.0 -m "create tag"`
end

