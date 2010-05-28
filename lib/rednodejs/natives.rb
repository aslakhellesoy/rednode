module Rednodejs
  class Natives < BindingModule
    @@scripts = {}
    
    Dir["#{NODELIB}/lib/*.js"].each do |native_js|
      attribute = File.basename(native_js, File.extname(native_js)).to_sym
      define_method(attribute) do || # Empty pipes needed to make ruby realize arity is 0.
        @@scripts[attribute] ||= File.read(native_js)
      end
    end
  end
end