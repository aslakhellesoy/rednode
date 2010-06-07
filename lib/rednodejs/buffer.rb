module Rednode
  class Buffer < BindingModule
    def Buffer
      lambda do |*length|
        StringBuffer.new(length[0])
      end
    end

    class StringBuffer
      attr_reader :length, :__buffer

      def initialize(length)
        @__buffer = ''
        @length = length
      end

      def toString
        lambda do
          @__buffer
        end
      end
    end
  end
end