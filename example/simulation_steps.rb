module UpsAndDowns
  module SimulationSteps
    extend self

    def run(simulator, floors, building)
      floors[1].add_occupant "Jia"
      floors[1].add_occupant "Greg"

      building.add_request(pickup_floor: floors[1],
                             drop_floor: floors[8],
                              passenger: "Jia")

      building.add_request(pickup_floor: floors[1],
                             drop_floor: floors[0],
                              passenger: "Greg")

      simulator.on_tick(2) do
        floors[3].add_occupant "Samnang"
        building.add_request(pickup_floor: floors[3],
                               drop_floor: floors[7],
                                passenger: "Samnang")
      end
      
      simulator.on_tick(5) do
        floors[2].add_occupant "Carol"
        building.add_request(pickup_floor: floors[2],
                               drop_floor: floors[8],
                                passenger: "Carol")
      end
      
      simulator.on_tick(7) do
        floors[3].add_occupant "Gavin"
        building.add_request(pickup_floor: floors[3],
                               drop_floor: floors[0],
                                passenger: "Gavin")
      end

      puts "--------------------------------"
      puts "Initial state:"
      building.controllers.each do |c|
        puts "--------------------------------"
        puts "Elevator is at: #{c.elevator.location.name}"
        puts "Passengers: #{c.elevator.passengers.join(", ")}"
        puts "--------------------------------"
        puts "Info for floors accessible by this elevator"
        puts c.elevator.floors.map { |f| "#{f.name}: #{f.occupants.join(',')}" }
      end

      simulator.run do
        puts "\n--------------------------------"
        puts "Tick #{simulator.tick}"
        building.controllers.each do |c|
          c.step
          puts "--------------------------------"
          puts "Elevator is at: #{c.elevator.location.name}"
          puts "Passengers: #{c.elevator.passengers.join(", ")}"
          puts "--------------------------------"
          puts "Info for floors accessible by this elevator"
          puts c.elevator.floors.map { |f| "#{f.name}: #{f.occupants.join(',')}" }
          sleep 1
        end
        if building.requests.empty? &&
             !simulator.future_actions? &&
               !building.controllers.find{|c| !c.requests.empty?}
          puts "DONE."
          exit
        end
      end
    end
  end
end