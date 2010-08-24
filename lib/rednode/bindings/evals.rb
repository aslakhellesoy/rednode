module Rednode::Bindings
  class Evals
    include Namespace
    class Script
      def initialize(source)
        @source = source
      end

      def runInNewContext(sandbox = nil)
        newContext = V8::Context.new
        sandbox = nil unless sandbox.kind_of?(V8::Object)
        for key, value in sandbox
          newContext[key] = value
        end if sandbox
        newContext.eval(@source, "<script>").tap do
          for key, value in newContext.scope
            sandbox[key] = value
          end if sandbox
        end
      end

      def runInThisContext(sandbox = nil)
        #mini-hack: there isn't a way to get the current V8::Context
        #as a high level context in therubyracer, so we hack the constructor
        #we wished existed that binds to the underlying current C::Context
        thisContext = V8::Context.allocate
        thisContext.instance_eval do
          @native = V8::C::Context::GetEntered()
          @scope = V8::To.rb(@native.Global())
        end
        thisContext.eval(@source, "<script>")
      end
    end
  end
end