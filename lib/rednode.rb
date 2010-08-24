
require 'rubygems'
module Rednode
  VERSION = '0.0.1'
  NODE_VERSION = '0.1.104'
  NODE_HOME = File.expand_path(File.dirname(__FILE__) + '/../ext/node')
  require 'rednode/node'
  require 'rednode/namespace'
  require 'rednode/constants'
  require 'rednode/events'
  require 'rednode/process'
  require 'rednode/bindings'
end