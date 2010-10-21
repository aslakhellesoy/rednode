require 'rubygems'
require 'eventmachine'
require 'v8'

module Rednode
  VERSION = '0.1.0'
  NODE_VERSION = '0.2.0'
  NODE_HOME = File.expand_path(File.dirname(__FILE__) + '/../ext/node')
  require 'rednode/node'
  require 'rednode/namespace'
  require 'rednode/constants'
  require 'rednode/events'
  require 'rednode/timer'
  require 'rednode/process'
  require 'rednode/bindings'

end