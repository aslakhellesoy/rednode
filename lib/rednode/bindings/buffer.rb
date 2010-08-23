module Rednode::Bindings
  class Buffer
    include Namespace
    class Buffer
      attr_reader :length, :data
      protected :data

      def initialize(opt, *args)
        case opt
        when Numeric
          @length = opt.to_i
          @data = " " * @length
        when V8::Array
          @length = opt
          opt.each_with_index do |byte, i|
            @data[i] = opt[i]
          end
        when String
          @length = opt.length
          @data = opt.dup
        when self.class
          raise "Not Yet Implemented"
        else
          raise "Bad argument"
        end
      end

      def [](index)
        index.kind_of?(Numeric) ? @data[index] : yield
      end

      def []=(index, value)
        index.kind_of?(Numeric) ? @data[index] = value : yield
      end

      def utf8Slice(start, stop)
        @data[start, stop]
      end

      def asciiSlice(start, stop)
        @data[start, stop]
      end

      def binarySlice(start, stop)
        @data[start, stop]
      end

      def base64Slice(start, stop)
        @data[start, stop]
      end

      def utf8Write(string, offset)
        0
      end

      def asciiWrite(string, offset)
        0
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