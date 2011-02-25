require_relative "../lib/ups_and_downs"

simulator   = UpsAndDowns::Simulator.new

lobby_floor  = UpsAndDowns::Floor.new("Lobby")
second_floor = UpsAndDowns::Floor.new("Floor 2")
third_floor  = UpsAndDowns::Floor.new("Floor 3")

elevator  = UpsAndDowns::Elevator.new(capacity: 2, 
                                      floors: [lobby_floor, second_floor, third_floor])

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

controller = SampleController.new(elevator)
building = UpsAndDowns::Building.new([controller])

lobby_floor.add_occupant "Jia"
lobby_floor.add_occupant "Greg"

building.add_request(pickup_floor: lobby_floor,
                     drop_floor: second_floor,
                     passenger: "Jia")

building.add_request(pickup_floor: lobby_floor,
                     drop_floor: third_floor,
                     passenger: "Greg")

simulator.on_tick(10) do
  lobby_floor.add_occupant("Jordan")
  building.add_request(pickup_floor: lobby_floor,
                       drop_floor: third_floor,
                       passenger: "Jordan")
end

simulator.on_tick(11) do
  building.add_request(pickup_floor: second_floor,
                       drop_floor: third_floor,
                       passenger: "Jia")

end

simulator.on_tick(20) do
  ["Jordan","Jia","Greg"].each do |x|
    building.add_request(pickup_floor: third_floor,
                         drop_floor: lobby_floor,
                         passenger: x)
  end
end

simulator.on_tick(35) do
  puts "DONE"
  exit
end


simulator.run do 
  building.controllers.each do |c| 
    puts "--------------------------------"
    puts "Tick #{simulator.tick}"
    puts "Elevator is at: #{c.elevator.location.name}"
    puts "Passengers: #{c.elevator.passengers.join(", ")}"
    puts "--------------------------------"
    puts "Info for floors accessible by this elevator"
    puts c.elevator.floors.map { |f| "#{f.name}: #{f.occupants.join(',')}" }
    c.step
    sleep 1
  end
end

