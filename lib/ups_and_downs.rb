require_relative "ups_and_downs/elevator"

module UpsAndDowns
  MissingParameterError = Class.new(StandardError)

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
