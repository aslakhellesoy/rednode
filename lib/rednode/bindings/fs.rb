module Rednode::Bindings
  class Fs
    include Namespace
    def initialize
      @descriptors = {}
      @descriptors[STDOUT] = Class.new do
        def self.write(chars)
          $stdout.write(chars.pack("C*"))
        end
      end
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

    def close(fd, callback = nil)
      async(callback) do
        file(fd) do |f|
          f.close()
          @descriptors.delete(fd)
        end
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
      async(callback) do
        file(fd) do |f|
          f.seek(position) if position
          data = buffer.send(:data)
          f.write(data[offset, length])
        end
        length
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

    def readlink(path, callback = nil)
      async(callback) do
        File.readlink(path)
      end
    end

    def link(old_name, new_name, callback = nil)
      async(callback) do
        File.link(old_name, new_name)
      end
    end

    def symlink(old_name, new_name, callback = nil)
      async(callback) do
        File.symlink(old_name, new_name)
      end
    end

    def unlink(filename, callback = nil)
      async(callback) do
        File.unlink(filename)
      end
    end

    def rename(old_name, new_name, callback = nil)
      async(callback) do
        File.rename(old_name, new_name)
      end
    end

    def rmdir(dir, callback = nil)
      async(callback) do
        Dir.rmdir(dir)
      end
    end

    def mkdir(name, mode, callback = nil)
      async(callback) do
        Dir.mkdir(name)
      end
    end

    def readdir(name, callback = nil)
      async(callback) do
        Dir.new(name).to_a
      end
    end

    #TODO: figure out how to call fdatasync from ruby
    alias_method :fdatasync, :fsync
    
    def link(srcpath, dstpath, callback = nil)
      async(callback) do
        File.link(srcpath, dstpath)
      end
    end
    
    def symlink(linkdata, path, callback = nil)
      async(callback) do
        File.symlink(linkdata, path)
      end
    end
    
    def readlink(path, callback = nil)
      async(callback) do
        File.readlink(path)
      end
    end
    
    def unlink(path, callback = nil)
      async(callback) do
        File.unlink(path)
      end
    end
    
    def mkdir(path, mode, callback = nil)
      async(callback) do
        Dir.mkdir(path, mode)
      end
    end
    
    def rmdir(path, callback = nil)
      async(callback) do
        Dir.rmdir(path)
      end
    end
    
    def readdir(path, callback = nil)
      async(callback) do
        Dir.entries(path).reject { |e| ['.', '..'].include?(e) }
      end
    end
    
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

      def isSymbolicLink(*a)
        @stat.symlink?
      end

      def isDirectory(*a)
        @stat.directory?
      end

      def dev
        @stat.dev
      end

      def ino
        @stat.ino
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
            callback.call(e,nil)
          rescue Exception => e
          end
        end
      else
        yield
      end
    end
  end
end