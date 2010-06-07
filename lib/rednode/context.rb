begin
  require 'v8'
rescue LoadError
  require 'rubygems'
  require 'v8'
end

require 'rednode/node'

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

