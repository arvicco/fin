require 'fin/models/order'
require 'fin/book_manager'

module Fin
  # Represents list of ALL Orders, indexed by id (replId)
  # Its @books is a set of OrderBooks by isin. Each OrderBook lists Orders by price.
  class OrderList < ContainerList

    include BookManager

    def initialize
      super :item_type => Fin::Order
      @book_index = proc { |item| item.price }
      @book_condition = proc { |item| item.price > 0 }
    end
  end
end
