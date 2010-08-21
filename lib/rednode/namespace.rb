module Rednode
  module Namespace
    def [](name)
      name == name.capitalize && self.class.const_defined?(name) ? self.class.const_get(name) : yield
    end
  end
end