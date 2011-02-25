module UpsAndDowns
  class Simulator
    def initialize
      @tick            = 0
      @on_tick_actions = Hash.new { |h,k| h[k] = [] }
    end

    attr_reader :on_tick_actions
    attr_accessor :tick

    def on_tick(n, &b)
      on_tick_actions[n] << b
    end

    def run
      loop do
        on_tick_actions[tick].each { |action| action.call }
        yield if block_given?
        self.tick += 1
      end
    end

    def future_actions?
      on_tick_actions.max_by{|k, v| k}[0] > tick
    end
  end
end
