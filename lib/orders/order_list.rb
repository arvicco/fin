require 'orders/models/order'
require 'orders/book_manager'

module Orders
  # Represents list of ALL Orders, indexed by id (replId)
  # Its @books is a set of OrderBooks by isin. Each OrderBook lists Orders by price.
  class OrderList < ContainerList

    include BookManager

    def initialize
      super :item_type => Orders::Order
      @book_index = proc { |item| item.price }
      @book_condition = proc { |item| item.price > 0 }
    end
  end
end
