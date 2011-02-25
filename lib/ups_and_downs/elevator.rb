module UpsAndDowns
  class Elevator
    def initialize(params)
      ParameterValidator.check(params) do |must|
        must.include_parameters(:capacity, :floors)
      end

      @passengers        = []
      @capacity          = params[:capacity]
      @floors            = params[:floors]
      @position          =  params.fetch(:starting_position, 0)  
    end 

    attr_reader :capacity, :passengers, :floors
    attr_accessor :position

    def location
      floors[position]
    end

    def move_up
      raise if at_top_of_shaft?
      self.position += 1
    end

    def move_down
      raise if at_bottom_of_shaft?
      self.position -= 1
    end

    def at_bottom_of_shaft?
      position == 0
    end

    def at_top_of_shaft?
      position + 1 == floors.count 
    end

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
