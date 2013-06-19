module Resources
  class ModifyOrder < Starbucks
    include Helper::CreateOrder
    
    def allowed_methods
      %W[PUT]
    end

    def content_types_accepted
      [["application/json", :modify_order]]
    end

    def is_conflict?
      from_json
      @order && @order.paid?
    end

    def from_json
      super
      @order = Order.where(id: order_id).first
    end

    # curl -i -H "Content-Type: application/json" -d '{"orders":{"drinks":"latte"}}' -X PUT "0.0.0.0:8080/orders?id=1
    def modify_order
      from_json

      raise Error::CoffeeNotFound.new(drink) unless @coffee
      raise Error::OrderNotFound.new(order_id) unless @order

      @order.coffee = @coffee
      @order.save

      # finish_request is not called otherwise
      finish_request
    end

    protected
    def order_id
      request.query["id"]
    end
  end
end
