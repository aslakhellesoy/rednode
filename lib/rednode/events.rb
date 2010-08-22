module Rednode
  module EventEmitter
    attr_accessor :_events

    def emit(e, *args)
      return unless @_events
      case notify = @_events[e]
      when V8::Function
        notify.methodcall(self, *args)
      when V8::Array
        notify.each {|listener| listener.methodcall(self, *args) if listener}
      else
        return false
      end
      return true
    end

  end
end