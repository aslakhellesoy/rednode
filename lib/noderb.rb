begin
  require 'v8'
rescue LoadError
  require 'rubygems'
  require 'v8'
end

module Node
  
  class FsModule
    def close(*args); raise "Not Implemented"; end
    def open(*args); raise "Not Implemented"; end
    def read(*args); raise "Not Implemented"; end
    def fdatasync(*args); raise "Not Implemented"; end
    def fsync(*args); raise "Not Implemented"; end
    def rename(*args); raise "Not Implemented"; end
    def truncate(*args); raise "Not Implemented"; end
    def rmdir(*args); raise "Not Implemented"; end
    def mkdir(*args); raise "Not Implemented"; end
    def sendfile(*args); raise "Not Implemented"; end
    def readdir(*args); raise "Not Implemented"; end
    def stat(*args); raise "Not Implemented"; end
    def lstat(*args); raise "Not Implemented"; end
    def fstat(*args); raise "Not Implemented"; end
    def link(*args); raise "Not Implemented"; end
    def symlink(*args); raise "Not Implemented"; end
    def readlink(*args); raise "Not Implemented"; end
    def unlink(*args); raise "Not Implemented"; end
    def write(*args); raise "Not Implemented"; end
    def chmod(*args); raise "Not Implemented"; end
  end
  
  class NativesModule
    def assert; "native_assert";end
    def buffer; "native_buffer";end
    def child_process; "native_child_process";end
    def dns; "native_dns";end
    def events; "native_events";end
    def file; "native_file";end
    def freelist; "native_freelist";end
    def fs; "native_fs";end
    def http; "native_http";end
    def crypto; "native_crypto";end
    def ini; "native_ini";end
    def mjsunit; "native_mjsunit";end
    def net; "native_net";end
    def posix; "native_posix";end
    def querystring; "native_querystring";end
    def repl; "native_repl";end
    def sys; "native_sys";end
    def tcp; "native_tcp";end
    def uri; "native_uri";end
    def url; "native_url";end
    def utils; "native_utils";end
    def path; "native_path";end
    def module; "native_module";end
    def utf8decoder; "native_utf8decoder";end
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
  end  

  class Context < V8::Context
    def initialize
      super
      raise "No NODE_HOME found" unless ENV['NODE_HOME']
      self['process'] = Process.new(self)
      self['exports'] = Exports.new
      self['rbputs'] = proc {|msg| puts ERB::Util.h(msg)}
      self['rbinspect'] = proc {|msg| puts ERB::Util.h(msg.inspect)}          
      self.load(File.join(ENV['NODE_HOME'], 'lib','module.js'))
    end
  end
end

