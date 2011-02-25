module UpsAndDowns
  class Controller
    def initialize(elevator)
      @elevator  = elevator
      @requests  = []
    end

    attr_reader :elevator
    attr_accessor :requests, :building

    def step
      accept_new_requests

      case move 
      when :up
        elevator.move_up
      when :down
        elevator.move_down
      when :transfer
       transfer_passengers
      when :wait
        # do nothing
      else 
        raise
      end
    end
    
    def accept_new_requests
      building.requests.each do |r| 
        if accept_request?(r) 
          self.requests << r
        end
      end

      building.requests -= self.requests
    end

    def transfer_passengers
      completed_requests = []

      requests.each do |r|
        case
        when elevator.on_floor?(r.pickup_floor)
          next if elevator.passenger?(r.passenger)
          elevator.transfer_passenger(r.passenger)
        when elevator.on_floor?(r.drop_floor)
          next unless elevator.passenger?(r.passenger)
          elevator.transfer_passenger(r.passenger)
          completed_requests << r
        end
      end

      self.requests -= completed_requests
    end

    # override this
    def accept_request?(request)
      false
    end

    def move
    end
  end

end
