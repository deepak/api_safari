module Error
  class CoffeeNotFound < Exception
    attr_accessor :coffee_name

    def new(coffee_name)
      @coffee_name = coffee_name
    end

    def to_s
      "cannot find coffee #{coffee_name.inspect} in inventory"
    end

    def http_code
      400
    end
  end
end
