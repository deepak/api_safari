module Resources
  class ListOrders < Starbucks
    include Webmachine::Resource::Authentication

    # Does the resource exist? Returning a falsey value (false or nil)
    # will result in a '404 Not Found' response.
    def resource_exists?
      if order_id
        !order.nil?
      else
        true
      end
    end

    # This method should return the last modified date/time of the
    # resource which will be added as the Last-Modified header in the
    # response and used in negotiating conditional requests. Default
    # is nil.
    def last_modified
      if order_id
        order.updated_at
      else
        order = orders.order("updated_at desc").first
        order && order.updated_at 
      end
    end
    
    # curl -i -H "Content-Type: application/json" -X GET "0.0.0.0:8080/orders?status=paid" -u admin:password
    def to_json
      if order_id
        order.to_json
      else
        orders.all.to_json
      end
    end

    def allowed_methods
      %W[GET]
    end

    # Is the client or request authorized? Returning anything other than true
    # will result in a '401 Unauthorized' response.  Defaults to
    # true. If a String is returned, it will be used as the value in
    # the WWW-Authenticate header, which can also be set manually.
    def is_authorized?(auth)
      basic_auth(auth){ |*args| args == %W[admin password] }
    end

    protected
    def order_id
      request.query["id"]
    end

    def order
      Order.where(id: order_id).first
    end

    def order_status
      status = request.query["status"]
    end

    def orders
      @orders ||= begin
                    if order_status
                      Order.where(status: order_status)
                    else
                      Order
                    end
                  end
    end
  end
end
