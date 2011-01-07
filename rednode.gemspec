# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rednode/version"

Gem::Specification.new do |s|
  s.name = "rednode"
  s.version = Rednode::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors = ["Charles Lowell", "Aslak Helles\303\270y"]
  s.email = ["cowboyd@thefrontside.com", "aslak.hellesoy@gmail.com"]
  s.homepage = %q{http://github.com/cowboyd/rednode}
  s.description = %q{Lets you run node.js apps without the node native runtime using V8, therubyracer and a pure ruby native runtime using Eventmachine}

  s.rubyforge_project = "rednode"

  s.files         = `git ls-files`.split("\n") + Dir.chdir("ext/node") {`git ls-files`.split("\n").map {|f| File.join("ext/node", f)}}

  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.require_paths = ["lib"]

  s.summary = %q{Pure Ruby implementation of Node.js' native libraries.}

  s.add_dependency "therubyracer", ">= 0.8.0"
  s.add_dependency "eventmachine"
  s.add_development_dependency "rspec", ">= 2.0.0"

end
