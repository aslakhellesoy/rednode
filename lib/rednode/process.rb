
module Rednode
  class Process < EventEmitter
    include Constants
    attr_reader :global, :env
    
    def initialize(node)
      @node = node
      @engine = node.engine
      @global = @engine.scope
      @bindings = {}
      @env = Env.new
    end
    
    def binding(id)
      if @bindings[id]
        @bindings[id]
      elsif Rednode::Bindings::const_defined?(id.capitalize)
        @bindings[id] = Rednode::Bindings::const_get(id.capitalize).new
      elsif id == "natives"
        exports = @engine['Object'].new
        for native in Dir["#{NODE_HOME}/lib/*.js"]
          File.basename(native) =~ /^(.*)\.js$/
          exports[$1] = File.read(native)
        end
        @bindings[id] = exports
      else
        raise "no such module: #{id}"
      end
    end
    
    def compile(source, filename)
      @engine.eval(source, filename)
    end
    
    def argv
      ['rednode', @node.main]
    end
    
    def cwd(*args)
      Dir.pwd
    end
    
    def loop(*args)
    end
    
    def EventEmitter
      Rednode::EventEmitter
    end
    
    class Env
      def [](property)
        ENV.has_key?(property) ? ENV[property] : yield
      end
    end
  end
end