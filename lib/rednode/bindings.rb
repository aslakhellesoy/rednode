
module Rednode::Bindings
  for binding in Dir[File.dirname(__FILE__) + '/bindings/*.rb']
    require binding
  end
end