module Rednode::Bindings
  class Stdio
    
    def writeError(msg)
      $stderr.write(msg)
    end
  end
end