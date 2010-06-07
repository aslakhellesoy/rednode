begin
  require 'v8'
rescue LoadError
  require 'rubygems'
  require 'v8'
end

module Rednode
  module Node
  end
end

require 'rednode/node/binding_module'
require 'rednode/node/exports'
require 'rednode/node/process'

module Rednode
  NODELIB = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'ext', 'node'))

  class Context < V8::Context
    def initialize
      super
      self['global'] = self.scope
      self['exports'] = Node::Exports.new(self)
    end

    def run(main_js)
      self['process'] = Node::Process.new(self, self['global'], main_js)
      node = self.load(File.join(NODELIB, 'src', 'node.js'))
      node.call(self['process'])
    end
  end
end

