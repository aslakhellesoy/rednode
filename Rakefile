require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rednode"
    gem.summary = %Q{Pure Ruby implementation of Node.js' native libraries.}
    gem.description = %Q{Lets you run node.js apps without the node native runtime using V8, therubyracer and a pure ruby native runtime using Eventmachine}
    gem.email = ["cowboyd@thefrontside.com", "aslak.hellesoy@gmail.com"]
    gem.homepage = "http://github.com/cowboyd/rednode"
    gem.authors = ["Charles Lowell", "Aslak Hellesøy"]
    gem.add_dependency "therubyracer", ">= 0.7.4"
    gem.add_development_dependency "rspec", ">= 2.0.0.beta.11"
    gem.add_development_dependency "jeweler", ">= 1.4.0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec,gems']
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Rednode #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
