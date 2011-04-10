require 'version'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'fin/container_list'
require 'fin/order_list'
require 'fin/deal_list'
require 'fin/models/deal'
require 'fin/models/order'
require 'fin/models/instrument'
require 'fin/models/position'
require 'fin/models/money_limit'