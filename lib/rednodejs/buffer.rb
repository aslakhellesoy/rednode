module Rednodejs
  class Buffer
    def Buffer
      lambda do
        NativeBuffer.new
      end
    end

    class NativeBuffer
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