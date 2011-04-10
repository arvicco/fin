require 'fin/models/deal'
require 'fin/book_manager'

module Fin
  # Represents list of ALL Orders, indexed by id (replId)
  # Its @books is a set of OrderBooks by isin. Each OrderBook lists Orders by price.
  class DealList < ContainerList

    include BookManager

    def initialize
      super :item_type => Fin::Deal
      @book_index = proc { |item| item.deal_id }
    end

  end
end

