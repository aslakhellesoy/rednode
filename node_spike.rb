
# require 'rubygems'
# require 'v8'
File.expand_path(File.join(File.dirname(__FILE__), '..', 'therubyracer', 'lib')).tap do |path|
  $:.unshift(path)
  $:.unshift('.')
end
require 'v8'
require 'node'


begin
  cxt = Node::Context.new()
  cxt.load('server.js')
rescue V8::JavascriptError => e
  puts e.javascript_stacktrace
end