require_relative "test_helper"

context "A floor" do
  test "must have a name" do
    floor = UpsAndDowns::Floor.new("Lobby")
    assert_equal "Lobby", floor.name
  end

  test "must start out with no occupants" do
    floor = new_floor
    assert_equal 0, floor.occupant_count
  end

  test "must increase occupant count as occupants are added" do
    floor = new_floor
    
    floor.add_occupant("Greg")
    assert_equal 1, floor.occupant_count

    floor.add_occupant("Jia")
    assert_equal 2, floor.occupant_count
  end

  test "must decrease occupant count as occupants are removed" do
    floor = new_floor

    floor.add_occupant("Greg")
    floor.add_occupant("Jia")

    floor.remove_occupant("Greg")
    assert_equal 1, floor.occupant_count

    floor.remove_occupant("Jia")
    assert_equal 0, floor.occupant_count
  end

  test "must be able to determine if a floor has a given occupant" do
    floor = new_floor

    refute floor.occupant?("Greg")

    floor.add_occupant("Greg")
    assert floor.occupant?("Greg")
  end

  def new_floor
    UpsAndDowns::Floor.new("Generic Floor")
  end
end
