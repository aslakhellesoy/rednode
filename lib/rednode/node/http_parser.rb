module Rednode::Node
  class HttpParser < BindingModule
    def HTTPParser
      lambda do
        Impl.new
      end
    end

    class Impl
      attr_accessor :onMessageBegin, :onURL, :onPath, :onHeadersComplete

      def execute(buffer, offset, length)
        onHeadersComplete.call(info)
        onPath.call(buffer, 4, 5)
        onMessageBegin.call
        onURL.call(buffer, 5, 2)
      end

      def info
        Info.new
      end
    end

    class Info
    end
  end
end