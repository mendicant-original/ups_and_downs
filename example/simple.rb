require_relative "../lib/ups_and_downs"

class SampleController < UpsAndDowns::Controller
  def accept_request?(request)
    requests.length < elevator.capacity
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
      @direction = :down
    when elevator.at_bottom_of_shaft?
      if requests.empty?
        :wait
      else
        @direction = :up
      end
    else
      @direction
    end
  end
end