require_relative "ups_and_downs/elevator"
require_relative "ups_and_downs/floor"
require_relative "ups_and_downs/request"
require_relative "ups_and_downs/controller"
require_relative "ups_and_downs/simulator"
require_relative "ups_and_downs/building"

module UpsAndDowns
  MissingParameterError = Class.new(StandardError)
  MaximumCapacityError  = Class.new(StandardError)

  class ParameterValidator
    class << self
      def check(parameters)
        yield(new(parameters))
      end

      private :new
    end

    def initialize(parameters)
      @parameters = parameters
    end

    attr_reader :parameters

    def include_parameters(*required_params)
      required_params.each { |e| parameters.fetch(e) }
    rescue KeyError
      raise MissingParameterError, 
        "Required parameters are: #{required_params.inspect}"
    end
  end
end
