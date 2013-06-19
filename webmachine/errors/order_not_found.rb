module Error
  class OrderNotFound < Exception
    attr_accessor :order_id

    def new(order_id)
      @order_id = order_id
    end

    def to_s
      "cannot find order id: #{order_id}"
    end

    def http_code
      400
    end
  end
end
