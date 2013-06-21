module Resources
  class ModifyOrder < Starbucks
    include Helper::CreateOrder
    
    def allowed_methods
      %W[PUT]
    end

    def content_types_accepted
      [["application/json", :modify_order]]
    end

    # If this returns true, the client will receive a '409 Conflict'
    # response. This is only called for PUT requests. 
    def is_conflict?
      from_json
      @order && @order.paid?
    end

    # If the request is malformed, this should return true, which will
    # result in a '400 Malformed Request' response. 
    def malformed_request?
      from_json
      @coffee.nil? || @order.nil?
    end
    
    def from_json
      super
      @order = Order.where(id: order_id).first
    end

    # curl -i -H "Content-Type: application/json" -d '{"orders":{"drinks":"latte"}}' -X PUT "0.0.0.0:8080/orders?id=1
    def modify_order
      from_json

      #raise Error::OrderNotFound.new(order_id) unless @order

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
