begin
  require 'v8'
rescue LoadError
  require 'rubygems'
  require 'v8'
end

raise "No NODE_HOME found" unless ENV['NODE_HOME']

module Node
  class NativesModule
    Dir["#{ENV['NODE_HOME']}/lib/*.js"].each do |native_js|
      attribute = File.basename(native_js, File.extname(native_js)).to_sym
      define_method(attribute) do || # Empty pipes needed to make ruby realize arity is 0.
        File.read(native_js)
      end
    end
  end

  class BufferModule
    def Buffer
      lambda do
      end
    end
  end

  class FsModule
    def Stats
      lambda do
      end
    end

    # TODO: Shouldn't we receive something for the anonymus "handler" function?
    # See fs.js:601:
    # fs.open(this.path, this.flags, this.mode, function(err, fd) {
    def open(path, flags, mode)
    end

    def read
      lambda do
      end
    end

    def close
      lambda do
      end
    end
  end

  class Exports
  end

  class Process
    attr_reader :env, :global, :argv

    def initialize(context, global, argv)
      @context = context
      @global = global
      @argv = argv
      @bindings = Hash.new do |h, mod|
        name = mod.capitalize + "Module"
        if Node.const_defined?(name)
          h[mod] = Node.const_get(name).new
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

  class Context < V8::Context
    def initialize
      super
      self['process'] = Process.new(self, @native.Global, %w{noderbjs dummy.js})
      self['exports'] = Exports.new
      self['global'] = @native.Global
      self['GLOBAL'] = @native.Global
      self['rbputs'] = proc {|msg| puts msg.to_s}
      self['rbinspect'] = proc {|msg| puts msg.inspect}
      main = self.load(File.join(ENV['NODE_HOME'], 'src', 'node.js'))
      open do
        main.call(self['global'], self['process'])
      end
    end
  end
end

