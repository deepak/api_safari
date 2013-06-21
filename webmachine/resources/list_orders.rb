module Resources
  class ListOrders < Starbucks
    include Webmachine::Resource::Authentication

    # This method should return the last modified date/time of the
    # resource which will be added as the Last-Modified header in the
    # response and used in negotiating conditional requests. Default
    # is nil.
    def last_modified
      order = orders.order("updated_at desc").first
      order && order.updated_at
    end
    
    # curl -i -H "Accept: application/json" -X GET "0.0.0.0:8080/orders?status=paid" -u admin:password
    def to_json
      orders.all.to_json
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
    def orders
      @orders ||= begin
                    status = request.query["status"]
                    if status
                      Order.where(status: status)
                    else
                      Order
                    end
                  end
    end
  end
end
