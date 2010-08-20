module Rednode::Bindings
  class Buffer
    def Buffer
      StringBuffer
    end

    class StringBuffer
      attr_reader :length, :data
      protected :data

      def initialize(length)
        @length = length
        @data = " " * length
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