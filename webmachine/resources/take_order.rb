module Resources
  class TakeOrder < Starbucks
    include Helper::CreateOrder

    def allowed_methods
      %W[POST]
    end
    
    def finish_request
      unless @error
        response.headers['Location'] = "/orders?id=#{@order.id}"
        response.body = @order.to_json
      end
    end

    # If the request is malformed, this should return true, which will
    # result in a '400 Malformed Request' response. 
    def malformed_request?
      from_json
      @error = true if @coffee.nil?
      @coffee.nil?
    end
    
    # curl -i -H "Content-Type: application/json" -d '{"order":{"drinks":"mocha"}}' -X POST 0.0.0.0:8080/orders
    def process_post
      from_json

      @order = Order.take_order @coffee      
      @order.save
      
      201 # 204 No Content by default 
    end
  end
end
