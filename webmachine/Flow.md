* talk about 
- content_types_provided ie. to_json the Accept Header and the serialization back
- content_types_accepted ie. from_json for POST and GET requests. Content-Type header

* various callbacks
  - is_conflict? Only called for PUT requests
  - malformed_request?
  - handle_exception(e)
  - finish_request
  - resource_exists? for returning a 404
  - last_modified set Last-Modified header
  - is_authorized?
  - service_available?
  

* POST a order
  curl -i -H "Content-Type: application/json" -d '{"order":{"drinks":"latte"}}' -X POST 0.0.0.0:8080/orders

* use the content of the location header to GET the order
  curl -i -H "Accept: application/json" -X GET "http://0.0.0.0:8080/orders?id=2" -u admin:password

* POST a order with a non-existent drink
  curl -i -H "Content-Type: application/json" -d '{"order":{"drinks":"choco filter"}}' -X POST 0.0.0.0:8080/orders
  and check that it was not inserted by GET-ing a list of orders
  curl -i -H "Accept: application/json" -X GET "0.0.0.0:8080/orders" -u admin:password

* can modify an order until it is not paid for
  # Accept: application/json is set by default
  curl -i -H "Content-Type: application/json" -d '{"order":{"drinks":"latte"}}' -X PUT "0.0.0.0:8080/orders?id=1"

* pay for an order
  curl -i -H "Content-Type: application/json" -d '{"payment": {"order_id": 1, "customer_name": "deepak", "amount": 120} }' -X PUT 0.0.0.0:8080/payment
  
* now try to modify the paid order
  curl -i -H "Content-Type: application/json" -d '{"order":{"drinks":"latte"}}' -X PUT "0.0.0.0:8080/orders?id=1"