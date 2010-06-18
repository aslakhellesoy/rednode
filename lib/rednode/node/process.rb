module Rednode::Node
  class Process
    attr_reader :env, :global

    def initialize(context, global, main_js)
      @context = context
      @global = global
      @main_js = main_js
      @bindings = Hash.new do |h, mod|
        require "rednode/node/#{mod}"
        module_name = camelize(mod)
        h[mod] = Rednode::Node.const_get(module_name).new(context)
      end
      @env = @context.eval('new Object()')
      @env['NODE_DEBUG'] = true

      @listeners = Hash.new do |listeners, event|
        listeners[event] = []
      end
    end

    def binding(name)
      @bindings[name]
    end
        
    def compile(source, name = "<eval>")
      @context.eval(source, name)
    end

    def stdout
      STDOUT
    end

    def stderr
      STDERR
    end

    def cwd(*a) #make it arity -1
      Dir.pwd
    end
    
    def argv
      ['rednodejs', @main_js]
    end

    def EventEmitter
      Rednode::EventEmitter
    end

    def Timer
      lambda do
      end
    end

    def cwd
      lambda do
        Dir.pwd
      end
    end

    def chdir(dir)
      Dir.chdir(dir)
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

    def emit(event)
      @listeners[event].each do |function|
        begin
          function.call()
        rescue => e
          puts e.message
        end
      end
    end

    def addListener(event, function)
      @listeners[event] << function
      lambda do
      end
    end

    def _byteLength(s)
      puts s
    end

  private

    def camelize(s)
      s.gsub(/(^.|_.)/) {|l| l[-1..-1].upcase}
    end

  end
end