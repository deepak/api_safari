require 'grape'
require 'logger'
require "active_record"

require_relative 'database_connect'

require_relative 'models/coffee'
require_relative 'models/order'
require_relative 'models/payment'

module Starbucks
  class API < Grape::API
    prefix 'starbucks'
    version 'v2' #, using: :header, vendor: 'starbucks'
    format :json
    
    resource :admin do
      http_basic do |username, password|
        { 'admin' => 'password' }[username] == password
      end
      
      resource :orders do
        version 'v1' do
          # curl -i -H "Accept: application/json" -X GET "0.0.0.0:8080/starbucks/v2/admin/orders" -u admin:password
          desc "list all paid orders for the barista"
          get do
            Order.where(status: 'paid').all
          end
        end

        # curl -i -X GET "0.0.0.0:8080/starbucks/v2/admin/orders.json?status=paid" -u admin:password
        # curl -i -H "Accept: application/json" -X GET "0.0.0.0:8080/starbucks/v2/admin/orders?status=paid" -u admin:password
        desc "list all orders for the barista"
        get do
          status = params.status
          if status
            Order.where(status: status).all
          else
            Order.all
          end
        end
      end
    end # resource :admin
    
    resource :orders do
      desc "get a order"
      get '/:id' do
        order = Order.where(id: params.id).first

        unless order
          throw :error, status: 404, message: "order: #{params[:id]} not found"
        end

        header "Last-Modified", order.updated_at.httpdate
        order
      end
      
      # NOTE: posting to 0.0.0.0:8080/orders.json will not work
      # curl -i -H "Content-Type: application/json" -d '{"orders":{"drinks":"mocha"}}' -X POST 0.0.0.0:8080/starbucks/v2/orders
      desc "take an order"
      post do
        drink = params.orders.drinks
        @coffee = Coffee.where(name: drink).first
        
        @order = Order.take_order @coffee      
        @order.save
        @order
      end

      # curl -i -H "Content-Type: application/json" -d '{"orders":{"drinks":"latte"}}' -X PUT "0.0.0.0:8080/starbucks/v2/orders?id=1"
      desc "modify a order"
      put do
        drink = params.orders.drinks
        order_id = params.id
        
        @coffee = Coffee.where(name: drink).first
        @order = Order.where(id: order_id).first

        @order.coffee = @coffee
        @order.save
        @order
      end
    end # resource :orders

    resource :payment do
      # curl -i -H "Content-Type: application/json" -d '{"payment": {"order_id": 1, "customer_name": "deepak", "amount": 120} }' -X POST 0.0.0.0:8080/starbucks/v2/payment
      desc "create a payment"
      put do
        payment = params.payment
        order_id = payment.order_id
        
        @order = Order.where(id: order_id).first
        @payment = Payment.new(order: @order,
                               customer_name: payment.customer_name,
                               amount: payment.amount)
        @payment.save
        @payment
      end
    end
  end
end
