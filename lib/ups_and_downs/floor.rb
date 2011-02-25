module UpsAndDowns
  class Floor
    def initialize(name)
      @name      = name
      @occupants = []
    end

    attr_reader :occupants, :name

    def occupant_count
      occupants.count
    end

    def add_occupant(occupant)
      occupants << occupant
    end

    def remove_occupant(occupant)
      occupants.delete(occupant)
    end
  end
end
