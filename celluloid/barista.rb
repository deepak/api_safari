require 'dcell'
require_relative 'libs'

DCell.start :id => "starbucks", :addr => "tcp://127.0.0.1:9005"
puts "started #{DCell.me}"

class Barista
  include Celluloid

  def initialize
    puts "open for business"
  end

  def list_orders user, password
    raise "not authenticated" unless authenticate!(user, password)
    @orders
  end

  def order(id)
    order = Model::Order.where(id: id).first
    unless order
      raise OrderNotFound.new "#{id} not found"
    end
    order.to_msgpack
  end

  def create_order drink
    coffee = Model::Coffee.where(name: drink).first
    if coffee
      order = Model::Order.take_order(coffee)
      order.save
      order.to_msgpack
    else
      raise CoffeeNotFound.new "#{coffee} not found"
    end
  end

  protected
  def authenticate! user, password
    {"admin" => "password"}[user] == password
  end
  
end

Barista.supervise_as :barista

puts "#{Celluloid::Actor[:barista]} is running"
sleep
