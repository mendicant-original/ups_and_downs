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
end
