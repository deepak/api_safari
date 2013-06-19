module Resources
  class ListOrders < Starbucks
    include Webmachine::Resource::Authentication
    
    # curl -i -H "Content-Type: application/json" -X GET "0.0.0.0:8080/orders?status=paid" -u admin:password
    def to_json
      status = request.query["status"]
      Order.where(status: status).all.to_json
    end

    def allowed_methods
      %W[GET]
    end

    def is_authorized?(auth)
      basic_auth(auth){ |*args| args == %W[admin password] }
    end
  end
end
