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
        raise "not yet implemented"
      end

      def asciiWrite(string, offset)
        raise "not yet implemented"
      end

      def binaryWrite(string, offset)
        raise "not yet implemented"
      end

      def binaryWrite(string, offset)
        raise "not yet implemented"
      end

      def copy(target, position, start, finish)
        raise "not yet implemented"
      end
    end
  end
end