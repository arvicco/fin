require 'orders/models/order'
require 'orders/booked_list'

module Orders
  # Represents list of ALL Orders, indexed by id (replId)
  # Its @books is a set of OrderBooks by isin. Each OrderBook lists Orders by price.
  class OrderList < BookedList

    def initialize
      super :item_type => Orders::Order,
            :index => proc { |item| item.price },
            :check_condition => proc { |item| item.price > 0 }
    end
  end
end
