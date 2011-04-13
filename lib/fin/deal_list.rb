require 'fin/models/deal'
require 'fin/book_manager'

module Fin
  # Represents list of ALL Quotes, indexed by id (replId)
  # Its @books is a set of QuoteBooks by isin. Each QuoteBook lists Quotes by price.
  class DealList < ContainerList

    include BookManager

    def initialize
      super :item_type => Fin::Deal
      @book_index = proc { |item| item.deal_id }
    end

  end
end

