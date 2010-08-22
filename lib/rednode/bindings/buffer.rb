module Rednode::Bindings
  class Buffer
    def Buffer
      StringBuffer
    end

    class StringBuffer
      attr_reader :length, :data
      protected :data

      def initialize(opt, *args)
        case opt
        when Numeric
          @length = opt
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

    end
  end
end