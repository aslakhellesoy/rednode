module Rednode

  class Scheduler
    attr_reader :timers, :running

    def initialize
      @timers = []
      @running = false
    end

    def add_timer(interval, &block)
      Timer.new(self).tap do |timer|
        timer.periodic = false
        timer.interval = interval
        timer.callback = block
        @timers << timer
        timer.start if @running
      end
    end
    
    def add_periodic_timer(interval, &block)
      Timer.new(self).tap do |timer|
        timer.periodic = true
        timer.interval = interval
        timer.callback = block
        @timers << timer
        timer.start if @running
      end
    end
    
    def remove_timer(timer)
      @timers.delete(timer)
    end
    
    def start_loop
      EventMachine.run do
        @running = true
        @timers.each do |t|
          t.start unless t.running
        end
        
        EventMachine::PeriodicTimer.new(0.05) do
          stop_loop if @timers.size == 0
        end
      end
    end
    
    def stop_loop
      EventMachine.stop_event_loop
    end
    
    def next_tick(&block)
      if @running
        EventMachine.next_tick do
          yield
        end
      else
        add_timer(0) { yield }
      end
    end
    
    class Timer
      attr_accessor :periodic, :interval, :callback
      attr_reader :running

      def initialize(timer)
        @interval = 0
        @periodic = false
        @callback = nil
        @timer = timer
        @running = false
      end

      def start
        @running = true
        EventMachine.add_timer(@interval.to_f / 1000) do
          @callback.call
          @timer.remove_timer(self)
        end
      end

      def cancel
        @timer.cancel if @timer
        @timer.remove_timer(self)
      end
    end
    

  end

end