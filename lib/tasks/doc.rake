# Rakefile
require 'sdoc' # and use your RDoc task the same way you used it before
require 'rdoc/task' # ensure this file is also required in order to use `RDoc::Task`

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.generator = 'sdoc'
  rdoc.template = 'rails'
  # rdoc.main = 'README.md'
  rdoc.rdoc_files.include('README.md', 'app/', 'lib/')
end
