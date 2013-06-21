class Model
  class Coffee < ActiveRecord::Base
    def to_msgpack
      Data::Coffee.new(self.id, self.name, self.price).to_msgpack
    end
  end
end
