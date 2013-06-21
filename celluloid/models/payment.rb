class Model
  class Payment < ActiveRecord::Base
    belongs_to :order

    after_create :set_order_status_to_paid

    def set_order_status_to_paid
      self.order.paid
      self.order.save
    end

    def to_msgpack
      Data::Payment.new(self.order.id, self.customer_name, self.amount).to_msgpack
    end
  end
end
