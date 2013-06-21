Order = Struct.new(:coffee, :status) do
  class << self
    def take_order coffee
      self.new(coffee, "payment-pending")
    end
  end
end
