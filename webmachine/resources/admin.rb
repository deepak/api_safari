module Resources
  class Test < Webmachine::Resource
    include Webmachine::Resource::Authentication
    
    def to_html
      "<html><body>Hello, your order for #{@coffee.name} costing #{@coffee.price} will be ready shortly</body></html>"
    end

    def to_json
      { status: "processing",
        message: "your order for #{@coffee.name} costing #{@coffee.price} will be ready shortly"
      }.to_json
    end

    def coffee_name
      request.path_info[:coffee]
    end

    def store_coffee
      @coffee = Coffee.new_coffee(request.body.to_s)
      Coffee.add_to_menu(@coffee)
      201 # 204 No Content is the default
    end

    def is_authorized?(auth)
      request.method != 'PUT' || basic_auth(auth){ |*args| args == %W[admin password] }
    end

    def encodings_provided
      {"gzip" => :encode_gzip, "identity" => :encode_identity}
    end

    def allowed_methods
      %W[GET PUT] # HEAD
    end

    def content_types_accepted
      [["application/json", :store_coffee]]
    end

    def content_types_provided
      [["text/html", :to_html],
       ["application/json", :to_json]]
    end
    
    def resource_exists?
      @coffee = Coffee.find(coffee_name)
      return @coffee
    end

    def last_modified
      @coffee.updated_at
    end

    def generate_etag
      coffee = @coffee.to_a.join('|')
      Digest::MD5.hexdigest(coffee)
    end

    # TODO: weirdness.
    # curl -i -H "Accept: application/json" 0.0.0.0:8080/mocha
    # returns "#<Webmachine::Trace::ResourceProxy:0x007fe82c0cb568>"%
    # HTTP/1.1 200 OK
    # Content-Type: application/json
    # Vary: Accept, Accept-Encoding
    # Content-Length: 54
    # X-Webmachine-Trace-Id: 70317574085300
    # Server: Webmachine-Ruby/1.1.0 WEBrick/1.3.1 (Ruby/1.9.3/2013-05-15)
    # Date: Wed, 19 Jun 2013 05:11:52 GMT
    # Connection: Keep-Alive
    # "#<Webmachine::Trace::ResourceProxy:0x007fe82c0cb568>"%
    # def trace?; true; end
  end
end
