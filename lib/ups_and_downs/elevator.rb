module UpsAndDowns
  class Elevator
    def initialize(params)
      ParameterValidator.check(params) do |must|
        must.include_parameters(:capacity)
      end

      @capacity = params.fetch(:capacity)
    end 

    attr_reader :capacity
  end
end
