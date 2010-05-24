module Rednodejs
  class Fs
    def Stats
      lambda do
      end
    end

    def open(path, flags, mode, callback=nil)
      #puts %{Fs.open(#{path.inspect}, #{flags.inspect}, #{mode.inspect})}
      Fd.new(path, flags, mode, callback)
    end

    def read(fd, buffer, offset, length, position)
      #puts %{Fs.read(#{fd.inspect}, #{buffer.inspect}, #{offset.inspect}, #{length.inspect}, #{position.inspect})}
      fd.read(buffer, offset, length, position)
    end

    def close
      lambda do
      end
    end

    class Fd
      def initialize(path, flags, mode, callback)
        @file = File.open(path, 'r')
      end

      def read(buffer, offset, length, position)
        contents = @file.read
        buffer.contents = contents
        contents.length
      end
    end
  end
end