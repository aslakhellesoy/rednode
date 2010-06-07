module Rednode::Node
  class Stdio < BindingModule
    def isStdoutBlocking
      lambda do
        true
      end
    end

    def writeError(msg)
      STDERR.write(msg)
    end
  end
end