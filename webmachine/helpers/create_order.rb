module Helper
  module CreateOrder
    def to_json
      @order.to_json
    end

    def drink
      @drink ||= begin
                   incoming = JSON.parse(request.body.to_s)["order"]
                   incoming["drinks"]
                 end
    end
    
    def from_json
      @coffee = Coffee.where(name: drink).first
    end

    # This method is called just before the final response is
    # constructed and sent. The return value is ignored, so any effect
    # of this method must be by modifying the response.
    def finish_request
      unless @error
        response.headers['Location'] = "/orders?id=#{@order.id}"
        response.body = @order.to_json
      end
    end
  end
end
