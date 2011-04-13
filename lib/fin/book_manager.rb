require 'fin/book'
require 'fin/container_list'

module Fin
  # Adds to including List a set of @books, each related to a single security(isin).
  # @books is effectively an additional index in a List, a set of containers for
  # its items, grouped by item's isin_id.
  # For example: QuoteBook, DealBook
  #
  module BookManager

    def books
      @books ||= Hash.new do |hash, key|
        hash[key] = Book.new :isin_id => key,
                             :item_type => @item_type,
                             :book_index => @book_index,
                             :book_condition => @book_condition
        hash[key]
      end
    end

    # Overwrites/removes existing item with the same index
    def add? item
      if check item
        old_item = self[index item]
        remove old_item if old_item # Remove old item with the same index(id)
        if super
          books[item.isin_id].add item # Add item to appropriate order book
          item
        end
      end
    end

    def remove? item
      if super
        # Removing item from appropriate order book when it's deleted from order list
        books[item.isin_id].remove item
        item
      end
    end
  end
end
