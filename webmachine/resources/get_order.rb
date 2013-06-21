module Resources
  class GetOrder < Starbucks
    # Does the resource exist? Returning a falsey value (false or nil)
    # will result in a '404 Not Found' response.
    def resource_exists?
      order
    end

    # This method should return the last modified date/time of the
    # resource which will be added as the Last-Modified header in the
    # response and used in negotiating conditional requests. Default
    # is nil.
    def last_modified
      order.updated_at
    end
    
    # curl -i -H "Accept: application/json" -X GET "0.0.0.0:8080/orders?id=1"
    def to_json
      order.to_json
    end

    def allowed_methods
      %W[GET]
    end

    protected
    def order
      @order ||= begin
                   order_id = request.query["id"]
                   Order.where(id: order_id).first
                 end
    end
  end
end
