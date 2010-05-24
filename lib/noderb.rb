begin
  require 'v8'
rescue LoadError
  require 'rubygems'
  require 'v8'
end

module Node
  class NativesModule
    @libs = Dir["#{ENV['NODE_HOME']}/lib/*.js"].map do |native_js|
      attribute = File.basename(native_js, File.extname(native_js)).to_sym
      attr_reader attribute
      #define_method(attribute) do
      #  instance_variable_get("@#{attribute}")
      #end
      attribute
    end

    def self.libs
      @libs
    end

    def initialize
      for mod in NativesModule.libs
        lib = File.join(ENV['NODE_HOME'], 'lib', "#{mod}.js")
        if File.file?(lib)
          instance_variable_set("@#{mod}", File.read(lib))
        else
          raise LoadError, "no such node lib #{mod}"
        end
      end
    end
  end

  class Exports
  end

  class Process
    attr_reader :env

    def initialize(context)
      @context = context
      @bindings = Hash.new do |h, mod|
        name = mod.capitalize + "Module"
        if Node.const_defined?(name)
          h[mod] = Node.const_get(name).new
        else
          raise LoadError, "no such module #{mod}"
        end
      end
      @env = @context.eval('new Object()')
      @env['NODE_DEBUG'] = true
    end

    def binding(name)
      @bindings[name]
    end
        
    def compile(source, name = "<eval>")
      @context.eval(source, name)
    end

    # def EventEmitter
    #   @context.eval("function() {}")
    # end
  end  

  class Context < V8::Context
    def initialize
      super
      raise "No NODE_HOME found" unless ENV['NODE_HOME']
      self['process'] = Process.new(self)
      self['exports'] = Exports.new
      self['rbputs'] = proc {|msg| puts "<pre>#{ERB::Util.h(msg)}</pre>"}
      self['rbinspect'] = proc {|msg| puts "<pre>#{ERB::Util.h(msg.inspect)}</pre>"}
      self.load(File.join(ENV['NODE_HOME'], 'lib','module.js'))
    end
  end
end

