begin
  require 'v8'
rescue LoadError
  require 'rubygems'
  require 'v8'
end

module Node
  class Process
    attr_reader :env
    
    def initialize(context)
      @context = context
      @env = @context.eval('new Object()')
      @env['NODE_DEBUG'] = true
    end
    
    def binding(name)
      Binding.new(name)
    end
        
    def compile(source, name = "<eval>")
      @context.eval(source, name)
    end
  end

  class Exports
  end

  class Binding
    def initialize(name)
      @name = name
    end
  end
  
  class Natives
    def events
      "WTF"
    end
  end

  class Context < V8::Context
    def initialize
      super
      raise "No NODE_HOME found" unless ENV['NODE_HOME']
      self['process'] = Process.new(self)
      self['exports'] = Exports.new
      self.load(File.join(ENV['NODE_HOME'], 'lib','module.js'))
    end
  end
end

