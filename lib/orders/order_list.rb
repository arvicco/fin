require 'orders/order_book'
require 'orders/booked_list'

module Orders
  # Represents list of ALL Orders, indexed by id (replId)
  class OrderList < BookedList
    attr_accessor :books

    def initialize
      super Orders::OrderBook
    end

    def index item
      item.id
    end
  end
end
