module Rednode::Bindings
  class Buffer
    include Namespace
    class Buffer
      attr_reader :data
      protected :data

      def initialize(opt, *args)
        case opt
        when Numeric
          @data = Array.new(opt, 0)
        when V8::Array
          @data = opt.to_a
        when String
          encoding = *args
          enc = case encoding
            when nil,'utf8','utf-8' then 'U*'
            when 'ascii' then 'a*'
            when 'base64' then 'm*'
            when 'binary' then 'C*'
            else
              warn "unknown encoding: #{encoding}"; 'C*'
          end
          @data = opt.unpack(enc)
        when self.class
          @data = []
        else
          raise "Bad argument"
        end
      end
      
      def length
        @data.length
      end

      def [](index)
        index.kind_of?(Numeric) ? @data[index] : yield
      end

      def []=(index, value)
        index.kind_of?(Numeric) ? @data[index] = value : yield
      end

      def utf8Slice(start, stop)
        @data[start, stop].pack('U*')
      end

      def asciiSlice(start, stop)
        @data[start, stop].pack('C*')
      end

      def binarySlice(start, stop)
        @data[start, stop]
      end

      def base64Slice(start, stop)
        @data[start, stop].pack('m*')
      end

      def utf8Write(string, offset)
        0
      end

      def asciiWrite(string, offset)
        raise "Argument must be a string" unless string.kind_of?(String)
        raise "Offset is out of bounds" if string.length > 0 && offset >= self.length
        to_write = [string.length, self.length - offset].min
        @data[offset, to_write] = string.unpack('C*')
        to_write
      end

      def binaryWrite(string, offset)
        0
      end

      def binaryWrite(string, offset)
        0
      end

      def copy(target, position, start, finish = self.length)
        raise "First arg should be a Buffer" unless target.kind_of?(self.class)
        raise "sourceEnd < sourceStart" if finish < start
        return 0 if start == finish

        raise "targetStart out of bounds" if position < 0 || position >= target.length
        raise "sourceStart out of bounds" if start < 0 || start >= self.length
        raise "sourceEnd out of bounds" if finish < 0 || finish > self.length

        to_copy = [finish - start, target.length - position].min.tap do |bytes|
          for i in 0..bytes - 1
            target[i] = self[i]
          end
        end
      end
    end
  end
end