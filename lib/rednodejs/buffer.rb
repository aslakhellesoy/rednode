module Rednodejs
  class Buffer
    def Buffer
      lambda do |*length|
        NativeBuffer.new(length)
      end
    end

    class NativeBuffer
      attr_reader :length
      
      def initialize(length)
        @length = length
      end

      def contents=(contents) 
        @contents = contents
      end

      def toString
        lambda do
          @contents
        end
      end
    end
  end
end