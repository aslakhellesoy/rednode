module Rednode::Bindings
  class Cares
    include Namespace
        
    class Channel
      def initialize(opts)
        @opts = opts
      end
    end
  end
end