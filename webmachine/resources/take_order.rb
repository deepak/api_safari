module Resources
  class TakeOrder < Starbucks
    include Helper::CreateOrder

    def allowed_methods
      %W[POST]
    end
    
    def finish_request
      response.headers['Location'] = "/orders?id=#{@order.id}"
      response.body = @order.to_json
    end

    # curl -i -H "Content-Type: application/json" -d '{"orders":{"drinks":"mocha"}}' -X POST 0.0.0.0:8080/orders
    def process_post
      from_json
      @order = Order.take_order @coffee      
      @order.save
      
      201 # 204 No Content by default 
    end
  end
end
