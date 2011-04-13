require 'fin/models/aggr_order'
require 'fin/book_manager'

module Fin
  # Represents list of ALL AggrOrders, indexed by id (replId)
  # Its @books is a set of OrderBooks by isin. Each OrderBook lists AggrOrders by price.
  class AggrOrderList < ContainerList

    include BookManager

    def initialize
      super :item_type => Fin::AggrOrder
      @book_index = proc { |item| item.price }
      @book_condition = proc { |item| item.price > 0 }
    end
  end
end
