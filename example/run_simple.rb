require_relative "../lib/ups_and_downs"
require_relative "simple"
require_relative "simulation_steps"

simulator = UpsAndDowns::Simulator.new

floors    = [UpsAndDowns::Floor.new("Lobby")]

floors.concat( (2..9).map{|i| UpsAndDowns::Floor.new("Floor #{i}")} )

controllers = 2.times.map{|i| SampleController.new(
                                UpsAndDowns::Elevator.new(
                                  capacity: 2,
                                  floors: floors
                                )
                              )
                          }


building = UpsAndDowns::Building.new(controllers)

UpsAndDowns::SimulationSteps.run(simulator, floors, building)