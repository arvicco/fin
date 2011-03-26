require 'orders/order_book'
require 'orders/booked_list'

module Orders
  # Represents list of ALL Orders, indexed by id (replId)
  # Its @books is a set of OrderBooks by isin. Each OrderBook lists Orders by price.
  class OrderList < BookedList

    def initialize
      super Orders::OrderBook
    end

    def index item
      item.id
    end
  end
end
