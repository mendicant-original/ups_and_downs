module UpsAndDowns
  class Elevator
    def initialize(params)
      ParameterValidator.check(params) do |must|
        must.include_parameters(:capacity)
      end

      @capacity   = params.fetch(:capacity)
      @passengers = []
    end 

    attr_reader :capacity, :passengers

    def passenger?(passenger)
      passengers.include?(passenger)
    end

    def passenger_count
      passengers.count
    end

    def load_passenger(passenger)
      raise MaximumCapacityError if full?
      passengers << passenger 
    end

    def unload_passenger(passenger)
      passengers.delete(passenger)
    end

    def full?
      passenger_count == capacity
    end
  end
end
