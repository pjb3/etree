require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "etree"
    gem.summary = %Q{Scripts for working with flac files posted to http://bt.etree.org}
    gem.description = %Q{A port of the perl scripts found at http://etree-scripts.sourceforge.net}
    gem.email = "mail@paulbarry.com"
    gem.homepage = "http://github.com/pjb3/etree"
    gem.authors = ["Paul Barry"]
    gem.add_dependency "chronic", "0.2.3"
    gem.add_dependency "escape", "0.0.4"
    gem.bindir             = 'bin'
    gem.executables        = %w[flac2mp3 parse_info]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "etree #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
