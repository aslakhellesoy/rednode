module Rednode::Bindings
  class Fs
    include Namespace
    def initialize
      @descriptors = {}
    end

    def chmod(path, mode, callback = nil)
      async(callback) do
        File.chmod(mode, path)
      end
    end

    def open(path, flags, mode, callback = nil)
      async(callback) do
        file = File.new(path, flags, mode)
        file.fileno.tap do |fd|
          @descriptors[fd] = file
        end
      end
    end

    def close(fd)
      file(fd) do |f|
        f.close()
        @descriptors.delete(fd)
      end
    end

    def read(fd, buffer, offset, length, position, callback = nil)
      raise "Second argument needs to be a buffer" unless buffer.kind_of?(Buffer::Buffer)
      raise "Offset is out of bounds" unless offset <= buffer.length
      raise "Length is extends beyond buffer" unless (offset + length) <= buffer.length
      async(callback) do
        file(fd) do |f|
          f.seek(position) if position
          data = buffer.send(:data)
          bytes = f.read(length)
          data[offset, bytes.length] = bytes.unpack('C*')
          bytes.length
        end
      end
    end

    def write(fd, buffer, offset, length, position, callback = nil)
      file(fd) do |f|
        f.seek(position) if position
        data = buffer.send(:data)
        file.write(data[offset, length])
      end
    end

    def stat(path, callback = nil)
      async(callback) do
        Stats.new(File.stat(path))
      end
    end

    def lstat(path, callback = nil)
      async(callback) do
        Stats.new(File.lstat(path))
      end
    end

    def fstat(fd, callback = nil)
      async(callback) do
        file(fd) do |f|
          Stats.new(f.stat)
        end
      end
    end

    def fsync(fd, callback = nil)
      async(callback) do
        file(fd) do |f|
          f.fsync
        end
      end
    end

    #TODO: figure out how to call fdatasync from ruby
    alias_method :fdatasync, :fsync

    class Stats
      def initialize(stat)
        @stat = stat
      end

      def size
        @stat.size
      end

      def mtime
        @stat.mtime
      end
      
      def mode
        @stat.mode
      end

      def isDirectory
        lambda do
          @stat.directory?
        end
      end
    end

    private

    def file(fd)
      if file = @descriptors[fd]
        yield file
      end
    end

    def async(callback)
      if callback
        begin
          result = yield
          begin
            callback.call(false, result)
          rescue Exception
          end
        rescue Exception => e
          begin
            callback.call(true,e)
          rescue Exception => e
          end
        end
      else
        yield
      end
    end
  end
end