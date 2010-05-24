module Rednodejs
  class Process
    attr_reader :env, :global

    def initialize(context, global, main_js)
      @context = context
      @global = global
      @main_js = main_js
      @bindings = Hash.new do |h, mod|
        h[mod] = Rednodejs.const_get(mod.capitalize).new
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
      ['rednodejs', @main_js]
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
    end
  end
end