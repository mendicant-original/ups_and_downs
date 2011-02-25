require_relative "test_helper"

context "An elevator" do
  test "must have a capacity and a list of floors" do
    lobby  = UpsAndDowns::Floor.new("Lobby")
    floor2 = UpsAndDowns::Floor.new("2")

    elevator = UpsAndDowns::Elevator.new(capacity: 5, floors: [lobby, floor2])
    assert_equal 5, elevator.capacity
    assert_equal 2, elevator.floors.count
  end

  test "must start out with no passengers" do
    elevator = new_elevator
    assert_equal 0, elevator.passenger_count
  end

  test "must be able to determine whether or not a passenger is present" do
    elevator = new_elevator

    refute elevator.passenger?("Gregory")

    elevator.load_passenger("Gregory")
    assert elevator.passenger?("Gregory")

    elevator.unload_passenger("Gregory")
    refute elevator.passenger?("Gregory")
  end

  test "must increase passenger_count each time a passenger is loaded" do
    elevator = new_elevator

    elevator.load_passenger "Gregory"
    assert_equal 1, elevator.passenger_count

    elevator.load_passenger "Jia"
    assert_equal 2, elevator.passenger_count
  end

  test "must decrease passenger_count each time a passenger is unloaded" do
    elevator = new_elevator

    elevator.load_passenger "Gregory"
    elevator.load_passenger "Jia"

    elevator.unload_passenger "Gregory"
    assert_equal 1, elevator.passenger_count

    elevator.unload_passenger "Jia"
    assert_equal 0, elevator.passenger_count
  end

  test "must raise an error when trying to load a full elevator" do
    elevator = new_elevator(capacity: 2)

    elevator.load_passenger "Gregory"
    elevator.load_passenger "Jia"

    assert elevator.full?

    assert_raises(UpsAndDowns::MaximumCapacityError) do
      elevator.load_passenger "Jordan"
    end
  end

  test "must default to the first floor in the floors list" do
    lobby  = UpsAndDowns::Floor.new("Lobby")
    floor2 = UpsAndDowns::Floor.new("2")

    elevator = UpsAndDowns::Elevator.new(capacity: 5, floors: [lobby, floor2])

    assert_equal lobby, elevator.location
  end

  test "must be able to be initialized with an elevator starting postion" do
    lobby  = UpsAndDowns::Floor.new("Lobby")
    floor2 = UpsAndDowns::Floor.new("2")

    elevator = UpsAndDowns::Elevator.new(capacity: 5,
                                      floors: [lobby, floor2],
                                      starting_position: 1)

    assert_equal floor2, elevator.location
  end

  test "must be able to move the elevator between floors" do
    lobby  = UpsAndDowns::Floor.new("Lobby")
    floor2 = UpsAndDowns::Floor.new("2")
    floor3 = UpsAndDowns::Floor.new("3")

    elevator = UpsAndDowns::Elevator.new(capacity: 5,
                                         floors: [lobby, floor2, floor3])

    assert_equal lobby, elevator.location

    elevator.move_up
    assert_equal floor2, elevator.location

    elevator.move_up
    assert_equal floor3, elevator.location

    elevator.move_down
    assert_equal floor2, elevator.location

    elevator.move_down
    assert_equal lobby, elevator.location
  end

  test "must be able to detect when elevator is at the bottom of the shaft" do
    lobby  = UpsAndDowns::Floor.new("Lobby")
    floor2 = UpsAndDowns::Floor.new("2")


    elevator = UpsAndDowns::Elevator.new(floors: [lobby, floor2],
                                         capacity: 5)

    assert elevator.at_bottom_of_shaft?
    refute elevator.at_top_of_shaft?
  end

  test "must be able to detect when elevator is at the top of the shaft" do
    lobby  = UpsAndDowns::Floor.new("Lobby")
    floor2 = UpsAndDowns::Floor.new("2")


    elevator = UpsAndDowns::Elevator.new(floors: [lobby, floor2],
                                         capacity: 5)
    elevator.move_up

    assert elevator.at_top_of_shaft?
    refute elevator.at_bottom_of_shaft?
  end

  test "must test proper error raising for elevator movement" do
    flunk
  end

  def new_elevator(params={})
    lobby  = UpsAndDowns::Floor.new("Lobby")
    floor2 = UpsAndDowns::Floor.new("2")

    params = { capacity: 5, floors: [lobby, floor2] }.merge(params)
    UpsAndDowns::Elevator.new(params)
  end
end
