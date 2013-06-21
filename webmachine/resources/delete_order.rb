module Resources
  class DeleteOrder < Starbucks

    def allowed_methods
      %W[DELETE]
    end
    
    # Does the resource exist? Returning a falsey value (false or nil)
    # will result in a '404 Not Found' response.
    def resource_exists?
      if order_id
        !order.nil?
      else
        true
      end
    end

    # This method is called when a DELETE request should be enacted,
    # and should return true if the deletion succeeded. 
    def delete_resource
      @deleted_at = Time.now
      order.delete
    end
    
    protected
    def order_id
      request.query["id"]
    end

    def order
      @order ||= Order.where(id: order_id).first
    end
  end
end
