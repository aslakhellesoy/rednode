begin
  require 'v8'
rescue LoadError
  require 'rubygems'
  require 'v8'
end


# ENV['NODE_HOME'] = File.expand_path(File.join(File.dirname(__FILE__), 'node')) unless ENV['NODE_HOME']

module Rednodejs
  NODELIB = ENV['NODE_HOME'] || File.expand_path(File.join(File.dirname(__FILE__), 'node'))
  class Context < V8::Context
    def initialize
      super
      self['global'] = self.scope
      self['exports'] = Exports.new(self)
    end

    def run(main_js)
      self['process'] = Process.new(self, self['global'], main_js)
      node = self.load(File.join(NODELIB, 'src', 'node.js'))
      node.call(self['global'], self['process'])
    end
  end
end

