module Rednodejs
  class Process
    attr_reader :env, :global, :argv

    def initialize(context, global, argv)
      @context = context
      @global = global
      @argv = argv
      @bindings = Hash.new do |h, mod|
        name = mod.capitalize
        if Rednodejs.const_defined?(name)
          h[mod] = Rednodejs.const_get(name).new
        else
          raise LoadError, "No such module #{mod}"
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
    
    def cwd(*a) #make it arity -1
      Dir.pwd
    end
    
    def argv
      ['rednode', "arg1"]
    end

    def EventEmitter
      lambda do
      end
    end

    def cwd
      lambda do
        Dir.pwd
      end
    end

    def checkBreak
      lambda do
      end
    end

    def assert(bool)
      lambda do
        raise "Wasn't true" if !bool
      end
    end

    def loop
      lambda do
      end
    end

    def emit(what)
      puts "EMIT #{what}"
    end
  end
end