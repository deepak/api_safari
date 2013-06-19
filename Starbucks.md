http://www.infoq.com/articles/webber-rest-workflow

request:  

POST /orders
{orders: { drink: "coffee-latte" } }

response:  

201 created
Location: /orders/1234
{orders: { drink: "coffee-latte", price: 100, status: "payment-pending" } }

request:  

PUT /orders/1234
{orders: { drink: "coffee-latte", additions: ["milk-shot", "brown sugar"] } }
(PUT is idempotent)

response:  

200 OK
Location: /orders/1234
{orders: { drink: "coffee-latte", additions: ["milk-shot", "brown sugar"], price: 120, status: "payment-pending" } }

409 conflict (in case status is already paid)
Location: /orders/1234
{orders: { drink: "coffee-latte", price: 100, status: "paid" } }
(unchanged from before)

request:  

PUT /payment
{payment: {"order_id": 1, customer_name: "deepak", amount: 120} }
(not POST because PUT, GET and DELETE is idempotent)

response:  

201 Created
{payment: {"order_id": 1, customer_name: "deepak", amount: 120} }

request:  

GET /orders/1234

response:  

200 OK
Location: /orders/1234
{orders: { drink: "coffee-latte", additions: ["milk-shot", "brown sugar"], price: 120, status: "paid" } }

request:  

POST /orders?status=paid (with HTTP basic auth)

response:  

200 OK
{orders: [{ drink: "coffee-latte", additions: ["milk-shot", "brown sugar"], price: 120  },
         { drink: "coffee-mocha", price: 150 }]}

request:  

POST /order/1234/delivered

response:  

200 OK
Location: /orders/1234
{orders: { drink: "coffee-latte", additions: ["milk-shot", "brown sugar"], price: 120, status: "delivered" } }

