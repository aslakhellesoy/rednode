require 'rubygems'
$:.unshift('./lib')
require 'rednode'

$gem = Gem::Specification.new do |gem|
  gem.name = "rednode"
  gem.version = Rednode::VERSION
  gem.summary = %Q{Pure Ruby implementation of Node.js' native libraries.}
  gem.description = %Q{Lets you run node.js apps without the node native runtime using V8, therubyracer and a pure ruby native runtime using Eventmachine}
  gem.email = ["cowboyd@thefrontside.com", "aslak.hellesoy@gmail.com"]
  gem.homepage = "http://github.com/cowboyd/rednode"
  gem.authors = ["Charles Lowell", "Aslak Hellesøy"]
  gem.add_dependency "therubyracer", "~> 0.8.0.pre"
  gem.add_development_dependency "rspec", "~> 2.0.0"
end

task :default => :spec

for lib in Dir["tasks/*.rake"]
  load lib
end