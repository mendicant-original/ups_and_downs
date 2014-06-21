module UpsAndDowns
  class Floor
    include Comparable

    def initialize(name)
      @name      = name
      @occupants = []
    end

    attr_reader :occupants, :name

    def occupant_count
      occupants.count
    end

    def occupant?(occupant)
      occupants.include?(occupant)
    end

    def add_occupant(occupant)
      occupants << occupant
    end

    def remove_occupant(occupant)
      occupants.delete(occupant)
    end

    def number
      if @name.eql?("Lobby")
        1
      else
        @name.match(/Floor (\d+)/)[1].to_i
      end
    end

    def <=>(other_floor)
      number <=> other_floor.number
    end
  end
end
