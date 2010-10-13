module Rednode::Bindings
  class Stdio

    def isStdoutBlocking(*a)
      true
    end

    def writeError
      lambda do |msg|
        $stderr.write(msg)
      end
    end
    
    def stdoutFD
      STDOUT
    end
    
  end
end