module UpsAndDowns
  class Shaft
    def initialize(params)
      ParameterValidator.check(params) do |must|
        must.include_parameters(:floors, :elevator)
      end

      @floors            = params[:floors]
      @elevator          = params[:elevator]
      @elevator_position = params.fetch(:starting_position, 0)  
    end

    attr_reader :controller, :floors
    attr_accessor :elevator_position
    
    def elevator_location
      floors[elevator_position]
    end

    def move_elevator_up
      raise if elevator_at_top?       
      self.elevator_position += 1 
    end

    def move_elevator_down
      raise if elevator_at_bottom?
      self.elevator_position -= 1
    end

    def elevator_at_top?
      elevator_position + 1 == floors.count 
    end

    def elevator_at_bottom?
      elevator_position == 0
    end

  end
end
