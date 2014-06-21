require_relative "../lib/ups_and_downs"

class OneUpOneDownController < UpsAndDowns::Controller
  attr_accessor :direction_responsible_for, :moving_direction

  def other_controller
    building.controllers.find{|c| c != self }
  end

  def passenger_requests
    requests.select{|r| elevator.passenger?(r.passenger) }
  end

  def non_passenger_requests
    requests - passenger_requests
  end

  def going_my_way?(request)
    @direction_responsible_for == request.direction
  end

  def swap_pending_requests
    my_requests_to_swap = non_passenger_requests
    other_requests_to_swap = other_controller.non_passenger_requests

    self.requests -= my_requests_to_swap
    other_controller.requests += my_requests_to_swap

    self.requests += other_requests_to_swap
    other_controller.requests -= other_requests_to_swap
  end

  def accept_request?(request)
    return false if requests.length > elevator.capacity

    return going_my_way?(request) if @direction_responsible_for

    other_controller_dir = other_controller.direction_responsible_for
    if other_controller_dir
      @direction_responsible_for = other_controller_dir == :up ? :down : :up
      return going_my_way?(request)
    else
      @direction_responsible_for = request.direction
      return true
    end
  end

  def move
    case
    when req = requests.find { |r| r.pickup_floor == elevator.location }
      return :transfer unless elevator.passenger?(req.passenger)
    when req = requests.find { |r| r.drop_floor == elevator.location }
      return :transfer if elevator.passenger?(req.passenger)
    end

    case
    when elevator.at_top_of_shaft?
      @moving_direction = :down
      other_controller.moving_direction = :up
      swap_pending_requests
      @moving_direction
    when elevator.at_bottom_of_shaft?
      if @moving_direction == :down
        other_controller.moving_direction = :down
        swap_pending_requests
      end
      @moving_direction = :up
      if requests.empty?
        :wait
      else
        @moving_direction
      end
    when @moving_direction == :down
      if requests.find {|r| elevator.passenger?(r.passenger) }
        if requests.find { |r| elevator.passenger?(r.passenger) &&
                               r.drop_floor < elevator.location }
          @moving_direction
        else
          @moving_direction = :up
        end
      else
        @moving_direction
      end
    when @moving_direction == :up
      if requests.find {|r| elevator.passenger?(r.passenger) }
        if requests.find { |r| elevator.passenger?(r.passenger) &&
                               r.drop_floor > elevator.location }
          @moving_direction
        else
          @moving_direction = :down
        end
      else
        @moving_direction
      end
    else
      @moving_direction
    end
  end
end