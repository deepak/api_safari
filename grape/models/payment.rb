class Payment < ActiveRecord::Base
  belongs_to :order

  after_create :set_order_status_to_paid

  def set_order_status_to_paid
    self.order.paid
    self.order.save
  end

  def as_json options = {}
    { payment:
      { order_id: self.order.id,
        customer_name: self.customer_name,
        amount: self.amount,
        amount: self.amount},
      order: { drink: self.order.coffee.name, price: self.order.coffee.price, status: self.order.status }
    }
  end
  
end
