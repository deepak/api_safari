# Create an application which encompasses routes and configruation
MyApp = Webmachine::Application.new do |app|
  app.routes do
    # This can be any path as long as it ends with '*'
    # add ['trace', '*'], Webmachine::Trace::TraceResource
    
    add ['orders'], Resources::TakeOrder do |request|
      request.method == "POST"
    end

    add ['orders'], Resources::GetOrder do |request|
      request.method == "GET" && request.query["id"]
    end
    
    add ['orders'], Resources::ListOrders do |request|
      request.method == "GET"
    end
    
    add ['orders'], Resources::ModifyOrder do |request|
      request.method == "PUT"
    end

    add ['orders'], Resources::DeleteOrder do |request|
      request.method == "DELETE"
    end
    
    add ['payment'], Resources::AcceptPayment do |request|
      request.method == "PUT"
    end
  end
end
