module Rednodejs
  class Stdio
    def isStdoutBlocking
      lambda do
        true
      end
    end
  end
end