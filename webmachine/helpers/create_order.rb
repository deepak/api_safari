module Helper
  module CreateOrder
    def to_json
      @order.to_json
    end

    def drink
      @drink ||= begin
                   incoming = JSON.parse(request.body.to_s)["orders"]
                   incoming["drinks"]
                 end
    end
    
    def from_json
      @coffee = Coffee.where(name: drink).first
    end

    def finish_request
      unless @error
        response.headers['Location'] = "/orders/#{@order.id}"
        response.body = @order.to_json
      end
    end
  end
end
