module UpsAndDowns
  class Building
    def initialize(controllers)
      controllers.each { |c| c.building = self }
      @controllers = controllers
      @requests    = []
    end

    attr_reader :controllers
    attr_accessor :requests

    def add_request(params)
      @requests << Request.new(params)
    end

    def remove_request(request)
      requests.delete(request)
    end
  end
end

    
