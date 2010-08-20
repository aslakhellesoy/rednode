module Rednode::Bindings
  class Stdio
    
    def isStdoutBlocking(*a)
      true
    end
    
    def writeError(msg)
      $stderr.write(msg)
    end
  end
end