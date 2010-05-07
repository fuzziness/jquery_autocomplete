require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "jrails_auto_complete"
    gem.summary = "jRails autocomplete using jQuery-UI"
    gem.description = "Adds autocomplete support to jRails, using jQuery-UI; it " +
                      "works similarly to the original rails autocomplete plugin, but " +
                      "generating unobtrusive javascript."
    gem.email = "michele.franzin@gmail.com"
    #gem.homepage = "http://github.com/michelefranzin/jrails_auto_complete"
    gem.authors = ["Michele Franzin"]

    #gem.extra_rdoc_files << 'README.textile' << 'CHANGELOG'
    gem.add_dependency('rails', '>= 2.1')
    gem.add_dependency('jrails', '>= 0.6')
    gem.files.exclude '*install.rb'
    gem.files.exclude '.gitignore'
    gem.files.exclude 'javascripts/*'
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
  rdoc.title = "jRails autocomplete #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
