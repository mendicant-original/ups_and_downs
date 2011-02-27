require_relative "../lib/ups_and_downs"

class OneUpOneDownController < UpsAndDowns::Controller
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

simulator   = UpsAndDowns::Simulator.new

floors  = [UpsAndDowns::Floor.new("Lobby")]
(2..9).each do |i|
  floors << UpsAndDowns::Floor.new("Floor #{i}")
end

express_floors = []
[0, 2, 5, 8].each do |i|
  express_floors << floors[i]
end

elevator  = UpsAndDowns::Elevator.new(capacity: 2,
                                      floors: floors)

express_elevator = UpsAndDowns::Elevator.new(capacity: 2,
                                             floors: express_floors)

controller = CarolSampleController.new(elevator)
express_controller = CarolSampleController.new(express_elevator)

building = UpsAndDowns::Building.new([controller, express_controller])

floors[0].add_occupant "Jia"

building.add_request(pickup_floor: floors[0],
                     drop_floor: floors[1],
                     passenger: "Jia")

puts "--------------------------------"
puts "Initial state:"
building.controllers.each do |c|
  puts c.elevator.status
end

simulator.run do
  puts simulator.status
  building.controllers.each do |c|
    c.step
    puts c.elevator.status
    sleep 1
  end
  if building.requests.empty? &&
       !simulator.future_actions? &&
         !building.controllers.find{|c| !c.requests.empty?}
    puts "DONE."
    exit
  end
end

