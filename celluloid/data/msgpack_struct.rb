class MsgpackStruct < Struct
  def to_msgpack
    values.to_msgpack
  end
  
  def self.from_msgpack msg
    self.new *MessagePack.unpack(msg) 
  end
end
