require_relative "test_helper"

context "An elevator" do
  test "must have a capacity" do
    elevator = UpsAndDowns::Elevator.new(capacity: 5)
    assert_equal 5, elevator.capacity
  end

  test "must raise an error when capacity is not set" do
    error = assert_raises(UpsAndDowns::MissingParameterError) do
      elevator = UpsAndDowns::Elevator.new({})
    end
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

  def new_elevator(params={})
    params = { capacity: 5 }.merge(params)
    UpsAndDowns::Elevator.new(params)
  end
end
