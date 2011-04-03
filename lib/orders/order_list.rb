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

    def check item
      item.is_a?(Orders::Order) && item.id
    end

    def add_record rec
      add? Order.from_record(rec)
    end

    def remove_record rec, id
      index = Order.index_for rec
      remove? self[index]
    end

  end
end
