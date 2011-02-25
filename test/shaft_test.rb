require_relative "test_helper"

context "An elevator shaft" do
  test "must default to the first floor in the floors list" do
    lobby  = UpsAndDowns::Floor.new("Lobby")
    floor2 = UpsAndDowns::Floor.new("2")


    shaft = UpsAndDowns::Shaft.new(floors: [lobby, floor2],
                                   elevator: tiny_elevator)

    assert_equal lobby, shaft.elevator_location
  end

  test "must be able to be initialized with an elevator starting postion" do
    lobby  = UpsAndDowns::Floor.new("Lobby")
    floor2 = UpsAndDowns::Floor.new("2")


    shaft = UpsAndDowns::Shaft.new(floors: [lobby, floor2],
                                   elevator: tiny_elevator,
                                   starting_position: 1)

    assert_equal floor2, shaft.elevator_location
  end

  test "must be able to move the elevator between floors" do
    lobby  = UpsAndDowns::Floor.new("Lobby")
    floor2 = UpsAndDowns::Floor.new("2")
    floor3 = UpsAndDowns::Floor.new("3")

    shaft = UpsAndDowns::Shaft.new(floors: [lobby, floor2, floor3],
                                   elevator: tiny_elevator)

    assert_equal lobby, shaft.elevator_location

    shaft.move_elevator_up
    assert_equal floor2, shaft.elevator_location

    shaft.move_elevator_up
    assert_equal floor3, shaft.elevator_location

    shaft.move_elevator_down
    assert_equal floor2, shaft.elevator_location

    shaft.move_elevator_down
    assert_equal lobby, shaft.elevator_location
  end

  test "must be able to detect when elevator is at the bottom of the shaft" do
    lobby  = UpsAndDowns::Floor.new("Lobby")
    floor2 = UpsAndDowns::Floor.new("2")


    shaft = UpsAndDowns::Shaft.new(floors: [lobby, floor2],
                                   elevator: tiny_elevator)

    assert shaft.elevator_at_bottom?
    refute shaft.elevator_at_top?
  end

  test "must be able to detect when elevator is at the top of the shaft" do
    lobby  = UpsAndDowns::Floor.new("Lobby")
    floor2 = UpsAndDowns::Floor.new("2")


    shaft = UpsAndDowns::Shaft.new(floors: [lobby, floor2],
                                   elevator: tiny_elevator)

    shaft.move_elevator_up

    assert shaft.elevator_at_top?
    refute shaft.elevator_at_bottom?
  end

  test "must test proper error raising" do
    flunk
  end

  def tiny_elevator
    UpsAndDowns::Elevator.new(capacity: 1)
  end
end

