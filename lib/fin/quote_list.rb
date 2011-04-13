require 'fin/models/quote'
require 'fin/book_manager'

module Fin
  # Represents list of ALL Quotes, indexed by id (replId)
  # Its @books is a set of QuoteBooks by isin. Each QuoteBook lists Quotes by price.
  class QuoteList < ContainerList

    include BookManager

    def initialize
      super :item_type => Fin::Quote
      @book_index = proc { |item| item.price }
      @book_condition = proc { |item| item.price > 0 }
    end
  end
end
