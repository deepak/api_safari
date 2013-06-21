require "logger"
require "msgpack"
require "active_record"
require 'pp'

require 'debugger'

require_relative 'database_connect'

require_relative "models/coffee"
require_relative "models/order"
require_relative "models/payment"

require_relative "data/msgpack_struct"
require_relative "data/coffee"
require_relative "data/order"
require_relative "data/payment"

require_relative "models/coffee"
require_relative "models/order"
require_relative "models/payment"

require_relative "errors/coffee_not_found"
require_relative "errors/order_not_found"
