module Resources
  class Orders < Starbucks
    include Webmachine::Resource::Authentication
    
    # curl -i -H "Content-Type: application/json" -X GET "0.0.0.0:8080/orders?status=paid" -u admin:password
    def to_json
      status = request.query["status"]
      Order.where(status: status).all.to_json
    end

    def from_json
      incoming = JSON.parse(request.body.to_s)["orders"]
      coffee = Coffee.where(name: incoming["drinks"]).first
      @order = Order.take_order coffee
    end

    def allowed_methods
      %W[POST GET]
    end

    # curl -i -H "Content-Type: application/json" -d '{"orders":{"drinks":"mocha"}}' -X POST 0.0.0.0:8080/orders
    def process_post
      from_json
      @order.save

      response.headers['Location'] = "/orders/#{@order.id}"
      response.body = @order.to_json
      
      201 # 204 No Content by default 
    end

    def is_authorized?(auth)
      if list_orders?
        basic_auth(auth){ |*args| args == %W[admin password] }
      else
        true
      end
    end

    def list_orders?
      request.method == 'GET' && request.uri.path == "/orders"
    end
  end
end
