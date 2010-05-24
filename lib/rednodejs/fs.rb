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

    def write(fd, buffer, offset, length, position, callback=nil)
    end

    def symlink(source, destination, callback=nil)
      if !File.exist?(source)
        source = File.join(File.dirname(destination), source)
      end
      File.symlink(source, destination)
    end

    def readlink(path, callback=nil)
      File.readlink(path)
    end

    def unlink(path)
      File.unlink(path) rescue nil
    end

    def close
      lambda do
      end
    end

    def lstat(path, callback=nil)
      lstat = File.lstat(path)

      def lstat.isSymbolicLink
        lambda do
          symlink? ? true : nil
        end
      end

      lstat
    end

    def stat(path, callback=nil)
      File.stat(path)
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