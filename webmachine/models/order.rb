class Order < ActiveRecord::Base
  belongs_to  :coffee
  has_one     :payment
  
  before_save :calculate_total_cost

  STATUS_PAYMENT_PENDING = "payment-pending"
  STATUS_PAID = "paid"
  STATUS_DELIVERED = "delivered"
  STATUSES = [STATUS_PAYMENT_PENDING, STATUS_PAID, STATUS_DELIVERED]
  
  def self.take_order coffee
    Order.new(coffee: coffee, status: STATUS_PAYMENT_PENDING)
  end
  
  def calculate_total_cost
    if coffee
      self.total_price = coffee.price
    end
  end

  def as_json options = {}
    { order:
      { id: self.id, drink: self.coffee.name, price: self.coffee.price, status: self.status }
    }
  end

  def paid?
    STATUS_PAID == self.status
  end

  def paid
    self.status = STATUS_PAID
  end
end
