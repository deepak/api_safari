require 'webmachine'
require 'logger'
require 'time'
require 'digest/md5'
require 'json'
require "active_record"

require_relative 'database_connect'
require_relative 'models/coffee'
require_relative 'models/order'
require_relative 'models/payment'

require_relative 'errors/order_not_found'
require_relative 'helpers/create_order'

require_relative 'resources/starbucks'
require_relative 'resources/take_order'
require_relative 'resources/list_orders'
require_relative 'resources/get_order'
require_relative 'resources/modify_order'
require_relative 'resources/delete_order'
require_relative 'resources/accept_payment'
