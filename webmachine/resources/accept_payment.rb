module Resources
  class AcceptPayment < Starbucks
    def allowed_methods
      %W[PUT]
    end

    def content_types_accepted
      [["application/json", :accept_payment]]
    end

    # If the request is malformed, this should return true, which will
    # result in a '400 Malformed Request' response. 
    def malformed_request?
      # NOTE: not concerned customer is over or under charged      
      from_json
      @order.nil?
    end
    
    def finish_request
      unless @error
        response.headers['Location'] = "/payment?order_id=#{@order.id}"
        response.body = @payment.to_json
      end
    end

    def from_json
      payment = JSON.parse(request.body.to_s)["payment"]

      @order_id = payment["order_id"]
      
      @order = Order.where(id: @order_id).first
      @payment = Payment.new(order: @order,
                             customer_name: payment["customer_name"],
                             amount: payment["amount"])
    end

    # "Accept: application/json" header is set
    # curl -i -H "Content-Type: application/json" -d '{"payment": {"order_id": 1, "customer_name": "deepak", "amount": 120} }' -X PUT 0.0.0.0:8080/payment
    def accept_payment
      from_json

      # raise Error::OrderNotFound.new(order_id) unless @order
      @payment.save
      
      200
    end

    protected
    def order_id
      @order_id
    end
  end
end
