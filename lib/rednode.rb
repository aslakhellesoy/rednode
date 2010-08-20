
module Rednode
  NODE_HOME = File.expand_path(File.dirname(__FILE__) + '/../ext/node')
  require 'rednode/node'
  require 'rednode/constants'
  require 'rednode/events'
  require 'rednode/process'
  require 'rednode/bindings'
end