require 'dcell'
require_relative 'libs'

# NOTE: no DRbUndumped as in DRb. less magic
require_relative "models/order"
require_relative "errors/coffee_not_found"

DCell.start :id => "customer", :addr => "tcp://127.0.0.1:9006"
puts "started #{DCell.me}"

$starbucks = DCell::Node["starbucks"]

def place_order coffee
  order_msg = $starbucks[:barista].create_order(coffee)
  Data::Order.from_msgpack(order_msg)
rescue CoffeeNotFound => e
  puts e.to_s
  nil
end

def get_order order_id
  order_msg = $starbucks[:barista].order(order_id)
  Data::Order.from_msgpack(order_msg)
rescue OrderNotFound => e
  puts e.to_s
  nil
end

order = place_order('mocha')
pp order

pp place_order('foobar')

pp get_order(order.id)



