module Rednode
  module Namespace
    def [](name)
      begin
        self.class.const_defined?(name) ? self.class.const_get(name) : yield
      rescue NameError => e
        yield
      end
    end
  end
end