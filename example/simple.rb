require_relative "../lib/ups_and_downs"

elevator = UpsAndDowns::Elevator.new(capacity: 5)
elevator.load_passenger("Gregory")
elevator.passenger?("Gregory")
elevator.passenger_count
