module Rednode::Node
  class Fs < BindingModule
    def Stats
      lambda do
      end
    end

    def open(path, flags, mode, callback=nil)
      fd = Fd.new(path, flags, mode)
      if(callback)
        callback.call(nil, fd)
      else
        fd
      end
    end

    def read(fd, buffer, offset, length, position, callback = nil)
      #puts %{Fs.read(#{fd.inspect}, #{buffer.inspect}, #{offset.inspect}, #{length.inspect}, #{position.inspect})}
      fd.read(buffer, offset, length, position)
    end

    def chmod(path, mode, callback = nil)
      begin
        File.chmod(mode, path)
        callback.call(false) if callback
      rescue SystemCallError => e
        callback.call(true) if callback
      end
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
      _stat(callback) do
        File.lstat(path)
      end
    end

    def stat(path, callback=nil)
      _stat(callback) do
        File.stat(path)
      end
    end

    def fstat(fd, callback=nil)
      stats = fd.fstat
      if(callback)
        callback.call(stats)
      else
        stats
      end
    end

    def _stat(callback)
      if(callback)
        error = false
        stat = nil
        begin
          stat = yield
        rescue SystemCallError => e
          error = true
        end
        callback.call(error, stat)
      else
        yield
      end
    end

    class Fd
      def initialize(path, flags, mode)
        @path = path
      end

      def read(buffer, offset, length, position)
        @file ||= File.open(@path)
        begin
          @file.seek(position, IO::SEEK_SET) if position
          read = @file.readpartial(length, buffer.__buffer)
          read.length
        rescue EOFError
          @file.close
          0
        end
      end

      def fstat
        File.stat(@path)
      end
    end
  end
end

class File::Stat
  defalias = proc do |cls, name, actual|
    cls.send(:define_method, name) do
      self.send(actual) ? true : false
    end
  end
  {
    :isDirectory => :directory?,
    :isFile => :file?,
    :isSocket => :socket?,
    :isBlockDevice => :blockdev?,
    :isCharacterDevice => :chardev?,
    :isFIFO => :pipe?,
    :isSymbolicLink => :symlink?
  }.each do |method, actual|
    defalias[self, method, actual]
  end
end