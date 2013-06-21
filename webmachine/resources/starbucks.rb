module Resources
  class Starbucks < Webmachine::Resource
    def encodings_provided
      {"gzip" => :encode_gzip, "identity" => :encode_identity}
    end

    # NOTE: no text/html
    def content_types_provided
      [["application/json", :to_json]]
    end

    def content_types_accepted
      [["application/json", :from_json]]
    end

    # Is the resource available? Returning a falsey value (false or
    # nil) will result in a '503 Service Not Available'
    # response. Defaults to true.  If the resource is only temporarily
    # not available, add a 'Retry-After' response header in the body
    # of the method.
    def service_available?
      # HTTP/1.1 503 Service Unavailable 
      # Retry-After: Fri, 21 Jun 2013 04:30:00 GMT
      now = Time.now
      morning = Time.parse("#{now.strftime('%Y-%m-%d')} 05:00:00")
      if now < morning
        response.headers['Retry-After'] = morning.httpdate
        false
      else
        true
      end
    end
    
    def handle_exception(e)
      @error = e
      
      if e.respond_to? :http_code
        return e.http_code
      else
        super
      end
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
