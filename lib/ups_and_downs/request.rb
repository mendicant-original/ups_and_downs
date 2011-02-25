module UpsAndDowns
  class Request
    def initialize(params)
      ParameterValidator.check(params) do |must|
        must.include_parameters(:pickup_floor, :drop_floor, :passenger)
      end

      @pickup_floor = params[:pickup_floor]
      @drop_floor   = params[:drop_floor]
      @passenger    = params[:passenger]
    end

    attr_reader :pickup_floor, :drop_floor, :passenger
  end
end
