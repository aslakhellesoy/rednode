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
      self['global'] = V8::To.rb(@native.Global())
      self['process'] = Process.new(self, self['global'], %w{noderbjs dummy.js})
      self['exports'] = Exports.new
      self['rbputs'] = proc {|msg| puts msg.to_s}
      self['rbinspect'] = proc {|msg| puts msg.inspect}
      main = self.load(File.join(ENV['NODE_HOME'], 'src', 'node.js'))
      open do
        main.call(self['global'], self['process'])
      end
    end
  end
end

