begin
  require 'v8'
rescue LoadError
  require 'rubygems'
  require 'v8'
end

raise "No NODE_HOME found" unless ENV['NODE_HOME']

module Rednodejs
  class Context < V8::Context
    def initialize
      super
      self['global'] = V8::To.rb(@native.Global)
      self['exports'] = Exports.new(self)
    end

    def run(main_js)
      self['process'] = Process.new(self, self['global'], main_js)
      node = self.load(File.join(ENV['NODE_HOME'], 'src', 'node.js'))
      open do
        node.call(self['global'], self['process'])
      end
    end
  end
end

