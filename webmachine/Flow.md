* POST a order
  curl -i -H "Content-Type: application/json" -d '{"order":{"drinks":"latte"}}' -X POST 0.0.0.0:8080/orders

* use the content of the location header to make a request
  curl -i -H "Accept: application/json" -X GET "http://0.0.0.0:8080/orders?id=2" -u admin:password

* POST a order with a non-existent drink
  curl -i -H "Content-Type: application/json" -d '{"order":{"drinks":"choco filter"}}' -X POST 0.0.0.0:8080/orders

* GET a particular order
  